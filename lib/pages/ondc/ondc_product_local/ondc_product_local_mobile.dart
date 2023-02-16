// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of ondc_product_local_view;

class _OndcProductLocalMobile extends StatefulWidget {
  final ShopModel shopModel;
  List<ProductOndcModel> productOndcModel;
  List<OndcProductWidget> productWidget;
  String productName;
  _OndcProductLocalMobile({
    Key? key,
    required this.shopModel,
    required this.productOndcModel,
    required this.productWidget,
    required this.productName,
  }) : super(key: key);

  @override
  State<_OndcProductLocalMobile> createState() =>
      _OndcProductLocalMobileState();
}

class _OndcProductLocalMobileState extends State<_OndcProductLocalMobile>
    with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late final TextEditingController _textEditingController;
  final ScrollController _searchScrollController = ScrollController();

  bool _loading = false;
  String productNameLocal = '';
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.productName);
    _searchScrollController.addListener(() {
      if (_searchScrollController.position.pixels ==
          _searchScrollController.position.maxScrollExtent) {
        warningLog('new search items');
        fetchNewSearchItems(
            shopId: widget.shopModel.id,
            transactionIdLocalIn: widget.shopModel.transaction_id,
            productName: _textEditingController.text,
            searchProductLocal: widget.productWidget);
      }
    });
  }

  fetchNewSearchItems(
      {required String shopId,
      required String transactionIdLocalIn,
      required String productName,
      required List<OndcProductWidget> searchProductLocal}) async {
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/store/item/nearby?transaction_id=$transactionIdLocalIn&store_id=$shopId&search=%$productName%&limit=100&offset=0');
    setState(() {
      _loading = true;
    });
    try {
      warningLog('product name $productName');
      final response = await http.get(url);
      warningLog('${response.statusCode}');
      final responseBody =
          await json.decode(response.body)['data']['rows'] as List<dynamic>;
      warningLog('$responseBody');
      List<ProductOndcModel> newSearchedProduct =
          responseBody.map((e) => ProductOndcModel.fromNewMap(e)).toList();
      warningLog('new search products${newSearchedProduct.length}');
      infoLog('${widget.productOndcModel.length}');
      List<ProductOndcModel> differenceModels = newSearchedProduct
          .toSet()
          .difference(widget.productOndcModel.toSet())
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
          widget.productWidget = searchProductLocal;
          widget.productOndcModel.addAll(differenceModels);
          _loading = true;
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
                                transactionId: widget.shopModel.transaction_id,
                                storeId: widget.shopModel.id,
                                productName: _textEditingController.text,
                              ),
                            );
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
      warningLog('$state');
      if (state is FetchedItemsInLocalShop) {
        List<OndcProductWidget> productsWidget = [];
        for (var productModel in state.productModels) {
          productsWidget.add(
            OndcProductWidget(productOndcModel: productModel),
          );
        }
        warningLog('productWidgets $productsWidget');
        setState(() {
          widget.productOndcModel = state.productModels;
          widget.productWidget = productsWidget;
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
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 24),
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
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 27.0,
                  ),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _searchScrollController,
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/ondcshopheader1.png',
                      height: 150,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Container(
                      color: const Color.fromRGBO(216, 205, 157, 50),
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              AutoSizeText(
                                widget.shopModel.name,
                                minFontSize: 18,
                                style: TextStyle(
                                  color: AppColors().black100,
                                  fontSize: 30,
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
                              const SizedBox(
                                height: 10,
                              ),
                              AutoSizeText(
                                widget.shopModel.address,
                                minFontSize: 10,
                                style: TextStyle(
                                  color: AppColors().black100,
                                  fontSize: 15,
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
                              AutoSizeText(
                                widget.shopModel.delivery
                                    ? "Home Delivery Available"
                                    : "",
                                minFontSize: 10,
                                style: TextStyle(
                                  color: AppColors().black100,
                                  fontSize: 15,
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
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        //toDo : add indicator while cart bloc implementation
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
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: _textEditingController,
                      onChanged: (value) {},
                      onTap: () {
                        ge.Get.to(getSearchView());
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Search Products',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _textEditingController.clear();
                            ge.Get.back();
                          },
                          child: const Icon(
                            Icons.cancel,
                            size: 32,
                            color: Colors.grey,
                          ),
                        ),
                        prefixIcon: const Padding(
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        '${RepositoryProvider.of<OndcRepository>(context).searchProductCountInLocalShop} items found'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Center(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.9,
                      children: [...widget.productWidget],
                    ),
                  ),
                ),
                _loading ? const CircularProgressIndicator() : const Text('')
              ],
            ),
          ));
    });
  }
}
