// ignore_for_file: public_member_api_docs, sort_constructors_first
part of hyperlocal_shopdetails_view;

class _HyperlocalShopdetailsMobile extends StatefulWidget {
  final HyperLocalShopModel hyperLocalShopModel;

  const _HyperlocalShopdetailsMobile({required this.hyperLocalShopModel});

  @override
  State<_HyperlocalShopdetailsMobile> createState() =>
      _HyperlocalShopdetailsMobileState();
}

class _HyperlocalShopdetailsMobileState
    extends State<_HyperlocalShopdetailsMobile> with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final TextEditingController _textEditingController = TextEditingController();
  String productNameLocal = '';
  dynamic cartCount = 0;
  List<HyperLocalProductWidget> productWidgets = [];
  List<HyperLocalProductModel> productModels = [];
  List<HyperLocalProductWidget> searchWidgets = [];
  List<HyperLocalProductModel> searchModels = [];
  List<HyperLocalProductModel> existingModels = [];
  List<HyperLocalProductModel> searchExistingModels = [];
  final ScrollController _scrollController = ScrollController();
  final ScrollController _searchScrollController = ScrollController();
  final profileController = ge.Get.find<ProfileController>();
  int n = 0;
  int nsearch = 0;
  dynamic homeDeliveryGlo;
  bool _isLoading = false;
  bool _isSearchLoading = false;
  getHomeDelivery() {
    final homeDelivery =
        json.decode(widget.hyperLocalShopModel.fulfillment_type.toString());
    warningLog('Home Delivery $homeDelivery');
    homeDeliveryGlo = homeDelivery['home_delivery'];
    warningLog('HomeDeliveryFormatted $homeDeliveryGlo');
  }

  fetchData({
    required List<HyperLocalProductWidget> productWidgetsLocal,
    required String shopId,
  }) async {
    final url = Uri.parse(
        '${AppUrl().baseUrl}/santhe/hyperlocal/product/list?'
            'store_description_id=${widget.hyperLocalShopModel.id}&'
            'limit=10&offset=$n&'
            'lat=${RepositoryProvider.of<AddressRepository>(context).deliveryModel!.lat}&'
            'lang=${RepositoryProvider.of<AddressRepository>(context).deliveryModel!.lng}');
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(url);
      warningLog('statusCode of Get from screen ${response.statusCode} and url $url');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;
      dynamic _itemCount = json.decode(response.body)['data']['count'];
      debugLog('Body of the products ${responseBody.length}');
      List<HyperLocalProductModel> localHyperLocalProductModel = [];
      // final HyperLocalShopModel hyperLocal =
      //     HyperLocalShopModel.fromMap(responseBody.first);
      // warningLog('Checking for ${hyperLocal}');
      for (var element in responseBody) {
        localHyperLocalProductModel.add(
          HyperLocalProductModel.fromMap(element),
        );
      }
      List<HyperLocalProductWidget> addableItems = [];
      for (var element in localHyperLocalProductModel) {
        addableItems
            .add(HyperLocalProductWidget(hyperLocalProductModel: element));
      }
      warningLog('Addable Items $addableItems');
      productWidgetsLocal.addAll(addableItems);
      productModels.addAll(localHyperLocalProductModel);
      setState(() {
        productWidgets = productWidgetsLocal;
        existingModels = productModels;
        _isLoading = false;
      });
    } catch (e) {
      throw HyperLocalGetProductsOfShopErrorState(
        message: e.toString(),
      );
    }
  }

  fetchNewSearchItems(
      {required List<HyperLocalProductWidget> searchProductLocal,
      required String shopId,
      required String productName}) async {
    final url = Uri.parse(
        '${AppUrl().baseUrl}/santhe/hyperlocal/product/search?store_description_id'
            '=${widget.hyperLocalShopModel.id}&limit=10&offset=$n&item_'
            'name=$productName&lat=${RepositoryProvider.of<AddressRepository>(context).deliveryModel!.lat}&'
            'lang=${RepositoryProvider.of<AddressRepository>(context).deliveryModel!.lng}');
    setState(() {

      _isSearchLoading = true;
    });
    try {
      final response = await http.get(url);
      warningLog('statusCode of Get from screen ${response.statusCode} and url $url');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;
      int _itemCount = json.decode(response.body)['data']['count'];
      debugLog('Body of the products ${responseBody.length}');
      List<HyperLocalProductModel> localHyperLocalProductModel = [];
      // final HyperLocalShopModel hyperLocal =
      //     HyperLocalShopModel.fromMap(responseBody.first);
      // warningLog('Checking for ${hyperLocal}');
      for (var element in responseBody) {
        localHyperLocalProductModel.add(
          HyperLocalProductModel.fromMap(element),
        );
      }
      List<HyperLocalProductWidget> addableItems = [];
      for (var element in localHyperLocalProductModel) {
        addableItems
            .add(HyperLocalProductWidget(hyperLocalProductModel: element));
      }
      warningLog('Addable Items $addableItems');
      searchProductLocal.addAll(addableItems);
      searchModels.addAll(localHyperLocalProductModel);
      setState(() {
        searchWidgets = searchProductLocal;
        searchExistingModels.addAll(searchModels);
        _isSearchLoading = false;
      });
    } catch (e) {
      throw HyperLocalGetSearchProductsOfShopErrorState(
        message: e.toString(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getHomeDelivery();
if(mounted){
  context.read<HyperlocalShopBloc>().add(
      HyperLocalGetProductOfShopEvent(
        shopId: widget.hyperLocalShopModel.id,
        lat: RepositoryProvider.of<AddressRepository>(context)
            .deliveryModel!
            .lat,
        lng: RepositoryProvider
            .of<AddressRepository>(
            context)
            .deliveryModel!
            .lng,)
  );
}
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          n = n + 10;
        });
      if(mounted){
        fetchData(
          productWidgetsLocal: productWidgets,
          shopId: widget.hyperLocalShopModel.id,
        );
      }

      }
    });

    _searchScrollController.addListener(() {
      if (_searchScrollController.position.pixels ==
          _searchScrollController.position.maxScrollExtent) {
        setState(() {
          nsearch = nsearch + 10;
        });
        warningLog('new search items and limit $nsearch');
        fetchNewSearchItems(
          shopId: widget.hyperLocalShopModel.id,
          productName: _textEditingController.text,
          searchProductLocal: searchWidgets,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController =
        ge.Get.find<ProfileController>();
    // warningLog(
    //     'checking for customer info${profileController.customerDetails!.lat} ${profileController.customerDetails!.lng}');
    return BlocConsumer<HyperlocalShopBloc, HyperlocalShopState>(
      listener: (context, state) {
        errorLog('$state');
        if (state is HyperLocalGetProductsOfShopState) {
          List<HyperLocalProductWidget> hyperLocalProductWidgets = [];
          productModels = [];
          productModels = state.hyperLocalProductModels;
          for (var element in productModels) {

            hyperLocalProductWidgets.add(
              HyperLocalProductWidget(hyperLocalProductModel: element),
            );
            print("HyperLocalProductWidget############################# "
                "============= ${hyperLocalProductWidgets.toString()}");
          }
          setState(() {
            productWidgets = hyperLocalProductWidgets;
            existingModels = productModels;
            cartCount = RepositoryProvider.of<HyperLocalRepository>(context)
                .cartTotalCountLocal;
          });
        }
        if (state is HyperLocalGetSearchProductsOfShopState) {
          List<HyperLocalProductWidget> productWidgets = [];
          searchWidgets = [];
          searchModels = [];
          searchModels = state.hyperLocalProductModels;
          for (var element in searchModels) {
            productWidgets.add(
              HyperLocalProductWidget(hyperLocalProductModel: element),
            );
            setState(() {
              searchWidgets = productWidgets;
            });
          }
          // context.read<HyperlocalShopBloc>().add(
          //       HyperLocalGetResetEvent(),
          //     );
        }
        if (state is HyperLocalClearShopSearchProductState) {
          List<HyperLocalProductWidget> productWidgetsLocal = [];
          productModels = [];
          productModels = state.hyperLocalProductModels;
          warningLog('Product Models ${state.hyperLocalProductModels}');
          for (var element in productModels) {
            productWidgetsLocal.add(
              HyperLocalProductWidget(hyperLocalProductModel: element),
            );
          }
          setState(() {
            productWidgets = productWidgetsLocal;
            existingModels = productModels;
          });
        }
        if (state is HyperLocalGetSearchProductsOfShopErrorState) {
          errorLog('ERROR GETTING');
          setState(() {
            searchWidgets = [];
            productWidgets = [];
            productModels = [];
            searchModels = [];
          });
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            globalSearchtextEditingController
                .clear();
           return true;
          },
          child: Scaffold(
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
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 4.5),
                  child: IconButton(
                    onPressed: () {
                      // ge.Get.to(
                      //   () => const OndcIntroView(),
                      //   transition: ge.Transition.rightToLeft,
                      // );
                      ge.Get.off(
                          HyperlocalShophomeView(
                              lat: profileController.customerDetails!.lat,
                              lng: profileController.customerDetails!.lng),
                          transition: ge.Transition.rightToLeft);
                    },
                    splashRadius: 25.0,
                    icon: InkWell(
                      onTap: () {
                        ge.Get.off(
                            () => HyperlocalShophomeView(
                                  lat: profileController.customerDetails!.lat,
                                  lng: profileController.customerDetails!.lng,
                                ),
                            //!previous const MapMerchant(),
                            transition: ge.Transition.fadeIn);
                      },
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
            body: state is HyperLocalGetProductsOfShopLoadingState
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        Text(
                          'Getting products of shops',
                          style: TextStyle(
                            color: AppColors().brandDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : state is HyperLocalGetSearchProductsOfShopLoadingState
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            Text(
                              'Getting items',
                              style: TextStyle(
                                color: AppColors().brandDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/bannerondc.png',
                                  height: widget.hyperLocalShopModel.address
                                              .toString()
                                              .length >
                                          75
                                      ? 215
                                      : 195,
                                  fit: BoxFit.fill,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                Container(
                                  color: Colors.transparent,
                                  height: widget.hyperLocalShopModel.address
                                              .toString()
                                              .length >
                                          75
                                      ? 215
                                      : 195,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 5),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: GestureDetector(
                                                onTap: () {
                                                  warningLog(
                                                      'Checking for search term before exiting${globalSearchtextEditingController.text}');
                                                  globalSearchtextEditingController
                                                      .clear();

                                                  ge.Get.back();

                                                  // ge.Get.off(
                                                  //   () => HyperlocalShophomeView(
                                                  //       lat: profileController
                                                  //           .customerDetails!
                                                  //           .lat,
                                                  //       lng: profileController
                                                  //           .customerDetails!
                                                  //           .lng),
                                                  //   transition: ge
                                                  //       .Transition.leftToRight,
                                                  // );
                                                },
                                                child: Icon(
                                                  Icons.arrow_back,
                                                  color: AppColors().white100,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            AutoSizeText(
                                              '${widget.hyperLocalShopModel.name}',
                                              minFontSize: 16,
                                              style: TextStyle(
                                                color: AppColors().white100,
                                                fontSize: 22,
                                                // fontSize: widget.hyperLocalShopModel.name
                                                //             .toString()
                                                //             .length >
                                                //         60
                                                //     ? 20
                                                //     : 30,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
//! this is actually address the api returns address inside the email parameter so keep that in mind
                                            widget.hyperLocalShopModel
                                                        .address ==
                                                    null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        AutoSizeText(
                                                          "NA",
                                                          style: TextStyle(
                                                              color: AppColors()
                                                                  .white100,
                                                              fontSize: 10),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0),
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      child: Center(
                                                        child: Text(
                                                          '${widget.hyperLocalShopModel.address}',
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: AppColors()
                                                                .white100,
                                                            fontSize: 12,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            widget.hyperLocalShopModel
                                                        .phone_number ==
                                                    null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/phonepng.png',
                                                          height: 25,
                                                          width: 25,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        AutoSizeText(
                                                          "NA",
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: AppColors()
                                                                .white100,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/phonepng.png',
                                                          height: 25,
                                                          width: 25,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        AutoSizeText(
                                                          '${widget.hyperLocalShopModel.phone_number}',
                                                          style: TextStyle(
                                                            color: AppColors()
                                                                .white100,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/emailpng.png',
                                                      height: 25,
                                                      width: 25,
                                                    ),
                                                    const SizedBox(
                                                      width: 6,
                                                    ),
                                                    AutoSizeText(
                                                      '${widget.hyperLocalShopModel.email}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      minFontSize: 10,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                        color: AppColors()
                                                            .white100,
                                                        fontSize: 13,
                                                        // fontSize: widget.hyperLocalShopModel.name
                                                        //             .toString()
                                                        //             .length >
                                                        //         60
                                                        //     ? 20
                                                        //     : 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            //! reatest

                                            //! change this to delivery
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: AutoSizeText(
                                                homeDeliveryGlo == true
                                                    ? "Home Delivery Available"
                                                    : "No Home Delivery",
                                                minFontSize: 10,
                                                style: TextStyle(
                                                  color: AppColors().white100,
                                                  fontSize: 13,
                                                  // fontFamily: ,
                                                  // fontSize: widget.hyperLocalShopModel.name
                                                  //             .toString()
                                                  //             .length >
                                                  //         60
                                                  //     ? 20
                                                  //     : 30,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                BlocConsumer<HyperlocalCartBloc,
                                    HyperlocalCartState>(
                                  listener: (context, state) async {
                                    errorLog('State Check $state');
                                    if (state is ResetHyperLocalCartState) {
                                      await RepositoryProvider.of<
                                              HyperLocalRepository>(context)
                                          .getCartCount(
                                              storeDescriptionId: widget
                                                  .hyperLocalShopModel.id);
                                      setState(() {
                                        cartCount = RepositoryProvider.of<
                                                HyperLocalRepository>(context)
                                            .cartTotalCountLocal;
                                      });
                                    }
                                  },
                                  builder: (context, state) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        //toDo : add indicator while cart bloc implementation
                                        child: GestureDetector(
                                          onTap: () {
                                            errorLog(
                                                '${widget.hyperLocalShopModel.id}');
                                            ge.Get.to(
                                                () => HyperlocalCartView(
                                                      storeDescriptionId: widget
                                                          .hyperLocalShopModel
                                                          .id,
                                                    ),
                                                transition:
                                                    ge.Transition.rightToLeft);
                                          },
                                          child: badges.Badge(
                                            position:
                                                badges.BadgePosition.topEnd(
                                                    top: 0, end: 3),
                                            badgeAnimation: const badges
                                                .BadgeAnimation.slide(),
                                            badgeStyle: badges.BadgeStyle(
                                              badgeColor: AppColors().brandDark,
                                            ),
                                            showBadge: true,
                                            badgeContent: Text(
                                              '$cartCount',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                                  AppColors().brandDark,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  'assets/newshoppingcart.png',
                                                  fit: BoxFit.fill,
                                                  height: 55,
                                                  width: 55,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 8),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  controller: _textEditingController,
                                  inputFormatters: [
                                    NoLeadingSpaceFormatter(),
                                  ],
                                  onChanged: (value) {},
                                  onFieldSubmitted: (value) {
                                    setState(
                                      () {
                                        productNameLocal =
                                            _textEditingController.text;
                                      },
                                    );
                                    context.read<HyperlocalShopBloc>().add(
                                          HyperLocalGetSearchProductsOfShopEvent(
                                              shopId:
                                                  widget.hyperLocalShopModel.id,
                                              productName:
                                                  _textEditingController.text,
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
                                  },
                                  // onTap: () {
                                  //   ge.Get.to(getSearchView());
                                  // },
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    labelText: 'Search Products',
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    suffixIcon: state
                                            is HyperLocalGetSearchProductsOfShopState
                                        ? GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<HyperlocalShopBloc>()
                                                  .add(
                                                    HyperLocalGetSearchProductsClearEvent(
                                                        shopId: widget
                                                            .hyperLocalShopModel
                                                            .id,
                                                        lat: RepositoryProvider
                                                                .of<AddressRepository>(
                                                                    context)
                                                            .deliveryModel!
                                                            .lat,
                                                        lng: RepositoryProvider
                                                                .of<AddressRepository>(
                                                                    context)
                                                            .deliveryModel!
                                                            .lng),
                                                  );
                                              _textEditingController.clear();
                                            },
                                            child: const Icon(Icons.cancel),
                                          )
                                        : state is HyperLocalGetSearchProductsOfShopErrorState
                                            ? GestureDetector(
                                                onTap: () {
                                                  context
                                                      .read<
                                                          HyperlocalShopBloc>()
                                                      .add(
                                                        HyperLocalGetSearchProductsClearEvent(
                                                            shopId: widget
                                                                .hyperLocalShopModel
                                                                .id,
                                                            lat: RepositoryProvider
                                                                    .of<AddressRepository>(
                                                                        context)
                                                                .deliveryModel!
                                                                .lat,
                                                            lng: RepositoryProvider
                                                                    .of<AddressRepository>(
                                                                        context)
                                                                .deliveryModel!
                                                                .lng),
                                                      );
                                                  _textEditingController
                                                      .clear();
                                                },
                                                child: const Icon(Icons.cancel),
                                              )
                                            : const Text(''),
                                    prefixIcon: GestureDetector(
                                      onTap: () {
                                        setState(
                                          () {
                                            productNameLocal =
                                                _textEditingController.text;
                                          },
                                        );
                                        context.read<HyperlocalShopBloc>().add(
                                              HyperLocalGetSearchProductsOfShopEvent(
                                                  shopId: widget
                                                      .hyperLocalShopModel.id,
                                                  productName:
                                                      _textEditingController
                                                          .text,
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
                                      },
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 9.0),
                                        child: Icon(
                                          CupertinoIcons.search_circle_fill,
                                          size: 32,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            state is HyperLocalGetSearchProductsOfShopState
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 30.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${RepositoryProvider.of<HyperLocalRepository>(context).searchItemCount} items available',
                                      ),
                                    ),
                                  )
                                : productWidgets.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.only(right: 30.0),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '0 items available',
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 30.0),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '${RepositoryProvider.of<HyperLocalRepository>(context).itemCount} items available',
                                          ),
                                        ),
                                      ),
                            state is HyperLocalGetSearchProductsOfShopState
                                ? searchWidgets.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Text(
                                          'Unfortunately there are no product with the search term.Please try to search for something different',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors().brandDark,
                                            fontSize: 18,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.54,
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, top: 20),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: GridView.count(
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 4,
                                              controller:
                                                  _searchScrollController,
                                              mainAxisSpacing: 13,
                                              childAspectRatio: 1.0,
                                              children: [
                                                ...searchWidgets,
                                                _isSearchLoading
                                                    ? const Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : const SizedBox(height: 60)
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                : productWidgets.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Text(
                                          'Unfortunately there are no product with the search term.Please try to search for something different',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors().brandDark,
                                            fontSize: 18,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.54,
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, top: 20,),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: GridView.count(
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 4,
                                              mainAxisSpacing: 13,
                                              controller: _scrollController,
                                              childAspectRatio: 1.0,
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              children: [
                                                ...productWidgets,
                                                _isLoading
                                                    ? const Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : const SizedBox(height: 40)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                            _isLoading
                                ? const Column(
                                    children: [
                                      Center(
                                        // heightFactor: 0.8,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ],
                                  )
                                : const SizedBox(
                                    height: 20,
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
          ),
        );
      },
    );
  }
}
