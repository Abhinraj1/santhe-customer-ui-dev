part of ondc_cart_view;

class _OndcCartMobile extends StatefulWidget {
  const _OndcCartMobile();

  @override
  State<_OndcCartMobile> createState() => _OndcCartMobileState();
}

class _OndcCartMobileState extends State<_OndcCartMobile> with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<ProductOndcModel> productModels = [];
  List<OndcCartItem> cartWidget = [];
  List<OndcCartItem> cartItemsWidgets = [];
  List<OndcCartItem> cartFilteredItems = [];
  bool doesContain = false;
  double total = 0;
  late final CartBloc cartBloc;
  @override
  void initState() {
    super.initState();
    cartBloc = context.read<CartBloc>();
    cartBloc.add(OnAppRefreshEvent());
    getCartList();
    // getApiCartList();
  }

  //toDo : method to check if the products are still available to be written

  getCartList() {
    total = 0;
    cartBloc.productModelBloc.forEach((value) {
      total = total + value.total;
      cartWidget.add(
        OndcCartItem(productOndcModel: value),
      );
    });
  }

  getApiCartList() {
    for (var element in cartBloc.productModelBlocLocal) {
      cartItemsWidgets.add(OndcCartItem(productOndcModel: element));
    }
    cartFilteredItems = cartWidget
        .where(
          (mainModel) => cartItemsWidgets.every((subModel) =>
              mainModel.productOndcModel.id == subModel.productOndcModel.id),
        )
        .toList();
    errorLog('cart Items Filtered $cartFilteredItems');
  }

  @override
  Widget build(BuildContext context) {
    debugLog('$cartWidget');
    return BlocConsumer<CartBloc, CartState>(
      bloc: cartBloc,
      listener: (context, state) {
        errorLog('checking for state $state');
        if (state is UpdatedQuantityState) {
          List<ProductOndcModel> models = [];
          models = cartBloc.productModelBloc;
          int indexL = models
              .indexWhere((element) => element.id == state.productOndcModel.id);
          models.removeWhere((model) => model.id == state.productOndcModel.id);
          models.insert(indexL, state.productOndcModel);
          context
              .read<CartBloc>()
              .add(UpdateCartEvent(productOndcModels: models));
        }
        if (state is DeleteCartItemState) {
          productModels = state.productOndcModel;
          // errorLog('checking the length ${productModels.length}');
          // List<OndcCartItem> newCartList = [];
          // productModels.forEach((key, value) {
          //   newCartList.add(
          //     OndcCartItem(productOndcModel: value),
          //   );
          // });
          // setState(() {
          //   cartWidget = newCartList;
          // });
          warningLog('DeleteCartItemState models $productModels');
          context.read<CartBloc>().add(
                UpdateCartEvent(productOndcModels: productModels),
              );
        }
        if (state is UpdatedCartItemState) {
          errorLog('$state');
          List<OndcCartItem> cartItems = [];
          total = 0;
          List<ProductOndcModel> productOndcModels = [];
          productOndcModels.addAll(state.productOndcModel);
          setState(() {
            productModels = productOndcModels;
          });
          productModels.forEach((model) {
            cartItems.add(
              OndcCartItem(productOndcModel: model),
            );
            total = total + model.total;
          });
          getApiCartList();
          setState(() {
            cartWidget = cartItems;
            cartBloc.productModelBloc = productModels;
            RepositoryProvider.of<OndcCartRepository>(context).productModels =
                productModels;
          });
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              key: _key,
              drawer: const nv.NavigationDrawer(),
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
                    fontSize: 24,
                  ),
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
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors().brandDark,
                            radius: 20,
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 100,
                          ),
                          const Text(
                            'My Cart',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: cartWidget,
                    ),
                  ],
                ),
              ),
              bottomSheet: cartWidget.isNotEmpty
                  ? SizedBox(
                      height: 125,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total:',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '₹ ${total.toString()} *',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 350,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(
                                  () => const OndcCheckoutScreenView(),
                                );
                              },
                              child: Text('Proceed To Checkout'),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors().brandDark),
                              ),
                            ),
                          ),
                          Text(
                            '* exclusive of additional fees and taxes',
                            style: TextStyle(
                                fontSize: 11, color: AppColors().black100),
                          )
                        ],
                      ),
                    )
                  : null,
            ),
            state is DeleteCartLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const Text('')
          ],
        );
      },
    );
  }
}
