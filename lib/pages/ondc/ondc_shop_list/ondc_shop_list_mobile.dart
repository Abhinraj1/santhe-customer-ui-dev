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
  List<ShopModel> existingShopModels = [];
  _launchUrl() async {
    final url = Uri.parse('https://www.youtube.com/watch?v=BkvCsbmzkU8');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
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
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // Bottom poistion
        warningLog('Called');
        getNewProducts(
            transactionIdLocal:
                RepositoryProvider.of<OndcRepository>(context).transactionId,
            productName: _textEditingController.text,
            productWidgetsLocal: productWidget);
      }
    });
    _shopScroll.addListener(() {
      if (_shopScroll.position.pixels == _shopScroll.position.maxScrollExtent) {
        warningLog('called');
        getNewShops(
            transactionIdl:
                RepositoryProvider.of<OndcRepository>(context).transactionId,
            shops: shopWidgets);
      }
    });
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

  getSearchView() {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: _textEditingController,
                onChanged: (value) {
                  // _searchList(
                  //   searchText: value,
                  //   mainOndcShopWidgets: shopWidgets,
                  // );
                },
                decoration: InputDecoration(
                  labelText: 'Search Products here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  suffixIcon: ElevatedButton(
                    onPressed: () {
                      context.read<OndcBloc>().add(
                            SearchOndcItemGlobal(
                              transactionId:
                                  RepositoryProvider.of<OndcRepository>(context)
                                      .transactionId,
                              productName: _textEditingController.text,
                            ),
                          );
                      ge.Get.back();
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                      CircleBorder(),
                    )),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
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

  getNewProducts(
      {required String transactionIdLocal,
      required String productName,
      required List<OndcProductWidget> productWidgetsLocal}) async {
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/item/nearby?transaction_id=$transactionIdLocal&search=%$productName%&limit=20&offset=0');
    try {
      setState(() {
        _loading = true;
      });
      warningLog(
          'global search product $productName and length of product list ${productWidgetsLocal.length}');
      final response = await http.get(url);
      warningLog('${response.statusCode}');
      final responseBody =
          await json.decode(response.body)['data']['rows'] as List<dynamic>;
      warningLog('json data $responseBody');
      List<ProductOndcModel> searchedProducts =
          responseBody.map((e) => ProductOndcModel.fromMap(e)).toList();
      warningLog(
          'models length ${existingModels.length} and ${searchedProducts.length}');
      List<ProductOndcModel> differenceModels =
          searchedProducts.toSet().difference(existingModels.toSet()).toList();
      warningLog(
          'difference of models${differenceModels.length} $differenceModels');
      List<OndcProductWidget> addableItems = [];
      for (var model in differenceModels) {
        addableItems.add(OndcProductWidget(productOndcModel: model));
      }
      warningLog('addable items${addableItems.length}');
      productWidgetsLocal.addAll(addableItems);
      warningLog('new length${productWidgetsLocal.length}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          addableItems.clear();
          productWidget = productWidgetsLocal;
          existingModels.addAll(differenceModels);
          _loading = false;
        });
      });
    } catch (e) {
      warningLog(e.toString());
      rethrow;
    }
  }

  getNewShops(
      {required String transactionIdl,
      required List<OndcShopWidget> shops}) async {
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/store/nearby?transaction_id=$transactionIdl&limit=10&offset=0&firebase_id=2');
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(url, headers: header);
      warningLog(
          'checking for shop model via transcationid $response checking for existing shops length${shops.length}');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;
      warningLog('shops $responseBody');
      List<ShopModel> shopModel =
          responseBody.map((e) => ShopModel.fromMap(e)).toList();
      List<ShopModel> differenceShopModels =
          shopModel.toSet().difference(existingModels.toSet()).toList();
      warningLog(
          'difference shops length${differenceShopModels.length} $differenceShopModels');
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
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    warningLog(
        'customer lat: ${widget.customerModel.lat} customer long : ${widget.customerModel.lng} customer address ${widget.customerModel.pinCode} token customer');
    return BlocConsumer<OndcBloc, OndcState>(
      // bloc: OndcBloc(ondcRepository: app<OndcRepository>()),
      listener: (context, state) {
        warningLog('$state');
        if (state is OndcLoadingForShopsModelState) {
          Timer(
            Duration(seconds: 3),
            () => context.read<OndcBloc>().add(
                  FetchShopModelsGet(transactionId: state.transactionId),
                ),
          );
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
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: _key,
          backgroundColor: CupertinoColors.lightBackgroundGray,
          drawer: const NavigationDrawer(),
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
                    if (Platform.isIOS) {
                      Share.share(
                        AppHelpers().appStoreLink,
                      );
                    } else {
                      Share.share(
                        AppHelpers().playStoreLink,
                      );
                    }
                  },
                  splashRadius: 25.0,
                  icon: const Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 27.0,
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
                          : state is FetchedItemsInGlobal
                              ? SingleChildScrollView(
                                  controller: _controller,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: Container(
                                          color: CupertinoColors
                                              .lightBackgroundGray,
                                          height: 30,
                                          width: 350,
                                          child: Center(
                                            child: Text.rich(
                                              TextSpan(
                                                text: 'Delivery to: ',
                                                style: TextStyle(fontSize: 15),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: widget
                                                          .customerModel.address
                                                          .substring(0, 25),
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      )),
                                                  // can add more TextSpans here...
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 8),
                                        child: TextFormField(
                                          onTap: () {
                                            warningLog('tapped');
                                            ge.Get.to(getSearchView(),
                                                transition:
                                                    ge.Transition.rightToLeft);
                                          },
                                          // controller: _textEditingController,
                                          // onChanged: (value) {
                                          //   _searchList(
                                          //     searchText: value,
                                          //     mainOndcShopWidgets: shopWidgets,
                                          //   );
                                          // },
                                          // maxLines: 1,
                                          decoration: InputDecoration(
                                            labelText: 'Search Products here',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            suffixIcon: ElevatedButton(
                                              onPressed: () {
                                                // context.read<OndcBloc>().add(
                                                //       SearchOndcItemGlobal(
                                                //           transactionId:
                                                //               RepositoryProvider
                                                //                       .of<OndcRepository>(
                                                //                           context)
                                                //                   .transactionId,
                                                //           productName:
                                                //               _textEditingController
                                                //                   .text),
                                                //     );
                                              },
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all(
                                                  CircleBorder(),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.search,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Center(
                                          child: GridView.count(
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                            childAspectRatio: 0.9,
                                            children: productWidget,
                                          ),
                                        ),
                                      ),
                                      _loading
                                          ? CircularProgressIndicator()
                                          : Text('')
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
                                      Center(
                                        child: Container(
                                          color: CupertinoColors
                                              .lightBackgroundGray,
                                          height: 30,
                                          width: 350,
                                          child: Center(
                                            child: Text.rich(
                                              TextSpan(
                                                text: 'Delivery to: ',
                                                style: TextStyle(fontSize: 15),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: widget
                                                          .customerModel.address
                                                          .substring(0, 25),
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      )),
                                                  // can add more TextSpans here...
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 8),
                                        child: TextFormField(
                                          // controller: _textEditingController,
                                          // onChanged: (value) {
                                          //   _searchList(
                                          //     searchText: value,
                                          //     mainOndcShopWidgets: shopWidgets,
                                          //   );
                                          // },
                                          // maxLines: 1,
                                          onTap: () {
                                            warningLog('00');
                                            ge.Get.to(
                                              getSearchView(),
                                              transition:
                                                  ge.Transition.rightToLeft,
                                            );
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Search Products here',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              suffixIcon: ElevatedButton(
                                                onPressed: () {
                                                  warningLog('pressed');
                                                  // context.read<OndcBloc>().add(
                                                  //       SearchOndcItemGlobal(
                                                  //           transactionId: RepositoryProvider
                                                  //                   .of<OndcRepository>(
                                                  //                       context)
                                                  //               .transactionId,
                                                  //           productName:
                                                  //               _textEditingController
                                                  //                   .text),
                                                  //     );
                                                },
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all(
                                                  CircleBorder(),
                                                )),
                                                child: Icon(
                                                  Icons.search,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 25.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child:
                                              Text('Browse your Local Shops'),
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        child: Column(
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
