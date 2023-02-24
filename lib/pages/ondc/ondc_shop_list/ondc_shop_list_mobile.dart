// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

part of ondc_shop_list_view;

class _OndcShopListMobile extends StatefulWidget {
  final CustomerModel customerModel;
  const _OndcShopListMobile({
    Key? key,
    required this.customerModel,
  }) : super(key: key);

  @override
  State<_OndcShopListMobile> createState() => _OndcShopListMobileState();
}

class _OndcShopListMobileState extends State<_OndcShopListMobile>
    with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<OndcShopWidget> shopWidgets = [];
  List<OndcShopWidget> searchWidgets = [];
  bool isSearching = false;
  bool isProductthere = false;
  bool _loading = false;
  bool _isLoading = false;
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final ScrollController _shopScroll = ScrollController();
  List<OndcProductWidget> productWidget = [];
  List<ProductOndcModel> existingModels = [];
  List<ShopModel> searchedModels = [];
  List<ShopModel> existingShopModels = [];
  int n = 10;
  String productName = "";
  late LocationModel locationModel;



  _getLocationCity() async {
    final url = Uri.parse(
        'http://www.postalpincode.in/api/pincode/${widget.customerModel.pinCode}');
    try {
      final response = await http.get(url);
      warningLog('${response.statusCode}');
      final responseBody =
          await json.decode(response.body)['PostOffice'] as List<dynamic>;
      warningLog('$responseBody');
      locationModel = LocationModel.fromMap(
        responseBody[0],
      );
      warningLog('$locationModel');
    } catch (e) {
      rethrow;
    }
  }

  getNewShops(
      {required String transactionIdl,
      required List<OndcShopWidget> shops,
      required int limit}) async {
    final firebaseID = AppHelpers().getPhoneNumberWithoutCountryCode;
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/store/nearby?transaction_id=$transactionIdl&limit=$limit&offset=0&firebase_id=$firebaseID');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(url, headers: header);
      warningLog(
          ' url $url checking for shop model via transcationid $response checking for existing shops length${shops.length}');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;

      List<ShopModel> shopModel =
          responseBody.map((e) => ShopModel.fromMap(e)).toList();
      // .sublist(existingShopModels.length);
      warningLog('limit check $limit $shopModel');
      List<ShopModel> differenceShopModels =
          shopModel.toSet().difference(existingShopModels.toSet()).toList();
      warningLog(
          'difference shops length${differenceShopModels.length} $differenceShopModels');
      List<OndcShopWidget> addableItems = [];
      for (var shopModelData in differenceShopModels) {
        addableItems.add(OndcShopWidget(shopModel: shopModelData));
      }
      warningLog('shopModels $addableItems');
      shops.addAll(
        addableItems.where(
          (shopwidget) => shops.every((shopwidgetmain) =>
              shopwidget.shopModel.id != shopwidgetmain.shopModel.id),
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          addableItems.clear();
          existingShopModels.addAll(differenceShopModels);
          shopWidgets = shops;
          _isLoading = false;
        });
      });
      warningLog('new exisiting models length ${existingShopModels.length}');
    } catch (e) {
      rethrow;
    }
  }

  getSearchView() {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors().brandDark,
                  size: 25,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                height: 70,
                child: TextFormField(
                  maxLength: 50,
                  controller: _textEditingController,
                  onChanged: (value) {
                    if (value.length >= 3) {
                      setState(() {
                        productName = _textEditingController.text;
                      });
                      // context.read<OndcBloc>().add(
                      //   FetchListOfShopWithSearchedProducts(
                      //     transactionId:
                      //     // '8a707e34-02a7-4ed5-89f1-66bdcc485f87',
                      //     RepositoryProvider.of<OndcRepository>(
                      //         context)
                      //         .transactionId,
                      //     productName: _textEditingController.text,
                      //   ),
                      // );
                    }
                    // _searchList(
                    //   searchText: value,
                    //   mainOndcShopWidgets: shopWidgets,
                    // );
                  },
                  decoration: InputDecoration(
                    labelText: 'Search Products here',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: GestureDetector(
                      onTap: () {
                        context.read<OndcBloc>().add(
                              FetchListOfShopWithSearchedProducts(
                                transactionId:
                                    // '8a707e34-02a7-4ed5-89f1-66bdcc485f87',
                                    RepositoryProvider.of<OndcRepository>(
                                            context)
                                        .transactionId,
                                productName: _textEditingController.text,
                              ),
                            );
                        setState(() {
                          productName = _textEditingController.text;
                        });
                        _textEditingController.clear();
                        ge.Get.back(
                          result: productName,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 9.0),
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
              height: 100,
            ),
            Center(
              child: Text(
                'Search for products',
                style: TextStyle(
                  color: AppColors().brandDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<OndcBloc>().add(
          FetchNearByShops(
            lat: widget.customerModel.lat,
            lng: widget.customerModel.lng,
            pincode: widget.customerModel.pinCode,
            isDelivery: widget.customerModel.opStats,
          ),
        );
    context.read<AddressBloc>().add(
          GetAddressListEvent(),
        );
    _shopScroll.addListener(() {
      if (_shopScroll.position.pixels == _shopScroll.position.maxScrollExtent) {
        warningLog('called');
        setState(() {
          n = n + 10;
        });
        getNewShops(
          transactionIdl:
              RepositoryProvider.of<OndcRepository>(context).transactionId,
          shops: shopWidgets,
          limit: n,
        );
      }
    });
    _getLocationCity();
  }

  // List<OndcShopWidget> _searchList(
  //     {required String? searchText,
  //     required List<OndcShopWidget> mainOndcShopWidgets}) {
  //   warningLog(' search term $searchText');
  //   List<OndcShopWidget> searchShopsWidgets =
  //       mainOndcShopWidgets.where((element) {
  //     final shopname = element.shopModel.name.toString().toLowerCase();
  //     final keyWord = searchText?.toLowerCase();
  //     return shopname.contains(keyWord!);
  //   }).toList();
  //   setState(() {
  //     searchWidgets = searchShopsWidgets;
  //     isSearching = true;
  //   });
  //   warningLog(' search widgets $searchWidgets');
  //   return searchWidgets;
  // }

  @override
  Widget build(BuildContext context) {
    debugLog(
        '${RepositoryProvider.of<AddressRepository>(context).addressModels}');
    return BlocConsumer<OndcBloc, OndcState>(
      // bloc: OndcBloc(ondcRepository: app<OndcRepository>()),
      listener: (context, state) {
        warningLog('$state');
        if (state is SearchItemLoaded) {
          List<ShopModel> newShopModel = [];
          List<OndcShopWidget> newShopWidget = [];
          setState(() {
            newShopModel = state.shopsList;
          });
          debugLog('searched shops models${newShopModel.length}');
          for (var model in newShopModel) {
            newShopWidget.add(
              OndcShopWidget(shopModel: model),
            );
          }
          setState(() {
            searchedModels = newShopModel;
            searchWidgets = newShopWidget;
          });
          errorLog('$searchWidgets');
        }
        if (state is OndcLoadingForShopsModelState) {
          //toDo: change this timing for actual physical device to 2 seconds
          Future.delayed(Duration(seconds: 5), () {
            context.read<OndcBloc>().add(
                  FetchShopModelsGet(transactionId: state.transactionId),
                );
          });
        }
        if (state is OndcShopModelsLoaded) {
          List<OndcShopWidget> ondcShopWidgets = [];
          for (var element in state.shopModels) {
            ondcShopWidgets.add(
              OndcShopWidget(shopModel: element),
            );
          }
          setState(() {
            shopWidgets = ondcShopWidgets;
            existingShopModels = state.shopModels;
          });
        }
        if (state is FetchedItemsInGlobal) {
          List<OndcProductWidget> productsWidget = [];
          for (var productModel in state.productModels) {
            productsWidget.add(
              OndcProductWidget(productOndcModel: productModel),
            );
          }
          warningLog('productWidgets $productsWidget');
          setState(() {
            productWidget = productsWidget;
            existingModels = state.productModels;
          });
          ge.Get.to(OndcProductGlobalView(
            customerModel: widget.customerModel,
            productWidget: productWidget,
            productOndcModel: state.productModels,
            productName: productName,
          ));
        }
      },

      builder: (context, state) {


        return Scaffold(
          key: _key,
          drawer: const CustomNavigationDrawer(),
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
                    // if (Platform.isIOS) {
                    //   Share.share(
                    //     AppHelpers().appStoreLink,
                    //   );
                    // } else {
                    //   Share.share(
                    //     AppHelpers().playStoreLink,
                    //   );
                    // }
                   /// ge.Get.back();
                    ge.Get.to(OndcCheckOutScreenMobile());
                  },
                  splashRadius: 25.0,

                  icon: InkWell(
                    onTap: (){

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
          body: state is OndcLoadingForShopsModelState
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text(
                        'Gettings Shops Nearby',
                        style: TextStyle(
                          color: AppColors().brandDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : state is OndcLoadingState
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text(
                            'Please wait',
                            style: TextStyle(
                              color: AppColors().brandDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : state is OndcFetchShopLoading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              Text(
                                'Getting ondc shops near you',
                                style: TextStyle(
                                  color: AppColors().brandDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : state is OndcFetchProductsGlobalLoading
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  Text(
                                    'Getting ondc products near you',
                                    style: TextStyle(
                                      color: AppColors().brandDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              controller: _shopScroll,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => MapTextView(),
                                          );
                                        },
                                        child: Container(

                                          color: Colors.white,
                                          height: 30,
                                          width: 340,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, left: 25),
                                            child: Text.rich(
                                              TextSpan(
                                                text: 'Delivery to: ',
                                                style: TextStyle(fontSize: 15),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '${RepositoryProvider.of<AddressRepository>(context).deliveryModel?.flat}',
                                                    // widget
                                                    //     .customerModel.address
                                                    //     .substring(0, 25),
                                                    style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationColor:
                                                          Color.fromARGB(
                                                              255, 77, 81, 84),
                                                    ),
                                                  ),
                                                  // can add more TextSpans here...
                                                ],
                                              ),
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
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 8),
                                    child: SizedBox(
                                      height: 50,
                                      child: TextFormField(
                                        controller: _textEditingController,

                                        // initialValue: _textEditingController
                                        //     .value.text,
                                        // onChanged: (value) {
                                        //   _searchList(
                                        //     searchText: value,
                                        //     mainOndcShopWidgets: shopWidgets,
                                        //   );
                                        // },
                                        // maxLines: 1,
                                        decoration: InputDecoration(
                                          labelText: 'Search Products here',
                                          isDense: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          suffixIcon: state is SearchItemLoaded
                                              ? GestureDetector(
                                                  onTap: () {
                                                    context
                                                        .read<OndcBloc>()
                                                        .add(
                                                          ClearSearchEventShops(
                                                              shopModels:
                                                                  existingShopModels),
                                                        );
                                                    _textEditingController
                                                        .clear();
                                                  },
                                                  child: Icon(Icons.cancel),
                                                )
                                              : null,
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 9.0),
                                            child: InkWell(
                                              onTap: () {
                                                context.read<OndcBloc>().add(
                                                      FetchListOfShopWithSearchedProducts(
                                                        transactionId:
                                                            // '8a707e34-02a7-4ed5-89f1-66bdcc485f87',
                                                            RepositoryProvider
                                                                    .of<OndcRepository>(
                                                                        context)
                                                                .transactionId,
                                                        productName:
                                                            _textEditingController
                                                                .text
                                                                .toString(),
                                                      ),
                                                    );
                                              },
                                              child: Icon(
                                                CupertinoIcons
                                                    .search_circle_fill,
                                                size: 32,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onFieldSubmitted: (value) {},
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Browse your Local Shops'),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: state is SearchItemLoaded
                                        ? Column(
                                            children: [...searchWidgets],
                                          )
                                        : Column(
                                            children: isSearching
                                                ? searchWidgets
                                                : shopWidgets,
                                          ),
                                  ),
                                  _isLoading
                                      ? CircularProgressIndicator()
                                      : Text('')
                                ],
                              ),
                            ),
        );
      },
    );
  }
}

