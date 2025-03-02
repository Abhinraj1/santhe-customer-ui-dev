// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, prefer_final_fields
part of ondc_cart_view;

class _OndcCartMobile extends StatefulWidget {
  final String storeLocation_id;
  const _OndcCartMobile({
    Key? key,
    required this.storeLocation_id,
  }) : super(key: key);

  @override
  State<_OndcCartMobile> createState() => _OndcCartMobileState();
}

class _OndcCartMobileState extends State<_OndcCartMobile> with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<ProductOndcModel> productModels = [];
  List<OndcCartItem> cartWidget = [];
  List<OndcCartItem> cartItemsWidgets = [];
  List<OndcCartItem> cartFilteredItems = [];
  List<CartitemModel> cartModels = [];
  OndcCartRepository ondcCartRepository = OndcCartRepository();
  bool doesContain = false;
  String? shopName;
  double total = 0;
  late final CartBloc cartBloc;
  bool _showErrorNoResponseFromSeller = false;
  bool _showNothingIsAvailableFromCart = false;
  bool _showErrorWhen1or2ItemsNotAvailable = false;
  @override
  void initState() {
    super.initState();
    cartBloc = context.read<CartBloc>();
    getShopName();
    cartBloc.add(
      OnAppRefreshEvent(storeLocationId: widget.storeLocation_id),
    );

    // getCartList();
    // getApiCartList();
  }

  //toDo : method to check if the products are still available to be written
  getShopName() async {
    List<CartitemModel> productModels1 = await ondcCartRepository.getCart(
        storeLocationId: widget.storeLocation_id);
    setState(() {
      shopName = productModels1.first.store_name;
    });
  }
  // getCartList() {
  //   total = 0;
  //   cartBloc.productModelBloc.forEach((value) {
  //     total = total + value.total;
  //     cartWidget.add(
  //       OndcCartItem(productOndcModel: value),
  //     );
  //   });
  // }

  // getApiCartList() {
  //   for (var element in cartBloc.productModelBlocLocal) {
  //     cartItemsWidgets.add(OndcCartItem(productOndcModel: element));
  //   }
  //   cartFilteredItems = cartWidget
  //       .where(
  //         (mainModel) => cartItemsWidgets.every((subModel) =>
  //             mainModel.productOndcModel.id == subModel.productOndcModel.id),
  //       )
  //       .toList();
  //   errorLog('cart Items Filtered $cartFilteredItems');
  // }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController =
        ge.Get.find<ProfileController>();
    debugLog(
        'store id${widget.storeLocation_id} and profile controller ${profileController.customerDetails}');
    return BlocConsumer<CartBloc, CartState>(
      bloc: cartBloc,
      listener: (context, state) {
        errorLog('checking for state $state');
        // if (state is UpdatedQuantityState) {
        //   List<CartitemModel> models = [];
        //   models = state.productOndcModel;
        //   int indexL = models
        //       .indexWhere((element) => element.id == state.productOndcModel.id);
        //   models.removeWhere((model) => model.id == state.productOndcModel.id);
        //   models.insert(indexL, state.productOndcModel);
        //   context
        //       .read<CartBloc>()
        //       .add(UpdateCartEvent(productOndcModels: models));
        // }
        if (state is UpdatedQuantityState) {
          List<OndcCartItem> cartWidgets = [];
          total = 0;
          int indexL = cartModels
              .indexWhere((element) => element.id == state.productOndcModel.id);
          errorLog('$indexL');
          cartModels.removeWhere(
              (element) => element.id == state.productOndcModel.id);
          errorLog('${cartModels.length}');
          cartModels.insert(indexL, state.productOndcModel);
          for (var element in cartModels) {
            errorLog('${cartModels.length}');
            cartWidgets.add(
              OndcCartItem(productOndcModel: element),
            );
            total = total + element.value * element.quantity;
          }
          setState(() {
            cartWidget = cartWidgets;
          });
          context
              .read<CartBloc>()
              .add(UpdateCartEvent(productOndcModels: cartModels));
        }
        if (state is GetCartItemsOfShopState) {
          List<OndcCartItem> cartWidgets = [];
          cartModels = state.products;

          total = 0;
          for (var element in cartModels) {
            cartWidgets.add(
              OndcCartItem(productOndcModel: element),
            );
            total = total + element.quantity * element.value;
          }
          errorLog('$total');
          setState(() {
            cartWidget = cartWidgets;
          });
          context.read<CartBloc>().add(
                ResetCartEvent(),
              );
        }
        if (state is DeleteCartItemState) {
          context.read<CartBloc>().add(
                OnAppRefreshEvent(storeLocationId: widget.storeLocation_id),
              );

          // productModels = state.productOndcModel;
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
          // warningLog('DeleteCartItemState models $productModels');
          // context.read<CartBloc>().add(
          //       UpdateCartEvent(productOndcModels: productModels),
          //     );
        }
        // if (state is UpdatedCartItemState) {
        //   errorLog('$state');
        //   List<OndcCartItem> cartItems = [];
        //   total = 0;
        //   List<ProductOndcModel> productOndcModels = [];
        //   productOndcModels.addAll(state.productOndcModel);
        //   setState(() {
        //     productModels = productOndcModels;
        //   });
        //   productModels.forEach((model) {
        //     cartItems.add(
        //       OndcCartItem(productOndcModel: model),
        //     );
        //     total = total + model.total;
        //   });
        //   // getApiCartList();
        //   setState(() {
        //     cartWidget = cartItems;
        //     cartBloc.productModelBloc = productModels;
        //     RepositoryProvider.of<OndcCartRepository>(context).productModels =
        //         productModels;
        //   });
        // }
      },
      builder: (context, state) {
        return BlocConsumer<CheckoutBloc, CheckoutState>(
          listener: (context, state) {
            if (state is CheckoutPostError) {}
          },
          builder: (context, state) {
            return Stack(
              children: [
                Scaffold(
                  key: _key,
                  drawer: const nv.CustomNavigationDrawer(),
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
                            // ge.Get.off(
                            //   () => const OndcIntroView(),
                            // );
                            ge.Get.off(HyperlocalShophomeView(
                                lat: profileController.customerDetails!.lat,
                                lng: profileController.customerDetails!.lng));
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
                  body: cartWidget.isEmpty
                      ? SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // CircleAvatar(
                                    //   backgroundColor: AppColors().brandDark,
                                    //   radius: 20,
                                    //   child: GestureDetector(
                                    //     onTap: () => ge.Get.back(),
                                    //     child: const Icon(
                                    //       Icons.arrow_back,
                                    //       color: Colors.white,
                                    //     ),
                                    //   ),
                                    // ),
                                    const CustomBackButton(),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'MY CART',
                                        style: TextStyle(
                                          color: AppColors().brandDark,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.abc,
                                      color: Colors.transparent,
                                      size: 17,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              shopName == null
                                  ? const Text('')
                                  : Text(
                                      'Shop: $shopName',
                                      style: TextStyle(
                                        color: AppColors().brandDark,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              const SizedBox(
                                height: 50,
                              ),
                              const Text(
                                'No Items in your cart. Please go back to \n the shop to add some items',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Center(
                                  child: Image.asset('assets/emptyCart.png')),
                              const SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                      AppColors().brandDark,
                                    ),
                                  ),
                                  onPressed: () => ge.Get.back(),
                                  child: const Text('BACK'),
                                ),
                              )
                            ],
                          ),
                        )
                      : ListView(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // CircleAvatar(
                                  //   backgroundColor: AppColors().brandDark,
                                  //   radius: 20,
                                  //   child: GestureDetector(
                                  //     onTap: () => ge.Get.back(),
                                  //     child: const Icon(
                                  //       Icons.arrow_back,
                                  //       color: Colors.white,
                                  //     ),
                                  //   ),
                                  // ),
                                  const CustomBackButton(),
                                  Text(
                                    'MY CART',
                                    style: TextStyle(
                                      color: AppColors().brandDark,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.abc,
                                    color: Colors.transparent,
                                    size: 17,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            shopName == null
                                ? const SizedBox()
                                : Center(
                                    child: Text(
                                      'Shop: $shopName',
                                      style: TextStyle(
                                        color: AppColors().brandDark,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                            _showErrorWhen1or2ItemsNotAvailable
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 48,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(
                                          12,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Error occurred, Please try again',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            _showErrorNoResponseFromSeller
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 48,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(
                                          12,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Seller is not responding.Please try later',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.075,
                                  top: 10),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${cartWidget.length} items',
                                  style:
                                      TextStyle(color: AppColors().brandDark),
                                ),
                              ),
                            ),
                            ...cartWidget,
                            const SizedBox(
                              height: 200,
                            )
                          ],
                        ),
                  bottomSheet: cartWidget.isNotEmpty
                      ? SizedBox(
                          height: 125,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total:',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '₹ ${total.toString()} *',
                                      style: TextStyle(
                                          color: AppColors().brandDark,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 350,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final String message = await ge.Get.to(
                                        () => OndcCheckoutScreenView(
                                              storeLocation_id:
                                                  widget.storeLocation_id,
                                              storeName: shopName,
                                            ),
                                        transition: ge.Transition.rightToLeft);
                                    debugLog('there is a message $message');
                                    if (message.contains('rror') ||
                                        message.contains('subtype')) {
                                      setState(() {
                                        _showErrorNoResponseFromSeller = true;
                                      });
                                    } else if (message.contains('seller')) {
                                      errorLog('true');
                                      setState(() {
                                        _showErrorNoResponseFromSeller = true;
                                      });
                                    } else if (message.contains('an Error')) {
                                      setState(() {
                                        _showErrorWhen1or2ItemsNotAvailable =
                                            true;
                                      });
                                    }
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColors().brandDark),
                                  ),
                                  child: const Text('PROCEED TO CHECKOUT'),
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
      },
    );
  }
}
