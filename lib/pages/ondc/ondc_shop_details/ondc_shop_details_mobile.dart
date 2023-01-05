// ignore_for_file: public_member_api_docs, sort_constructors_first
part of ondc_shop_details_view;

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
  List<ProductOndcModel> existingProductModels = [];
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  String productNameLocal = '';

  @override
  void initState() {
    super.initState();
    context.read<OndcBloc>().add(
          FetchProductsOfShops(
              shopId: widget.shopModel.id,
              transactionId:
                  RepositoryProvider.of<OndcRepository>(context).transactionId),
        );
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        warningLog('message');
        fetchData(
            productWidgetsLocal: productWidget,
            shopId: widget.shopModel.id,
            transactionIdLocal: widget.shopModel.transaction_id);
      }
    });
  }

  fetchData(
      {required String transactionIdLocal,
      required String shopId,
      required List<OndcProductWidget> productWidgetsLocal}) async {
    final Uri url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/store/item/nearby?transaction_id=$transactionIdLocal&store_id=$shopId&search=%%&limit=100&offset=0');
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
          responseBody.map((e) => ProductOndcModel.fromMap(e)).toList();
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
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  labelText: 'Search Products here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  suffixIcon: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        productNameLocal = _textEditingController.text;
                      });
                      context.read<OndcBloc>().add(
                            SearchOndcItemInLocalShop(
                              transactionId: widget.shopModel.transaction_id,
                              storeId: widget.shopModel.id,
                              productName: _textEditingController.text,
                            ),
                          );
                      ge.Get.back();
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                      const CircleBorder(),
                    )),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
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
      warningLog('checking for state $state');
      if (state is OndcProductsOfShopsLoaded) {
        List<OndcProductWidget> productsWidget = [];
        for (var productModel in state.productModels) {
          productsWidget.add(
            OndcProductWidget(productOndcModel: productModel),
          );
        }
        warningLog('productWidgets $productsWidget');
        setState(() {
          existingProductModels = state.productModels;
          productWidget = productsWidget;
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
          productWidget = productsWidget;
        });
      }
    }, builder: (context, state) {
      return Scaffold(
        drawer: const NavigationDrawer(),
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
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 27.0,
                ),
              ),
            )
          ],
        ),
        body: state is OndcFetchProductLoading
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset('assets/shopbackground.png'),
                        Container(
                          color: AppColors().brandDark.withOpacity(0.5),
                          height: 125,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Center(
                              child: Text(
                                widget.shopModel.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
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
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset('assets/shopbackground.png'),
                        Container(
                          color: AppColors().brandDark.withOpacity(0.5),
                          height: 125,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Center(
                              child: Text(
                                widget.shopModel.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8),
                      child: TextFormField(
                        controller: _textEditingController,
                        onChanged: (value) {},
                        onTap: () {
                          ge.Get.to(getSearchView());
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                            labelText: 'Search Products here',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            suffixIcon: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                const CircleBorder(),
                              )),
                              child: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            )),
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
                          mainAxisSpacing: 5,
                          childAspectRatio: 0.9,
                          children: productWidget,
                        ),
                      ),
                    ),
                    _loading
                        ? const CircularProgressIndicator()
                        : const Text('')
                  ],
                ),
              ),
      );
    });
  }
}
