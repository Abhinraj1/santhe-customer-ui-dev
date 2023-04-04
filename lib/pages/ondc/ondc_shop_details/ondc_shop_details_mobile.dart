// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

part of ondc_shop_details_view;

//

class _OndcShopDetailsMobile extends StatefulWidget {
  final ShopModel shopModel;

  const _OndcShopDetailsMobile({Key? key, required this.shopModel})
      : super(key: key);

  @override
  State<_OndcShopDetailsMobile> createState() => _OndcShopDetailsMobileState();
}

class _OndcShopDetailsMobileState extends State<_OndcShopDetailsMobile>
    with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final TextEditingController _textEditingController = TextEditingController();
  List<OndcProductWidget> productWidget = [];
  List<OndcProductWidget> searchWidgets = [];
  List<ProductOndcModel> existingProductModels = [];
  List<ProductOndcModel> searchExistingModels = [];
  final ScrollController _scrollController = ScrollController();
  final ScrollController _searchScrollController = ScrollController();
  bool _loading = false;
  bool _searchLoading = false;
  int n = 100;
  int nsearch = 100;
  int cartCount = 0;
  String productNameLocal = '';
  bool _errorSearchingforProduct = false;

  @override
  void initState() {
    super.initState();
    context.read<OndcBloc>().add(
          FetchProductsOfShops(
            shopId: widget.shopModel.id,
          ),
        );
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          n = n + 10;
        });
        warningLog('new search items and limit $n');
        fetchData(
            productWidgetsLocal: productWidget,
            shopId: widget.shopModel.id,
            transactionIdLocal: widget.shopModel.transaction_id);
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
          shopId: widget.shopModel.id,
          productName: _textEditingController.text,
          searchProductLocal: searchWidgets,
        );
      }
    });
  }

  fetchNewSearchItems(
      {required String shopId,
      required String productName,
      required List<OndcProductWidget> searchProductLocal}) async {
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/store/item/nearby?storeLocation_id=$shopId&search=%$productName%&limit=12&offset=0');
    setState(() {
      _searchLoading = true;
    });
    try {
      warningLog('product name $productName');
      final response = await http.get(url);
      warningLog('${response.statusCode} and url $url');
      final responseBody =
          await json.decode(response.body)['data']['rows'] as List<dynamic>;
      warningLog('$responseBody');
      List<ProductOndcModel> newSearchedProduct =
          responseBody.map((e) => ProductOndcModel.fromNewMap(e)).toList();
      warningLog('new search products${newSearchedProduct.length}');
      List<ProductOndcModel> differenceModels = newSearchedProduct
          .toSet()
          .difference(searchExistingModels.toSet())
          .toList();
      warningLog(
          'difference of models${differenceModels.length} $differenceModels');
      List<OndcProductWidget> addableItems = [];
      for (var model in differenceModels) {
        addableItems.add(
          OndcProductWidget(productOndcModel: model),
        );
      }
      warningLog('addable items${addableItems.length}');
      searchProductLocal.addAll(addableItems);
      infoLog('searched ${searchProductLocal.length}');
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          addableItems.clear();
          searchWidgets = searchProductLocal;
          searchExistingModels.addAll(differenceModels);
          _searchLoading = false;
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  fetchData(
      {required String transactionIdLocal,
      required String shopId,
      required List<OndcProductWidget> productWidgetsLocal}) async {
    final Uri url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/store/item/nearby?storeLocation_id=$shopId&search=%%&limit=$n&offset=0');
    setState(() {
      _loading = true;
    });
    try {
      final response = await http.get(url);
      warningLog('${response.statusCode}');
      final responseBody =
          await json.decode(response.body)['data']['rows'] as List<dynamic>;
      warningLog('$responseBody');
      List<ProductOndcModel> newProductList =
          responseBody.map((e) => ProductOndcModel.fromNewMap(e)).toList();
      warningLog('new models $newProductList');
      infoLog('${existingProductModels.length}');
      List<ProductOndcModel> differenceModels = newProductList
          .toSet()
          .difference(existingProductModels.toSet())
          .toList();
      warningLog(
          'difference of models${differenceModels.length} $differenceModels');
      List<OndcProductWidget> addableItems = [];
      for (var model in differenceModels) {
        addableItems.add(
          OndcProductWidget(productOndcModel: model),
        );
      }
      warningLog('addable items${addableItems.length}');
      productWidgetsLocal.addAll(addableItems);
      warningLog('new length${productWidgetsLocal.length}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          addableItems.clear();
          productWidget = productWidgetsLocal;
          existingProductModels.addAll(differenceModels);
          _loading = false;
        });
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
                child: GestureDetector(
                  onTap: () => ge.Get.back(),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors().brandDark,
                    size: 25,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Search Products here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            productNameLocal = _textEditingController.text;
                          },
                        );
                        context.read<OndcBloc>().add(
                              SearchOndcItemInLocalShop(
                                storeId: widget.shopModel.id,
                                productName: _textEditingController.text,
                              ),
                            );
                        _textEditingController.clear();
                        ge.Get.back();
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
  Widget build(BuildContext context) {
    return BlocConsumer<OndcBloc, OndcState>(listener: (context, state) {
      if (state is ErrorFetchingProductsOfShops) {
        ge.Get.to(
          () => const ApiErrorView(),
        );
      }
      if (state is OndcProductsOfShopsLoaded) {
        List<OndcProductWidget> productsWidget = [];
        for (var productModel in state.productModels) {
          productsWidget.add(
            OndcProductWidget(productOndcModel: productModel),
          );
        }
        // warningLog('productWidgets $productsWidget');
        setState(() {
          existingProductModels = state.productModels;
          productWidget = productsWidget;
          cartCount =
              RepositoryProvider.of<OndcRepository>(context).totalCartItemCount;
        });
      }
      if (state is FetchedItemsInLocalShop) {
        //searched State
        List<OndcProductWidget> productsWidget = [];
        for (var productModel in state.productModels) {
          productsWidget.add(
            OndcProductWidget(productOndcModel: productModel),
          );
        }
        warningLog('productWidgets $productsWidget');
        setState(() {
          searchExistingModels = state.productModels;
          searchWidgets = productsWidget;
        });
      }
      if (state is ResetOndcState) {
        setState(() {
          cartCount = state.cartCount;
        });
      }
      if (state is ErrorFetchingProductsOfShops) {
        warningLog('Error fetching products of shop');
        setState(() {
          _errorSearchingforProduct = true;
        });
      }
    }, builder: (context, state) {
      return Scaffold(
        drawer: const CustomNavigationDrawer(),
        key: _key,
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
                fontWeight: FontWeight.w800, color: Colors.white, fontSize: 24),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 4.5),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  // if (Platform.isIOS) {
                  //   Share.share(
                  //     AppHelpers().appStoreLink,
                  //   );
                  // } else {
                  //   Share.share(
                  //     AppHelpers().playStoreLink,
                  //   );
                  // }
                },
                splashRadius: 25.0,
                icon: GestureDetector(
                  onTap: () => ge.Get.to(
                    () => const OndcIntroView(),
                  ),
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
        resizeToAvoidBottomInset: false,
        body: state is OndcFetchProductLoading
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/bannerondc.png',
                          height: 185,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Container(
                          color: Colors.transparent,
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 5),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: GestureDetector(
                                        onTap: () => ge.Get.back(),
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: AppColors().white100,
                                        ),
                                      ),
                                    ),
                                    AutoSizeText(
                                      widget.shopModel.name,
                                      minFontSize: 16,
                                      style: TextStyle(
                                        color: AppColors().white100,
                                        fontSize: 22,
                                        // fontSize: widget.shopModel.name
                                        //             .toString()
                                        //             .length >
                                        //         60
                                        //     ? 20
                                        //     : 30,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: AutoSizeText(
                                          widget.shopModel.address,
                                          textAlign: TextAlign.center,
                                          minFontSize: 10,
                                          style: TextStyle(
                                            color: AppColors().white100,
                                            fontSize: 13,
                                            // fontSize: widget.shopModel.name
                                            //             .toString()
                                            //             .length >
                                            //         60
                                            //     ? 20
                                            //     : 30,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.values.first,
                                          ),
                                        ),
                                      ),
                                    ),
                                    //! reatest
                                    widget.shopModel.phone == null
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                    color: AppColors().white100,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                  '${widget.shopModel.phone}',
                                                  style: TextStyle(
                                                    color: AppColors().white100,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                    widget.shopModel.email == null
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/emailpng.png',
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                AutoSizeText(
                                                  "NA",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors().white100,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/emailpng.png',
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                AutoSizeText(
                                                  '${widget.shopModel.email}',
                                                  style: TextStyle(
                                                      color:
                                                          AppColors().white100,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                    AutoSizeText(
                                      widget.shopModel.delivery != null &&
                                              widget.shopModel.delivery == true
                                          ? "Home Delivery Available"
                                          : "",
                                      minFontSize: 10,
                                      style: TextStyle(
                                        color: AppColors().white100,
                                        fontSize: 13,
                                        // fontFamily: ,
                                        // fontSize: widget.shopModel.name
                                        //             .toString()
                                        //             .length >
                                        //         60
                                        //     ? 20
                                        //     : 30,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            //toDo : add indicator while cart bloc implementation
                            child: GestureDetector(
                              onTap: () {
                                ge.Get.to(
                                  () => OndcCartView(
                                    storeLocation_id: widget.shopModel.storeId,
                                  ),
                                );
                                setState(() {});
                              },
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: AppColors().brandDark,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/newshoppingcart.png',
                                        fit: BoxFit.fill,
                                        height: 55,
                                        width: 55,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Column(
                      children: const [
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                        Text('Getting Products of shop')
                      ],
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
                          height: 180,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Container(
                          color: Colors.transparent,
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 5),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 5),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child:
                                          CustomBackButton(invertColors: true),
                                    ),
                                    AutoSizeText(
                                      widget.shopModel.name,
                                      minFontSize: 16,
                                      style: TextStyle(
                                        color: AppColors().white100,
                                        fontSize: 22,
                                        // fontSize: widget.shopModel.name
                                        //             .toString()
                                        //             .length >
                                        //         60
                                        //     ? 20
                                        //     : 30,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: AutoSizeText(
                                          widget.shopModel.address.toString(),
                                          textAlign: TextAlign.center,
                                          minFontSize: 10,
                                          style: TextStyle(
                                            color: AppColors().white100,
                                            fontSize: 13,
                                            // fontSize: widget.shopModel.name
                                            //             .toString()
                                            //             .length >
                                            //         60
                                            //     ? 20
                                            //     : 30,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.values.first,
                                          ),
                                        ),
                                      ),
                                    ),
                                    //! reatest
                                    widget.shopModel.phone == null
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                    color: AppColors().white100,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                  '${widget.shopModel.phone}',
                                                  style: TextStyle(
                                                    color: AppColors().white100,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    widget.shopModel.email == null
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/emailpng.png',
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                AutoSizeText(
                                                  "NA",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors().white100,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/emailpng.png',
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                AutoSizeText(
                                                  '${widget.shopModel.email}',
                                                  style: TextStyle(
                                                      color:
                                                          AppColors().white100,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                    AutoSizeText(
                                      widget.shopModel.delivery != null &&
                                              widget.shopModel.delivery == true
                                          ? "Home Delivery Available"
                                          : "",
                                      minFontSize: 10,
                                      style: TextStyle(
                                        color: AppColors().white100,
                                        fontSize: 13,
                                        // fontFamily: ,
                                        // fontSize: widget.shopModel.name
                                        //             .toString()
                                        //             .length >
                                        //         60
                                        //     ? 20
                                        //     : 30,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        BlocConsumer<CartBloc, CartState>(
                            listener: (context, state) async {
                          errorLog('state check $state');
                          if (state is ResetCartState) {
                            await RepositoryProvider.of<OndcRepository>(context)
                                .getCartCountMethod(
                              storeLocation_id: widget.shopModel.id,
                            );
                            setState(() {
                              cartCount =
                                  RepositoryProvider.of<OndcRepository>(context)
                                      .cartCount;
                            });
                          }
                        }, builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              //toDo : add indicator while cart bloc implementation
                              child: GestureDetector(
                                onTap: () {
                                  errorLog('${widget.shopModel.id}');
                                  ge.Get.to(
                                    () => OndcCartView(
                                      storeLocation_id: widget.shopModel.id,
                                    ),
                                  );
                                },
                                child: badges.Badge(
                                  position: badges.BadgePosition.topEnd(
                                      top: 0, end: 3),
                                  badgeAnimation:
                                      const badges.BadgeAnimation.slide(),
                                  badgeStyle: badges.BadgeStyle(
                                    badgeColor: AppColors().brandDark,
                                  ),
                                  showBadge: true,
                                  badgeContent: Text(
                                    '$cartCount',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: AppColors().brandDark,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                        })
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8),
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: _textEditingController,
                          onChanged: (value) {},
                          onFieldSubmitted: (value) {
                            setState(
                              () {
                                productNameLocal = _textEditingController.text;
                              },
                            );
                            context.read<OndcBloc>().add(
                                  SearchOndcItemInLocalShop(
                                    storeId: widget.shopModel.id,
                                    productName: _textEditingController.text,
                                  ),
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
                            suffixIcon: state is FetchedItemsInLocalShop
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _textEditingController.clear();
                                      });
                                      context.read<OndcBloc>().add(
                                            FetchProductsOfShops(
                                              shopId: widget.shopModel.id,
                                            ),
                                          );
                                    },
                                    icon: const Icon(Icons.cancel),
                                  )
                                : _errorSearchingforProduct
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _errorSearchingforProduct = false;
                                            _textEditingController.clear();
                                          });
                                          FetchProductsOfShops(
                                            shopId: widget.shopModel.id,
                                          );
                                        },
                                        icon: const Icon(Icons.cancel),
                                      )
                                    : null,
                            prefixIcon: GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    productNameLocal =
                                        _textEditingController.text;
                                  },
                                );
                                context.read<OndcBloc>().add(
                                      SearchOndcItemInLocalShop(
                                        storeId: widget.shopModel.id,
                                        productName:
                                            _textEditingController.text,
                                      ),
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
                      height: 5,
                    ),
                    state is FetchedItemsInLocalShop
                        ? Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${state.productModels.length} items available',
                              ),
                            ),
                          )
                        : state is! NoItemsFoundState
                            ? Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '${widget.shopModel.item_count} items available',
                                  ),
                                ),
                              )
                            : const SizedBox(),
                    state is FetchedItemsInLocalShop
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.54,
                            color: Colors.transparent,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 20),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: GridView.count(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  controller: _searchScrollController,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 0.9,
                                  children: [
                                    ...searchWidgets,
                                  ],
                                ),
                              ),
                            ),
                          )
                        : state is NoItemsFoundState
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.54,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, top: 20, right: 20),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: SizedBox(
                                      child: Text(
                                        'No items found for your search.'
                                        'Please try with a different item name',
                                        style:
                                            FontStyleManager().s14fw700Orange,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.54,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, top: 20),
                                  child: Center(
                                    child: GridView.count(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      controller: _scrollController,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 15,
                                      childAspectRatio: 0.95,
                                      children: [
                                        ...productWidget,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                    _loading
                        ? Column(
                            children: const [
                              Center(
                                heightFactor: 0.8,
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          )
                        : _searchLoading
                            ? Column(
                                children: const [
                                  Center(
                                    heightFactor: 0.8,
                                    child: CircularProgressIndicator(),
                                  ),
                                ],
                              )
                            : const SizedBox(
                                height: 60,
                              )
                  ],
                ),
              ),
      );
    });
  }
}
