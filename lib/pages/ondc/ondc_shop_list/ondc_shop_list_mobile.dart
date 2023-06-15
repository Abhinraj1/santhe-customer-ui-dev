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

  final ScrollController _controller = ScrollController();
  final ScrollController _shopScroll = ScrollController();
  List<OndcProductWidget> productWidget = [];
  List<ProductOndcModel> existingModels = [];
  List<ShopModel> searchedModels = [];
  List<ShopModel> existingShopModels = [];
  List<ShopModel> existingShopNewModels = [];
  String searchTerm = '';

  String? noShopsMessage;
  int n = 0;
  int nSearch = 0;
  String productName = "";
  late LocationModel locationModel;
  bool _searchedLoaded = false;

  _getLocationCity() async {
    final url = Uri.parse(
        'http://www.postalpincode.in/api/pincode/${widget.customerModel.pinCode}');
    try {
      final response = await http.get(url);
      // warningLog('${response.statusCode}');
      final responseBody =
          await json.decode(response.body)['PostOffice'] as List<dynamic>;
      // warningLog('$responseBody');
      locationModel = LocationModel.fromMap(
        responseBody[0],
      );
      // warningLog('$locationModel');
    } catch (e) {
      rethrow;
    }
  }

  getSearchNewShop(
      {required List<OndcShopWidget> shops, required int limit}) async {
    final firebaseID = AppHelpers().getPhoneNumberWithoutCountryCode;
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/ondc/item/nearby?search=$productName&limit=10&offset=$nSearch&firebase_id=$firebaseID');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    setState(() {
      _isLoading = true;
    });
    try {
      Future.delayed(Duration(seconds: 2), () async {
        warningLog('Search Scroll used $url');
        final response = await http.get(url, headers: header);
        final responseBody =
            json.decode(response.body)['data']['rows'] as List<dynamic>;
        List<ShopModel> shopModel = responseBody
            .map((e) => ShopModel.fromMap(e))
            .toList()
            .where((element) => element.item_count != 0)
            .toList();
        List<OndcShopWidget> addableItems = [];
        for (var searchShopModel in shopModel) {
          addableItems.add(OndcShopWidget(shopModel: searchShopModel));
        }
        warningLog('shopModels $addableItems');
        shops.addAll(addableItems);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            addableItems.clear();
            existingShopNewModels.addAll(shopModel);
            shopWidgets = shops;
            _isLoading = false;
          });
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  getNewShops({required List<OndcShopWidget> shops, required int limit}) async {
    final firebaseID = AppHelpers().getPhoneNumberWithoutCountryCode;

    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/ondc/store/nearby?limit=10&offset=$n&firebase_id=$firebaseID');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    setState(() {
      _isLoading = true;
    });
    try {
      Future.delayed(Duration(seconds: 2), () async {
        final response = await http.get(url, headers: header);
        warningLog(
            ' url $url checking for shop model via transcationid $response checking for existing shops length${shops.length}');
        final responseBody =
            json.decode(response.body)['data']['rows'] as List<dynamic>;

        List<ShopModel> shopModel = responseBody
            .map((e) => ShopModel.fromMap(e))
            .toList()
            .where((element) => element.item_count != 0)
            .toList();
        // .sublist(existingShopModels.length);
        warningLog('limit check $limit ${shopModel.length}');
        List<ShopModel> differenceShopModels = shopModel;
        // .toSet().difference(existingShopModels.toSet())
        // warningLog(
        // 'difference shops length${differenceShopModels.length} $differenceShopModels');
        List<OndcShopWidget> addableItems = [];
        for (var shopModelData in differenceShopModels) {
          addableItems.add(OndcShopWidget(shopModel: shopModelData));
        }
        warningLog('shopModels $addableItems');
        shops.addAll(addableItems);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            addableItems.clear();
            existingShopModels.addAll(differenceShopModels);
            shopWidgets = shops;
            _isLoading = false;
          });
        });
        warningLog('new exisiting models length ${existingShopModels.length}');
      });
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
                  controller: globalSearchtextEditingController,
                  onChanged: (value) {
                    if (value.length >= 3) {
                      setState(() {
                        productName = globalSearchtextEditingController.text;
                      });
                      // context.read<OndcBloc>().add(
                      //   FetchListOfShopWithSearchedProducts(
                      //     transactionId:
                      //     // '8a707e34-02a7-4ed5-89f1-66bdcc485f87',
                      //     RepositoryProvider.of<OndcRepository>(
                      //         context)
                      //         .transactionId,
                      //     productName: globalSearchtextEditingController.text,
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
                                productName:
                                    globalSearchtextEditingController.text,
                              ),
                            );
                        setState(() {
                          productName = globalSearchtextEditingController.text;
                        });

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
    context.read<OndcBloc>().add(FetchShopModelsGet());
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
        if (state is ErrorFetchingShops) {
          Get.to(
            () => ApiErrorView(),
          );
        }

        if (state is SearchItemLoaded) {
          List<ShopModel> newShopModel = [];
          List<OndcShopWidget> newShopWidget = [];
          setState(() {
            newShopModel = state.shopsList;
          });
          debugLog('searched shops models${newShopModel.length}');
          if (newShopModel.isEmpty) {
            setState(() {
              noShopsMessage =
                  'There are no shops available \n servicing your search ';
            });
          }
          for (var model in newShopModel) {
            newShopWidget.add(
              OndcShopWidget(shopModel: model),
            );
          }
          setState(() {
            searchedModels = newShopModel;
            searchWidgets = newShopWidget;
            _searchedLoaded = true;
          });
          errorLog('$searchWidgets');
        }
        if (state is OndcLoadingForShopsModelState) {
          //toDo: change this timing for actual physical device to 2 seconds
          Future.delayed(Duration(seconds: 5), () {
            context.read<OndcBloc>().add(
                  FetchShopModelsGet(),
                );
          });
        }
        if (state is ClearSearchState) {
          List<OndcShopWidget> ondcShopWidgets = [];
          for (var element in state.ondcShopModels!) {
            ondcShopWidgets.add(OndcShopWidget(shopModel: element));
          }
          setState(() {
            shopWidgets = ondcShopWidgets;
            existingShopModels = state.ondcShopModels!;
          });
          warningLog('$shopWidgets');
          // setState(() {
          //   shopWidgets = shopWidgets;
          // });
        }
        if (state is OndcShopModelsLoaded) {
          List<OndcShopWidget> ondcShopWidgets = [];
          setState(() {
            existingShopModels = state.shopModels;
          });
          for (var element in existingShopModels) {
            ondcShopWidgets.add(
              OndcShopWidget(shopModel: element),
            );
          }
          setState(() {
            shopWidgets = ondcShopWidgets;
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

          ///WILL BE REMOVED @ABHI
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //
          //
          //     Get.to(() => ApiErrorView());
          //     // fun();
          //     ///  Get.to(()=>ErrorNackView(message: 'TEAT',));
          //
          //     // BlocProvider.of<ONDCOrderCancelAndReturnReasonsBloc>(context).add(
          //     //      LoadReasonsForReturnEvent(
          //     //         orderId: RepositoryProvider.of<OndcCheckoutRepository>(context)
          //     //             .orderId,
          //     //         product: PreviewWidgetModel(
          //     //             price: "200Rs",
          //     //         title: "Head and Shoulders Shampoo for dandruff. 250 ml",
          //     //         quantity: 1,
          //     //         quoteId: "",
          //     //         tat: "",
          //     //         message_id: "",
          //     //         category: "",
          //     //         fulfillment_id: "",
          //     //         provider_name: "",
          //     //         serviceable: "",
          //     //         status: "",
          //     //         type: "",
          //     //         ondc_item_id: "",
          //     //         deliveryFulfillmentId:"" ,
          //     //         cancellable: "",
          //     //         createdAt:"" ,
          //     //         deletedAt:"" ,
          //     //         id:"" ,symbol:"" ,updatedAt:"" ,returnable: "",
          //     //             isCancelled: null,
          //     //             isReturned: null),
          //     //
          //     //         orderNumber: "123456",));
          //   },
          // ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: (){
          //
          //   ///  Get.to(()=>ErrorNackView(message: 'TEAT',));
          //
          //     // BlocProvider.of<ONDCOrderCancelAndReturnReasonsBloc>(context).add(
          //     //      LoadReasonsForReturnEvent(
          //     //         orderId: RepositoryProvider.of<OndcCheckoutRepository>(context)
          //     //             .orderId,
          //     //         product: PreviewWidgetModel(
          //     //             price: "200Rs",
          //     //         title: "Head and Shoulders Shampoo for dandruff. 250 ml",
          //     //         quantity: 1,
          //     //         quoteId: "",
          //     //         tat: "",
          //     //         message_id: "",
          //     //         category: "",
          //     //         fulfillment_id: "",
          //     //         provider_name: "",
          //     //         serviceable: "",
          //     //         status: "",
          //     //         type: "",
          //     //         ondc_item_id: "",
          //     //         deliveryFulfillmentId:"" ,
          //     //         cancellable: "",
          //     //         createdAt:"" ,
          //     //         deletedAt:"" ,
          //     //         id:"" ,symbol:"" ,updatedAt:"" ,returnable: "",
          //     //             isCancelled: null,
          //     //             isReturned: null),
          //     //
          //     //         orderNumber: "123456",));
          //   },
          // ),

          ///  Get.to(()=>ErrorNackView(message: 'TEAT',));

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
                    onTap: () {
                      ge.Get.to(
                        () => OndcIntroView(),
                      );
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
                          : state is ClearStateLoading
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      Text(
                                        'Loading previous shops',
                                        style: TextStyle(
                                          color: AppColors().brandDark,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  controller: state is SearchItemLoaded
                                      ? _controller
                                      : _shopScroll,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => MapTextView(),
                                          );
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8.0,
                                                    left: 25,
                                                  ),
                                                  child: Text.rich(
                                                    TextSpan(
                                                      text: 'Delivery to: ',
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text:
                                                              '${RepositoryProvider.of<AddressRepository>(context).deliveryModel?.flat}',
                                                          // widget
                                                          //     .customerModel.address
                                                          //     .substring(0, 25),

                                                          style: TextStyle(
                                                            decorationColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    77,
                                                                    81,
                                                                    84),
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20, top: 5),
                                              child: Image.asset(
                                                  'assets/edit.png'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 20),
                                        child: SizedBox(
                                          height: 50,
                                          child: TextFormField(
                                            controller:
                                                globalSearchtextEditingController,
                                            onFieldSubmitted: (value) {
                                              context.read<OndcBloc>().add(
                                                    FetchListOfShopWithSearchedProducts(
                                                      productName:
                                                          globalSearchtextEditingController
                                                              .text
                                                              .toString(),
                                                    ),
                                                  );
                                              searchTerm =
                                                  globalSearchtextEditingController
                                                      .text;
                                            },
                                            // initialValue: globalSearchtextEditingController
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
                                              suffixIcon: state
                                                      is SearchItemLoaded
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        // setState(() {
                                                        //   _searchedLoaded = false;
                                                        // });
                                                        context
                                                            .read<OndcBloc>()
                                                            .add(
                                                              ClearSearchEventShops(
                                                                  shopModels:
                                                                      existingShopModels),
                                                            );
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
                                                      },
                                                      child: Icon(Icons.cancel),
                                                    )
                                                  : null,
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 9.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    context
                                                        .read<OndcBloc>()
                                                        .add(
                                                          FetchListOfShopWithSearchedProducts(
                                                            productName:
                                                                globalSearchtextEditingController
                                                                    .text
                                                                    .toString(),
                                                          ),
                                                        );
                                                    searchTerm =
                                                        globalSearchtextEditingController
                                                            .text;
                                                    globalSearchtextEditingController
                                                        .clear();
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
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      state is SearchItemLoaded
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
                                      state is SearchItemLoaded
                                          ? searchWidgets.isEmpty
                                              ? Text('')
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25.0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        'Below are the shops that sell "${searchTerm.capitalizeFirst}"'),
                                                  ),
                                                )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    'Browse your Local Shops'),
                                              ),
                                            ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      SingleChildScrollView(
                                        child: state is SearchItemLoaded
                                            ? searchWidgets.isEmpty
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            18.0),
                                                    child: Text(
                                                      'Unfortunately there are no shops that sell the product you are looking for.\nPlease try search for something different',
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
                                            : Column(
                                                children: shopWidgets,
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
