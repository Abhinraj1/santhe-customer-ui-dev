// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

part of ondc_checkout_screen_view;

class _OndcCheckoutScreenMobile extends StatefulWidget {
  final String storeLocation_id;
  _OndcCheckoutScreenMobile({required this.storeLocation_id});

  @override
  State<_OndcCheckoutScreenMobile> createState() =>
      _OndcCheckoutScreenMobileOldState();
}

class _OndcCheckoutScreenMobileOldState extends State<_OndcCheckoutScreenMobile>
    with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  FinalCostingModel? finalCostingModel;
  late final String messageID;
  double subtotal = 0;
  double deliveryCharges = 0;
  double taxescgst = 0;
  double taxessgst = 0;
  String? orderId;
  List<PreviewWidgetOndcItem> previewWidgetItems = [];

  Razorpay _razorpay = Razorpay();

  getList() {
    final checkoutRepo = RepositoryProvider.of<OndcCheckoutRepository>(context);
    List<PreviewWidgetOndcItem> previewItems = [];
    for (var element in checkoutRepo.previewFinalModels) {
      previewItems.add(PreviewWidgetOndcItem(previewWidgetModel: element));
    }
    setState(() {
      previewWidgetItems = previewItems;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(ProfileController profileCon) async {
    var options = {
      'key': AppHelpers().razorPayApi,
      'amount': finalCostingModel?.itemCost,
      'name': profileCon.customerDetails?.customerName,
      'order_id': orderId,
      'description': 'Payment',
      'prefill': {
        'contact': '${profileCon.customerDetails?.phoneNumber}',
        'email': '${profileCon.customerDetails?.emailId}'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      rethrow;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    warningLog(
        'success ${response.orderId} ${response.paymentId} ${response.signature}');
    Future.delayed(
      Duration(seconds: 1),
      () => context.read<CheckoutBloc>().add(
            VerifyPaymentEvent(
              razorpayOrderIdFromRazor: response.orderId!,
              razorpayPaymentIdFromRazor: response.paymentId!,
              razorpaySignature: response.signature!,
            ),
          ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    warningLog('error ${response.message}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${response.message}'),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    warningLog('${response.walletName}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error making payment from ${response.walletName}'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getList();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    context.read<CheckoutBloc>().add(
          GetCartPriceEventPost(
            transactionId:
                RepositoryProvider.of<OndcRepository>(context).transactionId,
            storeLocation_id: widget.storeLocation_id,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    warningLog(AppHelpers().razorPayApi);
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        debugLog('$state');
        if (state is CheckoutPostSuccess) {
          setState(() {
            messageID = state.messageId;
          });

          Future.delayed(
            Duration(seconds: 1),
            () => context.read<CheckoutBloc>().add(
                  GetFinalItemsEvent(
                    messageId: state.messageId,
                    storeLocation_id: widget.storeLocation_id,
                    transactionId:
                        RepositoryProvider.of<OndcRepository>(context)
                            .transactionId,
                  ),
                ),
          );
        }
        if (state is InitializePostSuccessState) {
          context.read<CheckoutBloc>().add(
                InitializeGetEvent(
                    order_id:
                        RepositoryProvider.of<OndcCheckoutRepository>(context)
                            .orderId),
              );
        }
        if (state is InitializeGetSuccessState) {
          //! STATUS KEYWORD - CREATED ...
          //! STATUS KEYWORD - INITIATED THEN RUN BLOC
          context.read<CheckoutBloc>().add(
                InitializeCartEvent(
                    customerId: AppHelpers().getPhoneNumberWithoutCountryCode,
                    messageId: messageID),
              );
        }
        // if (state is CheckoutGetSuccess) {
        //   errorLog(
        //       'checking to see if the right message id is being sent $messageID');
        //   context.read<CheckoutBloc>().add(
        //         GetFinalItemsEvent(
        //             transactionId:
        //                 RepositoryProvider.of<OndcRepository>(context)
        //                     .transactionId,
        //             messageId: messageID),
        //       );
        // }
        if (state is FinalizeProductSuccessState) {
          setState(() {
            finalCostingModel = state.finalCostingModel;
          });
        }
        if (state is InitializeCartSuccessState) {
          orderId = state.orderId;


          openCheckout(profileController);
        }
        if (state is FinalizePaymentSuccessState) {
          RepositoryProvider.of<OndcCartRepository>(context)
              .cartOndcModels
              .clear();
          // context.read<CartBloc>().clear();


          warningLog("ORDER ID IS HEREE ########################################## ${RepositoryProvider.of<OndcCheckoutRepository>(context)
              .orderId}");
          context.read<SingleOrderDetailsBloc>().add(
              LoadDataEvent(orderId: RepositoryProvider.of<OndcCheckoutRepository>(context)
                  .orderId
              )


          );
          Get.to(
            () => PaymentSuccessView(),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
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
          ),
          body: GetBuilder<ProfileController>(
            init: profileController,
            id: 'navDrawer',
            builder: (_) {
              CustomerModel currentUser =
                  profileController.customerDetails ?? fallback_error_customer;
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
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
                            'Checkout',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Shipping Details',
                          style: TextStyle(
                            color: AppColors().brandDark,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Delivery to:',
                          style: TextStyle(
                            color: AppColors().brandDark,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          currentUser.address,
                          style: TextStyle(
                              color: AppColors().grey100, fontSize: 13),
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.phone,
                    //         color: AppColors().brandDark,
                    //       ),
                    //       Text(
                    //         currentUser.phoneNumber,
                    //         style: TextStyle(
                    //             color: AppColors().grey100, fontSize: 13),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    //   child: Divider(
                    //     thickness: 2,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        'Payment Details',
                        style: TextStyle(
                          color: AppColors().brandDark,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 15.0, right: 15, left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Billing address:',
                          style: TextStyle(
                              color: AppColors().brandDark, fontSize: 13),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          currentUser.address,
                          style: TextStyle(
                              color: AppColors().grey100, fontSize: 13),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Items',
                          style: TextStyle(color: AppColors().brandDark),
                        ),
                      ),
                    ),
                    ...previewWidgetItems,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal:',
                            style: TextStyle(
                              color: AppColors().grey100,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '₹ ${finalCostingModel?.itemCost}',
                            style: TextStyle(
                                color: AppColors().grey100, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    //toDo : packaging charges to be added here
                    finalCostingModel?.discount == 0
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Packing Charges:',
                                  style: TextStyle(
                                    color: AppColors().grey100,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '₹ ${finalCostingModel?.discount}',
                                  style: TextStyle(
                                      color: AppColors().black100,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                    //todo: packaging charges to be added
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Charges:',
                            style: TextStyle(
                              color: AppColors().grey100,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '₹ ${finalCostingModel?.deliveryCost}',
                            style: TextStyle(
                              color: AppColors().black100,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                    finalCostingModel?.miscCost == 0
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Miscellaneous:',
                                  style: TextStyle(
                                    color: AppColors().grey100,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '₹ ${finalCostingModel?.miscCost}',
                                  style: TextStyle(
                                      color: AppColors().black100,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                    finalCostingModel?.discount == 0
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Discount:',
                                  style: TextStyle(
                                    color: AppColors().grey100,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '₹ ${finalCostingModel?.discount}',
                                  style: TextStyle(
                                      color: AppColors().black100,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tax:',
                            style: TextStyle(
                              color: AppColors().grey100,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '₹ ${finalCostingModel?.tax}',
                            style: TextStyle(
                                color: AppColors().black100, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              );
            },
          ),
          bottomSheet: SizedBox(
            height: 100,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                            color: AppColors().grey100,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹ ${finalCostingModel?.itemCost}',
                        style: TextStyle(
                            fontSize: 18,
                            color: AppColors().grey100,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CheckoutBloc>().add(
                              InitializePostEvent(
                                  message_id: messageID,
                                  order_id: RepositoryProvider.of<
                                          OndcCheckoutRepository>(context)
                                      .orderId),
                            );
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(AppColors().brandDark),
                      ),
                      child: state is FinalizePaymentLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text('Proceed to pay'),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
