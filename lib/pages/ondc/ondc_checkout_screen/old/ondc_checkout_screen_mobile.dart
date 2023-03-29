// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

part of ondc_checkout_screen_view;

class _OndcCheckoutScreenMobile extends StatefulWidget {
  final String storeLocation_id;
  final String? storeName;
  _OndcCheckoutScreenMobile({
    Key? key,
    required this.storeLocation_id,
    required this.storeName,
  }) : super(key: key);

  @override
  State<_OndcCheckoutScreenMobile> createState() =>
      _OndcCheckoutScreenMobileOldState();
}

class _OndcCheckoutScreenMobileOldState extends State<_OndcCheckoutScreenMobile>
    with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<FinalCostingModel> finalCostingModel = [];
  late final String messageID;
  double subtotal = 0;
  double deliveryCharges = 0;
  double taxescgst = 0;
  double taxessgst = 0;
  String? orderId;
  int countNumber = 0;
  bool _isLoading = false;
  List<PreviewWidgetOndcItem> previewWidgetItems = [];
  List<ShipmentSegregatorModel> shipmentSegregatorModels = [];
  List<ShipmentSegregator> shipmentSegregatorWidgets = [];
  late GroupedItemScrollController _controller;
  bool isLoadingInit = false;
  bool isLoadingInitGet = false;
  String? subTotal;
  String? total;
  String? tax;
  String? deliveryCharge;
  String? convenianceCharge;
  String? discount;
  String? packing;
  String? miscellaneous;
  Razorpay _razorpay = Razorpay();
  bool _showErrorNoResponseFromSeller = false;
  bool _showOneOrMoreItemsAreNotAvailable = false;
  String? billingAddress;
  bool _showAllItemsAreNotAvailable = false;
  List<FinalCostingWidget> finalCostingWidget = [];

  bool _isInitBuffer = false;

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
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   setTimer(state != AppLifecycleState.resumed);
  // }

  void setTimer(bool isBackground) {
    int delaySeconds = isBackground ? 5 : 3;

    // Cancelling previous timer, if there was one, and creating a new one
    Timer.periodic(Duration(seconds: delaySeconds), (t) async {
      // Not sending a request, if waiting for response
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

//   _scrollListener() {
//   if (_controller.offset >= _controller.position.maxScrollExtent &&
//      !_controller.position.outOfRange) {
//    setState(() {//you can do anything here
//    });
//  }
//  if (_controller.offset <= _controller.position.minScrollExtent &&
//     !_controller.position.outOfRange) {
//    setState(() {//you can do anything here
//     });
//   }
// }

  void openCheckout(ProfileController profileCon) async {
    var options = {
      'key': AppHelpers().razorPayApi,
      'amount': total,
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
    // Future.delayed(
    //   Duration(seconds: 1),
    //   () =>
    context.read<CheckoutBloc>().add(
          VerifyPaymentEvent(
            razorpayOrderIdFromRazor: response.orderId!,
            razorpayPaymentIdFromRazor: response.paymentId!,
            razorpaySignature: response.signature!,
            messageId: messageID,
            transactionId:
                RepositoryProvider.of<OndcRepository>(context).transactionId,
          ),
        );
    // )
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

  Widget _getGroupSeparator(PreviewWidgetOndcItem element, int countNum) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.87,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          border: Border.all(
            color: CupertinoColors.systemBackground,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  'Shipment No ${countNum}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: AppColors().brandDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
      billingAddress =
          RepositoryProvider.of<AddressRepository>(context).billingModel?.flat;
    });
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
    _controller = GroupedItemScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    warningLog(AppHelpers().razorPayApi);
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        debugLog('$state');
        if (state is FinalizeProductErrorState) {
          Get.back(
            result: state.message,
          );
        }
        if (state is CheckoutPostError) {
          Get.back(
            result: 'There is an Error',
          );
        }
        if (state is RetryPostSelectState) {
          Timer.periodic(
            Duration(seconds: 5),
            (timer) => context.read<CheckoutBloc>().add(
                  GetCartPriceEventPost(
                    transactionId:
                        RepositoryProvider.of<OndcRepository>(context)
                            .transactionId,
                    storeLocation_id: widget.storeLocation_id,
                  ),
                ),
          );
        }
        if (state is RetryGetSelectState) {
          Timer.periodic(
            Duration(seconds: 5),
            (timer) => context.read<CheckoutBloc>().add(
                  GetFinalItemsEvent(
                    messageId: messageID,
                    storeLocation_id: widget.storeLocation_id,
                    transactionId:
                        RepositoryProvider.of<OndcRepository>(context)
                            .transactionId,
                  ),
                ),
          );
        }
        if (state is RetryGetInitState) {
          Timer.periodic(
            Duration(seconds: 5),
            (timer) => context.read<CheckoutBloc>().add(
                  InitializeGetEvent(
                      order_id:
                          RepositoryProvider.of<OndcCheckoutRepository>(context)
                              .orderId),
                ),
          );
        }
        if (state is RetryPostInitState) {
          Timer.periodic(
            Duration(seconds: 5),
            (timer) => context.read<CheckoutBloc>().add(
                  InitializePostEvent(
                      message_id: messageID,
                      order_id:
                          RepositoryProvider.of<OndcCheckoutRepository>(context)
                              .orderId),
                ),
          );
        }
        if (state is CheckoutPostSuccess) {
          setState(() {
            messageID = state.messageId;
          });
          warningLog(
              "MESSAGEID RECEIVED HERE ###################### $messageID");
          Future.delayed(
            Duration(seconds: 5),
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
          //! 30 second continuous hit
        }

        if (state is InitializePostErrorState) {
          setState(() {
            isLoadingInit = false;
            _showErrorNoResponseFromSeller = true;
            _isInitBuffer = false;
          });
        }
        if (state is InitializeGetErrorState) {
          setState(() {
            _showErrorNoResponseFromSeller = true;
            isLoadingInitGet = false;
            _isInitBuffer = false;
          });
        }
        if (state is InitializePostSuccessState) {
          setState(() {
            isLoadingInit = false;
            isLoadingInitGet = true;
          });
          Future.delayed(
            Duration(seconds: 5),
            () => context.read<CheckoutBloc>().add(
                  InitializeGetEvent(
                      order_id:
                          RepositoryProvider.of<OndcCheckoutRepository>(context)
                              .orderId),
                ),
          );
        }

        if (state is InitializeGetSuccessState) {
          //! STATUS KEYWORD - CREATED ...
          //! STATUS KEYWORD - INITIATED THEN RUN BLOC
          setState(() {
            isLoadingInitGet = false;
          });
          Future.delayed(
            Duration(seconds: 5),
            () => context.read<CheckoutBloc>().add(
                  InitializeCartEvent(
                      customerId: AppHelpers().getPhoneNumberWithoutCountryCode,
                      messageId: messageID),
                ),
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
        if (state is FinalizeProductErrorState) {
          if (state.message.contains(
              'Quantity of one or more items items in your cart is updated or are not deliverable anymore.please review before proceeding')) {
            setState(() {
              _showOneOrMoreItemsAreNotAvailable = true;
            });
          } else {
            setState(() {
              _showAllItemsAreNotAvailable = true;
            });
          }
        }
        if (state is FinalizeProductSuccessState) {
          previewWidgetItems = [];
          final checkoutRepo =
              RepositoryProvider.of<OndcCheckoutRepository>(context);

          List<PreviewWidgetOndcItem> previewItems = [];

          debugLog('items $previewItems and $previewWidgetItems');

          List<PreviewWidgetModel> previewModels = [];
          finalCostingModel = [];
          previewModels = checkoutRepo.previewFinalModels
              .where((element) => element.type.toString().contains('item'))
              .toList();

          errorLog('preview models ${previewModels.length}');
          // List<ShipmentSegregatorModel> shipmentModels = [];
          // List<ShipmentSegregator> shipmentWidget = [];
          // shipmentModels = checkoutRepo.shipmentFinalModels;
          // debugLog('Checking for shipment models ${shipmentModels}');
          for (var element in previewModels) {
            previewItems.add(
              PreviewWidgetOndcItem(previewWidgetModel: element),
            );
          }

          warningLog('$previewItems');
          setState(() {
            finalCostingModel = state.finalCostingModel;
            total = finalCostingModel
                .firstWhere((element) => element.lable == 'Total Amount')
                .value
                .toString();
            subTotal = finalCostingModel
                .firstWhere((element) => element.lable == 'Subtotal')
                .value
                .toString();

            // deliveryCharge = finalCostingModel
            //     .where((element) => element.lable == 'Delivery charges')
            //     .value
            //     .toString();
            // tax = finalCostingModel
            //     .firstWhere((element) => element.lable == 'Tax')
            //     .value
            //     .toString();
            // discount = finalCostingModel
            //     .firstWhere((element) => element.lable == 'Discount')
            //     .value
            //     .toString();
            // miscellaneous = finalCostingModel
            //     .firstWhere((element) => element.lable == "miscellaneous")
            //     .value
            //     .toString();
            // convenianceCharge = finalCostingModel
            //     .firstWhere((element) => element.lable == 'Conveniance')
            //     .value
            //     .toString();
            // packing = finalCostingModel
            //     .firstWhere((element) => element.lable == 'Packing')
            //     .value
            //     .toString();
            previewWidgetItems = previewItems;
            _isLoading = false;
          });
          for (var element in finalCostingModel) {
            finalCostingWidget.add(
              FinalCostingWidget(finalCostingModel: element),
            );
          }
        }
        if (state is InitializeCartSuccessState) {
          orderId = state.orderId;

          openCheckout(profileController);
        }
        if (state is FinalizePaymentLoading) {
          RepositoryProvider.of<OndcCartRepository>(context)
              .cartOndcModels
              .clear();
          // context.read<CartBloc>().clear();

          Get.off(PaymentBufferView(
            messageId: messageID,
            transactionId:
                RepositoryProvider.of<OndcRepository>(context).transactionId,
          ));
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              key: _key,
              drawer: const nv.CustomNavigationDrawer(),
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
                    fontSize: 24,
                  ),
                ),
              ),
              body: GetBuilder<ProfileController>(
                init: profileController,
                id: 'navDrawer',
                builder: (_) {
                  CustomerModel currentUser =
                      profileController.customerDetails ??
                          fallback_error_customer;
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
                              // CircleAvatar(
                              //   backgroundColor: AppColors().brandDark,
                              //   radius: 20,
                              //   child: const Icon(
                              //     Icons.arrow_back,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              const CustomBackButton(),
                              const SizedBox(
                                width: 80,
                              ),
                              Text(
                                'CHECKOUT',
                                style: TextStyle(
                                    color: AppColors().brandDark, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Shop Name: ${widget.storeName}',
                          style: TextStyle(
                            color: AppColors().brandDark,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                            : const Text(''),
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
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
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
                        // Center(
                        //   child: Text(
                        //     'Payment Details',
                        //     style: TextStyle(
                        //       color: AppColors().brandDark,
                        //       fontSize: 15,
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.only(top: 15.0, right: 15, left: 15),
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text(
                        //       'Billing address:',
                        //       style: TextStyle(
                        //           color: AppColors().brandDark, fontSize: 13),
                        //     ),
                        //   ),
                        // ),
                        // AddressColumn(
                        //     title: "Payment Details",
                        //     addressType: "Billing Address:",
                        //     address: (RepositoryProvider.of<AddressRepository>(
                        //                 context)
                        //             .billingModel
                        //             ?.flat)
                        //         .toString(),
                        //     hasEditButton: true,
                        //     onTap: () {
                        //       isBillingAddress = true;

                        //       Get.to(
                        //         () => const MapTextView(),
                        //       );
                        //     }),
                        ///
                        // Center(
                        //   child: Text(
                        //     'Payment Details',
                        //     style: TextStyle(
                        //       color: AppColors().brandDark,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 16,
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 15.0, left: 15.0),
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text(
                        //       'Billing Address:',
                        //       style: TextStyle(
                        //         color: AppColors().brandDark,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.only(left: 15.0, right: 15.0),
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text(
                        //       '${RepositoryProvider.of<AddressRepository>(context).billingAddressModel?.flat}',
                        //       style: TextStyle(
                        //           color: AppColors().grey100, fontSize: 13),
                        //     ),
                        //   ),
                        // ),

                        ///
                        AddressColumn(
                            title: "Payment Details",
                            addressType: "Billing Address:",
                            address: '$billingAddress',
                            hasEditButton: true,
                            onTap: () async {
                              isBillingAddress = true;

                              final String address = await Get.to(
                                () => const MapTextView(),
                              );
                              setState(() {
                                billingAddress =
                                    RepositoryProvider.of<AddressRepository>(
                                            context)
                                        .billingModel
                                        ?.flat;
                              });
                              warningLog(
                                  'Checking for vague message $billingAddress');
                            }),

                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Items',
                              style: TextStyle(color: AppColors().brandDark),
                            ),
                          ),
                        ),
                        //! error message if the cart items have changed
                        _showAllItemsAreNotAvailable
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  padding: EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Unfortunately either the items are not available \n anymore or the seller does not have delivery \nservices to your address,Please try with a \n different shop',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Text(''),
                        _showOneOrMoreItemsAreNotAvailable
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  padding: EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Quantity of one or more items in your cart \n is updated or are not deliverable anymore. Please\n review before proceeding',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Text(''),
                        //! add the shipment logic here
                        _showAllItemsAreNotAvailable
                            ? Text('')
                            : StickyGroupedListView<PreviewWidgetOndcItem,
                                String>(
                                shrinkWrap: true,
                                elements: previewWidgetItems,
                                stickyHeaderBackgroundColor:
                                    CupertinoColors.systemBackground,
                                itemScrollController: _controller,
                                groupBy: (PreviewWidgetOndcItem previewWidget) {
                                  return previewWidget
                                      .previewWidgetModel.deliveryFulfillmentId;
                                },
                                groupSeparatorBuilder:
                                    (PreviewWidgetOndcItem previewWidget) {
                                  countNumber = countNumber + 1;
                                  return _getGroupSeparator(
                                      previewWidget, countNumber);
                                },
                                itemBuilder: (context, previewWidgetModel) {
                                  warningLog(
                                      'Length passed into builder ${previewWidgetItems.length}');
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      elevation: 8.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 1,
                                          ),
                                          previewWidgetModel.previewWidgetModel
                                                          .symbol !=
                                                      null &&
                                                  previewWidgetModel
                                                          .previewWidgetModel
                                                          .symbol !=
                                                      ""
                                              ? Image.network(
                                                  previewWidgetModel
                                                      .previewWidgetModel
                                                      .symbol,
                                                  width: 50,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  ImgManager().santheIcon,
                                                  width: 50,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                          SizedBox(
                                            height: 70,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width: 200,
                                                      child: AutoSizeText(
                                                        previewWidgetModel
                                                            .previewWidgetModel
                                                            .title,
                                                        style:
                                                            FontStyleManager()
                                                                .s12fw700Brown,
                                                        maxLines: 2,
                                                      )),

                                                  Text(
                                                    '${previewWidgetModel.previewWidgetModel.quantity}',
                                                    style: FontStyleManager()
                                                        .s10fw500Brown,
                                                  ),
                                                  //  showStatus ?? false ?
                                                  //  Text(status.toString(),style: FontStyleManager().s12fw500Grey,) :
                                                  //  textButtonTitle != null && textButtonOnTap != null ?
                                                  //      TextButton(
                                                  //          onPressed: (){
                                                  //            textButtonOnTap();
                                                  //          },
                                                  //          child: Text(textButtonTitle,
                                                  //          style: FontStyleManager().s12fw500Red,),) :
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: SizedBox(
                                              width: 50,
                                              child: AutoSizeText(
                                                "₹ ${previewWidgetModel.previewWidgetModel.price}",
                                                maxFontSize: 14,
                                                minFontSize: 12,
                                                style: FontStyleManager()
                                                    .s16fw600Grey,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                        //! shipment ends
                        _showAllItemsAreNotAvailable
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: 80,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
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
                                  child: Text('Back'),
                                ),
                              )
                            : Text(''),
                        ...finalCostingWidget,
                        SizedBox(
                          height: 100,
                        ),
                        // subTotal == null
                        //     ? Text('')
                        //     : Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //           horizontal: 15.0,
                        //         ),
                        //         child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               'Subtotal:',
                        //               style: TextStyle(
                        //                 color: AppColors().grey100,
                        //                 fontSize: 15,
                        //               ),
                        //             ),
                        //             Text(
                        //               '₹ ${subTotal}',
                        //               style: TextStyle(
                        //                   color: AppColors().grey100,
                        //                   fontSize: 15),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        // // //toDo : packaging charges to be added here
                        // _showAllItemsAreNotAvailable
                        //     ? Text('')
                        //     : packing == null
                        //         ? Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 15.0),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Text(
                        //                   'Packing Charges:',
                        //                   style: TextStyle(
                        //                     color: AppColors().grey100,
                        //                     fontSize: 15,
                        //                   ),
                        //                 ),
                        //                 Text(
                        //                   '₹ ${packing}',
                        //                   style: TextStyle(
                        //                       color: AppColors().black100,
                        //                       fontSize: 15),
                        //                 )
                        //               ],
                        //             ),
                        //           )
                        //         : SizedBox(),
                        // // //todo: packaging charges to be added
                        // deliveryCharge == null
                        //     ? Text('')
                        //     : Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 15.0),
                        //         child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               'Delivery Charges:',
                        //               style: TextStyle(
                        //                 color: AppColors().grey100,
                        //                 fontSize: 15,
                        //               ),
                        //             ),
                        //             Text(
                        //               '₹ ${deliveryCharge}',
                        //               style: TextStyle(
                        //                 color: AppColors().black100,
                        //                 fontSize: 15,
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        // _showAllItemsAreNotAvailable
                        //     ? Text('')
                        //     : miscellaneous == null
                        //         ? Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 15.0),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Text(
                        //                   'Miscellaneous:',
                        //                   style: TextStyle(
                        //                     color: AppColors().grey100,
                        //                     fontSize: 15,
                        //                   ),
                        //                 ),
                        //                 Text(
                        //                   '₹ ${miscellaneous}',
                        //                   style: TextStyle(
                        //                       color: AppColors().black100,
                        //                       fontSize: 15),
                        //                 )
                        //               ],
                        //             ),
                        //           )
                        //         : SizedBox(),
                        // _showAllItemsAreNotAvailable
                        //     ? Text('')
                        //     : discount == null
                        //         ? Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 15.0),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Text(
                        //                   'Discount:',
                        //                   style: TextStyle(
                        //                     color: AppColors().grey100,
                        //                     fontSize: 15,
                        //                   ),
                        //                 ),
                        //                 Text(
                        //                   '₹ ${discount}',
                        //                   style: TextStyle(
                        //                       color: AppColors().black100,
                        //                       fontSize: 15),
                        //                 )
                        //               ],
                        //             ),
                        //           )
                        //         : SizedBox(),
                        // _showAllItemsAreNotAvailable
                        //     ? Text('')
                        //     : Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 15.0),
                        //         child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               'Tax:',
                        //               style: TextStyle(
                        //                 color: AppColors().grey100,
                        //                 fontSize: 15,
                        //               ),
                        //             ),
                        //             Text(
                        //               '₹ ${tax}',
                        //               style: TextStyle(
                        //                   color: AppColors().black100,
                        //                   fontSize: 15),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        // SizedBox(
                        //   height: 100,
                        // ),
                      ],
                    ),
                  );
                },
              ),
              bottomSheet: _showAllItemsAreNotAvailable
                  ? Text('')
                  : Container(
                      color: CupertinoColors.systemBackground,
                      height: 100,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total:',
                                  style: TextStyle(
                                      color: AppColors().brandDark,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '₹ ${total}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors().brandDark,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isLoadingInit = true;
                                    _isInitBuffer = true;
                                  });
                                  Future.delayed(Duration(seconds: 5), () {
                                    context.read<CheckoutBloc>().add(
                                          InitializePostEvent(
                                              message_id: messageID,
                                              order_id: RepositoryProvider.of<
                                                          OndcCheckoutRepository>(
                                                      context)
                                                  .orderId),
                                        );
                                  });
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
                                child: state is FinalizePaymentLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : isLoadingInit
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : isLoadingInitGet
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.grey,
                                                ),
                                              )
                                            : Text('PROCEED TO PAY'),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ),
            _isLoading
                ? Material(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.network(
                                  'https://assets9.lottiefiles.com/packages/lf20_dkz94xcg.json'),
                              const SizedBox(
                                height: 60,
                              ),
                              Text(
                                'Preparing your cart',
                                style: TextStyle(
                                  color: AppColors().brandDark,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Please wait while we prepare your cart',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : _isInitBuffer
                    ? Material(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.network(
                                      'https://assets9.lottiefiles.com/packages/lf20_dkz94xcg.json'),
                                  const SizedBox(
                                    height: 60,
                                  ),
                                  Text(
                                    'Redirecting to Payment',
                                    style: TextStyle(
                                      color: AppColors().brandDark,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: const Text(
                                      'Please wait while we bring up the payment options',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Text('')
          ],
        );
      },
    );
  }
}
