// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_final_fields
// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

part of hyperlocal_cart_view;

class _HyperlocalCartMobile extends StatefulWidget {
  final String storeDescriptionId;
  _HyperlocalCartMobile({
    required this.storeDescriptionId,
  });

  @override
  State<_HyperlocalCartMobile> createState() => _HyperlocalCartMobileState();
}

class _HyperlocalCartMobileState extends State<_HyperlocalCartMobile>
    with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool _showErrorNoResponseFromSeller = false;
  bool _showNothingIsAvailableFromCart = false;
  bool _showErrorWhen1or2ItemsNotAvailable = false;
  List<HyperLocalCartModel> cartModels = [];
  List<HyperLocalCartWidget> cartWidget = [];
  dynamic total = 0;
  String? shopName;
  dynamic homeDeliveryLoc;
  getShopName() async {
    List<HyperLocalCartModel> productModels1 =
        await RepositoryProvider.of<HyperLocalCartRepository>(context)
            .getCart(storeDescriptionId: widget.storeDescriptionId);
    setState(() {
      shopName = productModels1.first.store_name;
    });
  }

  @override
  void initState() {
    super.initState();
    getShopName();
    context.read<HyperlocalCartBloc>().add(
          OnAppRefreshHyperLocalCartEvent(
              storeDescriptionId: widget.storeDescriptionId),
        );
  }

  @override
  Widget build(BuildContext context) {
    final profileController = ge.Get.find<ProfileController>();
    return BlocConsumer<HyperlocalCartBloc, HyperlocalCartState>(
      listener: (context, state) {
        if (state is GotHyperLocalCartState) {
          List<HyperLocalCartWidget> localCart = [];
          cartModels = [];
          cartWidget = [];
          cartModels = state.cartModels;
          total = 0;
          for (var element in cartModels) {
            localCart.add(
              HyperLocalCartWidget(hyperLocalCartModel: element),
            );
            warningLog(
                'Checking values ${element.offer_price} and also ${element.quantity}');
            total = total + element.offer_price * element.quantity;
          }
          setState(() {
            cartWidget = localCart;
          });
          warningLog('Cart Widgets $cartWidget');
          context.read<HyperlocalCartBloc>().add(ResetHyperCartEvent());
        }
        if (state is DeleteHyperLocalCartItemState) {
          context.read<HyperlocalCartBloc>().add(
                OnAppRefreshHyperLocalCartEvent(
                    storeDescriptionId: widget.storeDescriptionId),
              );
        }
        if (state is UpdateQuantityHyperLocalCartItemState) {
          List<HyperLocalCartWidget> localCartWidgets = [];
          total = 0;
          int indexL = cartModels.indexWhere(
              (element) => element.productId == state.cartModel.productId);
          errorLog('$indexL');
          cartModels.removeWhere(
              (element) => element.productId == state.cartModel.productId);
          errorLog('Removed Length${cartModels.length}');
          cartModels.insert(indexL, state.cartModel);
          for (var element in cartModels) {
            localCartWidgets.add(
              HyperLocalCartWidget(hyperLocalCartModel: element),
            );
            total = total + element.offer_price * element.quantity;
          }
          setState(() {
            cartWidget = localCartWidgets;
          });
          context
              .read<HyperlocalCartBloc>()
              .add(UpdateHyperLocalCartEvent(cartModels: cartModels));
        }
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
                        ge.Get.off(
                            () => HyperlocalShophomeView(
                                  lat: profileController.customerDetails!.lat,
                                  lng: profileController.customerDetails!.lng,
                                ),
                            //!previous const MapMerchant(),
                            transition: ge.Transition.fadeIn);
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Center(child: Image.asset('assets/emptyCart.png')),
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
                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
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
                              right: MediaQuery.of(context).size.width * 0.075,
                              top: 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${cartWidget.length} items',
                              style: TextStyle(color: AppColors().brandDark),
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
                                final String? message = await ge.Get.to(
                                  () => HyperlocalCheckoutView(
                                    storeDescription_id:
                                        widget.storeDescriptionId,
                                    storeName: shopName!,
                                  ),
                                );
                                warningLog('error message $message');
                                if (message.toString().contains('500')) {
                                  setState(() {
                                    _showErrorNoResponseFromSeller = true;
                                  });
                                }
                                // final String message = await ge.Get.to(
                                //     () => OndcCheckoutScreenView(
                                //           storeLocation_id:
                                //               widget.storeLocation_id,
                                //           storeName: shopName,
                                //         ),
                                //     transition: ge.Transition.rightToLeft);
                                // debugLog('there is a message $message');
                                // if (message.contains('rror') ||
                                //     message.contains('subtype')) {
                                //   setState(() {
                                //     _showErrorNoResponseFromSeller = true;
                                //   });
                                // } else if (message.contains('seller')) {
                                //   errorLog('true');
                                //   setState(() {
                                //     _showErrorNoResponseFromSeller = true;
                                //   });
                                // } else if (message.contains('an Error')) {
                                //   setState(() {
                                //     _showErrorWhen1or2ItemsNotAvailable =
                                //         true;
                                //   });
                                // }
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
            state is DeleteHyperLocalCartItemLoadingState
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : state is GetHyperLocalCartStateLoadingState
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Text('')
          ],
        );
      },
    );
  }
}
