// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors, use_build_context_synchronously
part of hyperlocal_shophome_view;

class _HyperlocalShophomeMobile extends StatefulWidget {
  final String? lat;
  final String? lng;
  const _HyperlocalShophomeMobile({
    required this.lat,
    required this.lng,
  });

  @override
  State<_HyperlocalShophomeMobile> createState() =>
      _HyperlocalShophomeMobileState();
}

class _HyperlocalShophomeMobileState extends State<_HyperlocalShophomeMobile>
    with LogMixin, TickerProviderStateMixin {
  CustomerModel? customerModel;
  String flat = '';
  String? lat;
  String? lng;
  NetworkCall networkcall = NetworkCall();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final ScrollController _shopScroll = ScrollController();
  final AllListController _allListController = Get.find();
  final ProfileController _profileController = Get.find();
  final HomeController _homeController = Get.find();
  final NotificationController _notificationController = Get.find();
  final APIs apiController = Get.find();
  List<HyperLocalShopWidget> shopWidgets = [];
  List<HyperLocalShopWidget> searchWidgets = [];
  List<HyperLocalShopModel> shopModels = [];
  List<HyperLocalShopModel> searchModels = [];
  List<HyperLocalShopModel> existingShopModels = [];
  bool _isLoading = false;
  bool _isSearchLoading = false;
  bool _initializing = false;
  int n = 0;
  int nSearch = 0;
  bool _showBrowseShops = false;
  bool _showSearchText = false;

  initFunction() async {
    _homeController.homeTabController =
        TabController(length: 3, vsync: this, initialIndex: 0);
    sv.SystemChrome.setSystemUIOverlayStyle(const sv.SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    final token = await AppHelpers().getToken;
    await _profileController.initialise();
    await _profileController.getOperationalStatus();
    _allListController.getAllList();
    _allListController.checkSubPlan();
    /*Connectivity().onConnectivityChanged.listen((ConnectivityResult result) =>
        _connectivityController.listenConnectivity(result));*/
    APIs().updateDeviceToken(
      AppHelpers()
          .getPhoneNumberWithoutFoundedCountryCode(AppHelpers().getPhoneNumber),
    );
    apiController.searchedItemResult('potato');
    apiController.updatFCMONstart(fcmToken: token);
    _notificationController.fromNotification = false;
  }

  getNewShops(
      {required List<HyperLocalShopWidget> shops, required int limit}) async {
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/hyperlocal/merchant/list?lat=${customerModel?.lat}&lang=${customerModel?.lng}&limit=10&offset=$limit');
    setState(() {
      _isLoading = true;
    });
    try {
      debugLog('HyperLocal Url for Shops $url');
      final response = await http.get(url);
      warningLog(
          'Response Structure ${response.statusCode} and body ${response.body} also url $url');
      final responseBody = json.decode(response.body)['data'] as List;
      warningLog('Response Body Structure $responseBody');
      List<HyperLocalShopModel> localHyperLocalShopModel = [];

      for (var element in responseBody) {
        // errorLog('Checking for data in getHyperlocalShops $element');
        localHyperLocalShopModel.add(HyperLocalShopModel.fromMap(element));
      }
      infoLog('New models $localHyperLocalShopModel');
      List<HyperLocalShopWidget> newShops = [];
      for (var element in localHyperLocalShopModel) {
        newShops.add(HyperLocalShopWidget(hyperLocalShopModel: element));
      }
      infoLog('New Shops $newShops');
      shops.addAll(newShops);
      setState(() {
        shopWidgets = shops;
        _isLoading = false;
        existingShopModels.addAll(localHyperLocalShopModel);
      });
    } catch (e) {
      throw HyperLocalGetShopErrorState(message: e.toString());
    }
  }

  getSearchNewShop(
      {required List<HyperLocalShopWidget> shops, required int limit}) async {
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/hyperlocal/product/search?limit=10&offset=$nSearch&item_name=${_textEditingController.text}&lat=${customerModel?.lat}&lang=${customerModel?.lng}}');
    setState(() {
      _isSearchLoading = true;
    });
    try {
      debugLog('HyperLocal Url for Shops $url');
      final response = await http.get(url);
      warningLog(
          'Response Structure ${response.statusCode} and body ${response.body} also url $url');
      final responseBody = json.decode(response.body)['data']['rows'] as List;
      warningLog('Response Body Structure $responseBody');
      List<HyperLocalShopModel> localHyperLocalShopModel = [];

      for (var element in responseBody) {
        // errorLog('Checking for data in getHyperlocalShops $element');
        localHyperLocalShopModel.add(HyperLocalShopModel.fromMap(element));
      }
      infoLog('New models $localHyperLocalShopModel');
      List<HyperLocalShopWidget> newShops = [];
      for (var element in localHyperLocalShopModel) {
        newShops.add(HyperLocalShopWidget(hyperLocalShopModel: element));
      }
      infoLog('New Shops $newShops');
      shops.addAll(newShops);
      setState(() {
        searchWidgets = shops;
        _isSearchLoading = false;
      });
    } catch (e) {
      throw HyperLocalGetShopSearchErrorState(
        message: e.toString(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _initializing = true;
    });
    initFunction();
    getCustomerInfo();

    _shopScroll.addListener(() {
      if (_shopScroll.position.pixels == _shopScroll.position.maxScrollExtent) {
        warningLog('called');
        setState(() {
          n = n + 10;
        });
        getNewShops(
          shops: shopWidgets,
          limit: n,
        );
      }
    });
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        warningLog('Search Scroll Called');
        setState(() {
          nSearch = nSearch + 10;
        });
        getSearchNewShop(shops: searchWidgets, limit: nSearch);
      }
    });
  }

  getCustomerInfo() async {
    customerModel = await networkcall.getCustomerDetails();
    setState(() {
      lat = customerModel!.lat;
      lng = customerModel!.lng;
    });

    errorLog('$lat and lng $lng');
    context.read<AddressBloc>().add(
          GetAddressListEvent(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    debugLog(
        '${RepositoryProvider.of<AddressRepository>(context).deliveryModel?.flat}');
    return BlocConsumer<AddressBloc, AddressState>(
      listener: (context, state) {
        warningLog('Listening $state');
        if (state is GotAddressListAndIdState) {
          context.read<AddressBloc>().add(ResetAddressEvent());
          context.read<HyperlocalShopBloc>().add(
                HyperLocalGetShopEvent(
                    lat: RepositoryProvider.of<AddressRepository>(context)
                        .deliveryModel!
                        .lat,
                    lng: RepositoryProvider.of<AddressRepository>(context)
                        .deliveryModel!
                        .lng),
              );
        }
      },
      builder: (context, state) {
        return BlocConsumer<HyperlocalShopBloc, HyperlocalShopState>(
          listener: (context, state) {
            warningLog('Current State $state');
            if (state is HyperLocalGetShopErrorState) {
              setState(() {
                _initializing = false;
              });
            }
            if (state is HyperLocalGetShopsState) {
              List<HyperLocalShopWidget> localShops = [];
              shopModels = [];
              shopWidgets = [];
              shopModels = state.hyperLocalShopModels;
              warningLog('${shopModels.length}');
              for (var element in shopModels) {
                localShops.add(
                  HyperLocalShopWidget(hyperLocalShopModel: element),
                );
              }
              warningLog('$localShops');
              setState(() {
                shopWidgets = localShops;
                existingShopModels = shopModels;
                _showBrowseShops = true;
                _showSearchText = false;
                _initializing = false;
              });
            }
            if (state is HyperLocalGetShopSearchState) {
              List<HyperLocalShopWidget> searchShops = [];
              searchModels = state.searchModels;
              for (var element in searchModels) {
                searchShops.add(
                  HyperLocalShopWidget(hyperLocalShopModel: element),
                );
              }
              setState(() {
                searchWidgets = searchShops;
                _showBrowseShops = false;
                _showSearchText = true;
              });
              // context.read<HyperlocalShopBloc>().add(HyperLocalGetResetEvent());
            }
            if (state is HyperLocalGetShopSearchClearState) {
              shopModels = [];
              List<HyperLocalShopWidget> shops = [];
              shopModels = state.previousModels;
              for (var element in shopModels) {
                shops.add(HyperLocalShopWidget(hyperLocalShopModel: element));
              }
              setState(() {
                shopWidgets = shops;
                existingShopModels = shopModels;
                _showBrowseShops = true;
                _showSearchText = false;
              });
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Scaffold(
                  key: _key,
                  drawer: const CustomNavigationDrawer(),
                  backgroundColor: CupertinoColors.systemBackground,
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: () async {
                        //!something to add
                        //APIs().updateDeviceToken(AppHelpers().getPhoneNumberWithoutCountryCode) ;
                        /*log(await AppHelpers().getToken);
                        sendNotification('tesst');*/
                        _key.currentState!.openDrawer();
                        /*FirebaseAnalytics.instance.logEvent(
                          name: "select_content",
                          parameters: {
                            "content_type": "image",
                            "item_id": 'itemId',
                          },
                        ).then((value) => print('success')).catchError((e) => print(e.toString()));*/
                      },
                      splashRadius: 25.0,
                      icon: SvgPicture.asset(
                        'assets/drawer_icon.svg',
                        color: Colors.white,
                      ),
                    ),
                    shadowColor: Colors.orange.withOpacity(0.5),
                    elevation: 10.0,
                    title: const AutoSizeText(
                      kAppName,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 24),
                    ),
                    // actions: [
                    //   Padding(
                    //     padding: const EdgeInsets.only(right: 4.5),
                    //     child: IconButton(
                    //       onPressed: () {
                    //         Get.to(OndcCheckOutScreenMobile());
                    //       },
                    //       splashRadius: 25.0,
                    //       icon: InkWell(
                    //         onTap: () {
                    //           // Get.to(
                    //           //   () => OndcIntroView(),
                    //           // );
                    //         },
                    //         child: const Icon(
                    //           Icons.home,
                    //           color: Colors.white,
                    //           size: 27.0,
                    //         ),
                    //       ),
                    //     ),
                    //   )
                    // ],
                  ),
                  body: state is HyperLocalGetLoadingState
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              Text(
                                'Getting Hyperlocal shops near you',
                                style: TextStyle(
                                  color: AppColors().brandDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : state is HyperLocalGetShopSearchClearLoadingState
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  Text(
                                    'Loading Previous Shops',
                                    style: TextStyle(
                                      color: AppColors().brandDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : state is HyperLocalGetShopSearchLoadingState
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      Text(
                                        'Getting shops servicing your search',
                                        style: TextStyle(
                                          color: AppColors().brandDark,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  controller:
                                      state is HyperLocalGetShopSearchState
                                          ? _controller
                                          : _shopScroll,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => const MapTextView(
                                              whichScreen: 'Hyperlocal',
                                            ),
                                          );
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                color: CupertinoColors
                                                    .systemBackground,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.133,
                                                width: 300,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8.0,
                                                    left: 25,
                                                  ),
                                                  child: BlocConsumer<
                                                      AddressBloc,
                                                      AddressState>(
                                                    listener: (context, state) {
                                                      errorLog(
                                                          'Address Bloc in hyperLocal$state');
                                                      if (state
                                                          is GotAddressListAndIdState) {
                                                        setState(() {
                                                          flat = RepositoryProvider
                                                                  .of<AddressRepository>(
                                                                      context)
                                                              .deliveryModel
                                                              ?.flat;
                                                        });
                                                      }
                                                    },
                                                    builder: (context, state) {
                                                      return Text.rich(
                                                        TextSpan(
                                                          text: 'Delivery to: ',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  '${RepositoryProvider.of<AddressRepository>(context).deliveryModel?.flat}',
                                                              // widget
                                                              //     .customerModel.address
                                                              //     .substring(0, 25),

                                                              style:
                                                                  const TextStyle(
                                                                decorationColor:
                                                                    Color
                                                                        .fromARGB(
                                                                  255,
                                                                  77,
                                                                  81,
                                                                  84,
                                                                ),
                                                                fontSize: 14,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            // can add more TextSpans here...
                                                          ],
                                                        ),
                                                        style: TextStyle(
                                                          overflow:
                                                              TextOverflow.fade,
                                                          fontSize: 12,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //! add the indicator here
                                            // GestureDetector(
                                            //   onTap: () => ge.Get.to(
                                            //     OndcCartView(),
                                            //   ),
                                            //   child: Stack(
                                            //     children: [
                                            //       Image.asset(
                                            //         'assets/newshoppingcartorange.png',
                                            //         height: 45,
                                            //         width: 45,
                                            //       )
                                            //     ],
                                            //   ),
                                            // ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20, top: 5),
                                              child: Image.asset(
                                                  'assets/edit.png'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 8),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: TextFormField(
                                            controller: _textEditingController,
                                            inputFormatters: [
                                              NoLeadingSpaceFormatter(),
                                            ],
                                            onFieldSubmitted: (value) {
                                              context
                                                  .read<HyperlocalShopBloc>()
                                                  .add(
                                                    HyperLocalGetShopSearchEvent(
                                                        lat: RepositoryProvider
                                                                .of<AddressRepository>(
                                                                    context)
                                                            .deliveryModel!
                                                            .lat,
                                                        lng: RepositoryProvider
                                                                .of<AddressRepository>(
                                                                    context)
                                                            .deliveryModel!
                                                            .lng,
                                                        itemName:
                                                            _textEditingController
                                                                .text),
                                                  );
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'Search Products here',
                                              isDense: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              suffixIcon: state
                                                      is HyperLocalGetShopSearchState
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        context
                                                            .read<
                                                                HyperlocalShopBloc>()
                                                            .add(
                                                              HyperLocalClearSearchEventShops(
                                                                  previousModels:
                                                                      existingShopModels,
                                                                  lat: RepositoryProvider.of<
                                                                              AddressRepository>(
                                                                          context)
                                                                      .deliveryModel!
                                                                      .lat,
                                                                  lng: RepositoryProvider.of<
                                                                              AddressRepository>(
                                                                          context)
                                                                      .deliveryModel!
                                                                      .lng),
                                                            );
                                                        // setState(() {
                                                        //   _searchedLoaded = false;
                                                        // });
                                                        // context.read<HyperlocalShopBloc>().add(
                                                        //       ClearSearchEventShops(
                                                        //           shopModels:
                                                        //               existingShopModels),
                                                        //     );
                                                        // context
                                                        //     .read<OndcBloc>()
                                                        //     .add(
                                                        //       FetchNearByShops(
                                                        //         lat: widget
                                                        //             .customerModel
                                                        //             .lat,
                                                        //         lng: widget
                                                        //             .customerModel
                                                        //             .lng,
                                                        //         pincode: widget
                                                        //             .customerModel
                                                        //             .pinCode,
                                                        //         isDelivery: widget
                                                        //             .customerModel
                                                        //             .opStats,
                                                        //       ),
                                                        //     );
                                                        _textEditingController
                                                            .clear();
                                                      },
                                                      child: const Icon(
                                                          Icons.cancel),
                                                    )
                                                  : null,
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 9.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    context
                                                        .read<
                                                            HyperlocalShopBloc>()
                                                        .add(
                                                          HyperLocalGetShopSearchEvent(
                                                            lat: RepositoryProvider
                                                                    .of<AddressRepository>(
                                                                        context)
                                                                .deliveryModel!
                                                                .lat,
                                                            lng: RepositoryProvider
                                                                    .of<AddressRepository>(
                                                                        context)
                                                                .deliveryModel!
                                                                .lng,
                                                            itemName:
                                                                _textEditingController
                                                                    .text,
                                                          ),
                                                        );
                                                  },
                                                  child: const Icon(
                                                    CupertinoIcons
                                                        .search_circle_fill,
                                                    size: 32,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      state is HyperLocalSearchItemLoadedState
                                          ? Text('')
                                          : Center(
                                              child: Text(
                                                'OR',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15),
                                              ),
                                            ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      _showSearchText
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    'Below are the shops that sell "${_textEditingController.text.toString().capitalizeFirst}"'),
                                              ),
                                            )
                                          : SizedBox(),
                                      _showBrowseShops
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Browse your local Shops',
                                                  style: TextStyle(
                                                    color: AppColors().black100,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      // state is HyperLocalSearchItemLoadedState
                                      //     ? searchWidgets.isEmpty
                                      //         ? Text('')

                                      //     : Padding(
                                      //         padding: const EdgeInsets.only(
                                      //             left: 25.0),
                                      //         child: Align(
                                      //           alignment: Alignment.centerLeft,
                                      //           child: Text(
                                      //               'Browse your Local Shops'),
                                      //         ),
                                      //       ),
                                      SingleChildScrollView(
                                        child: state
                                                is HyperLocalGetShopSearchState
                                            ? searchWidgets.isEmpty
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            18.0),
                                                    child: Text(
                                                      'Unfortunately there are no shops that sell the product you are looking for.Please try to search for something different',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: AppColors()
                                                            .brandDark,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  )
                                                : Column(
                                                    children: searchWidgets,
                                                  )
                                            : state is HyperLocalGetShopSearchClearLoadingState
                                                ? Center(
                                                    child: Column(
                                                      children: [
                                                        CircularProgressIndicator(),
                                                        Text(
                                                          'Loading Previous Shops',
                                                          style: TextStyle(
                                                            color: AppColors()
                                                                .brandDark,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : shopWidgets.isEmpty
                                                    ? Center(
                                                        child: Text(
                                                          'Unfortunately, there no shops in your neighborhood are on Santhe yet. We will notify you as soon as there are shops servicing your address.',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: AppColors()
                                                                .brandDark,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      )
                                                    : Column(
                                                        children: shopWidgets,
                                                      ),
                                      ),
                                      _isLoading
                                          ? Column(
                                              children: const [
                                                Center(
                                                  // heightFactor: 0.8,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(
                                              height: 60,
                                            ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                ),
                ),
                _initializing
                    ? Material(
                        child: Column(
                          children: [
                            AppBar(
                              leading: IconButton(
                                onPressed: () async {
                                  //!something to add
                                  //APIs().updateDeviceToken(AppHelpers().getPhoneNumberWithoutCountryCode) ;
                                  /*log(await AppHelpers().getToken);
                      sendNotification('tesst');*/
                                  _key.currentState!.openDrawer();
                                  /*FirebaseAnalytics.instance.logEvent(
                        name: "select_content",
                        parameters: {
                          "content_type": "image",
                          "item_id": 'itemId',
                        },
                      ).then((value) => print('success')).catchError((e) => print(e.toString()));*/
                                },
                                splashRadius: 25.0,
                                icon: SvgPicture.asset(
                                  'assets/drawer_icon.svg',
                                  color: Colors.white,
                                ),
                              ),
                              shadowColor: Colors.orange.withOpacity(0.5),
                              elevation: 10.0,
                              title: const AutoSizeText(
                                kAppName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontSize: 24),
                              ),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.5),
                                  child: IconButton(
                                    onPressed: () {
                                      // ge.Get.to(
                                      //   () => const OndcIntroView(),
                                      //   transition: ge.Transition.rightToLeft,
                                      // );
                                      // Get.off(
                                      //     HyperlocalShophomeView(
                                      //         lat: profileController
                                      //             .customerDetails!.lat,
                                      //         lng: profileController
                                      //             .customerDetails!.lng),
                                      //     );
                                    },
                                    splashRadius: 25.0,
                                    icon: InkWell(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.home,
                                        color: Colors.white,
                                        size: 27.0,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.45,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  Text(
                                    'Loading',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColors().brandDark,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox()
              ],
            );
          },
        );
      },
    );
  }
}
