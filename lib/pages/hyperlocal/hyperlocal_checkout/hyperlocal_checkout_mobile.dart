// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, prefer_final_fields, unused_field, unnecessary_brace_in_string_interps
part of hyperlocal_checkout_view;

class _HyperlocalCheckoutMobile extends StatefulWidget {
  final String storeDescription_id;
  final String storeName;
  const _HyperlocalCheckoutMobile({
    Key? key,
    required this.storeDescription_id,
    required this.storeName,
  }) : super(key: key);

  @override
  State<_HyperlocalCheckoutMobile> createState() =>
      _HyperlocalCheckoutMobileState();
}

class _HyperlocalCheckoutMobileState extends State<_HyperlocalCheckoutMobile>
    with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late final String messageID;
  double subtotal = 0;
  double deliveryCharges = 0;
  double taxescgst = 0;
  double taxessgst = 0;
  String? orderId;
  int countNumber = 0;
  bool _isLoading = false;
  bool isLoadingInit = false;
  bool isLoadingInitGet = false;
  dynamic subTotal;
  dynamic total;
  dynamic tax;
  dynamic deliveryCharge;
  dynamic convenianceCharge;
  dynamic discount;
  dynamic packing;
  dynamic miscellaneous;
  List<HyperLocalPreviewModel> hyperlocalPreviewModels = [];
  List<HyperlocalPreviewWidget> hyperlocalPreviewWidgets = [];
  late GroupedItemScrollController _controller;
  Razorpay _razorpay = Razorpay();
  bool _showErrorNoResponseFromSeller = false;
  bool _showOneOrMoreItemsAreNotAvailable = false;
  String? billingAddress;
  bool _showAllItemsAreNotAvailable = false;
  bool _showPriceHasChanged = false;
  late String order_id;

  late HyperlocalPaymentInfoModel paymentInfoModel;

  bool _isInitBuffer = false;

  void openCheckout(ProfileController profileCon) async {
    // String newTotal = priceFormatter(value: '133.333333333');
    // errorLog('new total formatted${double.parse(newTotal)}');
    // double totalAmount = double.parse(newTotal);
    // double subTotal = totalAmount * 100;
    // int finalTotal = int.parse(subtotal.toString());
    // errorLog('Checking for total $totalAmount and total $subTotal');
    var options = {
      'key': AppHelpers().razorPayApi,
      'amount': total,
      'name': profileCon.customerDetails?.customerName,
      'order_id': paymentInfoModel.id,
      "currency": "INR",
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
        'success orderId ${response.orderId} paymentId ${response.paymentId} Signature ${response.signature}');
    setState(() {
      _isInitBuffer = true;
    });
    Future.delayed(
      const Duration(seconds: 1),
      () => context.read<HyperlocalCheckoutBloc>().add(
            VerifyPaymentEventHyperlocal(
                razorPayOrderId: response.orderId,
                razorPayPaymentId: response.paymentId,
                razorPaySignature: response.signature),
          ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    warningLog('error ${response.message}');
    Get.back(result: 'Error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error ${response.message}'),
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

  // Widget _getGroupSeparator(HyperlocalPreviewWidget element, int countNum) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 10.0),
  //     child: Align(
  //       alignment: Alignment.centerLeft,
  //       child: Container(
  //         width: MediaQuery.of(context).size.width * 0.87,
  //         decoration: BoxDecoration(
  //           color: CupertinoColors.systemBackground,
  //           border: Border.all(
  //             color: CupertinoColors.systemBackground,
  //           ),
  //           borderRadius: const BorderRadius.all(Radius.circular(8.0)),
  //         ),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: AutoSizeText(
  //                   'Shipment No ${countNum}',
  //                   textAlign: TextAlign.left,
  //                   style: TextStyle(color: AppColors().brandDark),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
    context.read<HyperlocalCheckoutBloc>().add(
        GetOrderInfoPostEvent(storeDescription_id: widget.storeDescription_id));
    _controller = GroupedItemScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    return BlocConsumer<HyperlocalCheckoutBloc, HyperlocalCheckoutState>(
      listener: (context, state) {
        warningLog('checkout State $state');
        if (state is PostPaymentHyperlocalErrorState) {
          setState(() {
            _showErrorNoResponseFromSeller = true;
            _isInitBuffer = false;
          });
        }
        if (state is VerifyPaymentHyperlocalSuccessState) {
          errorLog('Success With payment');
          Get.off(
            () => HyperlocalPaymentsucessView(
              storeDescriptionId: widget.storeDescription_id,
            ),
          );
        }
        if (state is VerifyPaymentHyperlocalErrorState) {
          Get.to(() => const HyperlocalErrornackView());
        }
        if (state is VerifyPaymentHyperlocalErrorState) {
          setState(() {
            _isInitBuffer = false;
          });
        }
        if (state is VerifyPaymentHyperlocalLoadingState) {}
        if (state is PostPaymentHyperlocalSuccessState) {
          paymentInfoModel = state.hyperlocalPaymentInfo;
          errorLog('Payment Info Model $paymentInfoModel');
          openCheckout(profileController);
        }
        if (state is GetOrderInfoPostErrorState) {
          setState(() {
            _showErrorNoResponseFromSeller = true;
          });
        }
        if (state is GetOrderInfoErrorState) {
          setState(() {
            _showPriceHasChanged = true;
          });
        }
        if (state is GetOrderInfoPostSuccessState) {
          setState(() {
            _showErrorNoResponseFromSeller = false;
            order_id = state.orderId;
          });
          context.read<HyperlocalCheckoutBloc>().add(
                GetOrderInfoEvent(orderId: state.orderId),
              );
        }
        if (state is GetOrderInfoSuccessState) {
          List<HyperlocalPreviewWidget> previewWidgetsLocal = [];
          hyperlocalPreviewModels = [];
          hyperlocalPreviewWidgets = [];
          hyperlocalPreviewModels = state.hyperLocalPreviewModels;
          deliveryCharge = '';
          deliveryCharge =
              RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
                  .deliveryCharge;
          tax = '';
          tax =
              RepositoryProvider.of<HyperLocalCheckoutRepository>(context).tax;
          convenianceCharge = '';
          convenianceCharge =
              RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
                  .convenienceFee;
          subTotal = '';
          subTotal =
              RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
                  .subTotal;
          total = '';
          total = RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
              .total;
          for (var element in hyperlocalPreviewModels) {
            previewWidgetsLocal.add(
              HyperlocalPreviewWidget(hyperLocalPreviewModel: element),
            );
          }
          warningLog('Preview Widgets $previewWidgetsLocal');
          setState(() {
            _isLoading = false;
            hyperlocalPreviewWidgets = previewWidgetsLocal;
          });
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
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                              Text(
                                'CHECKOUT',
                                style: TextStyle(
                                    color: AppColors().brandDark, fontSize: 20),
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
                          height: 10,
                        ),
                        Text(
                          'Shop: ${widget.storeName}',
                          style: TextStyle(
                            color: AppColors().brandDark,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _showPriceHasChanged
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
                                      'Error Fetching items, Try again',
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
                                      'Unable to Create order.Please try later',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
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
                              '${RepositoryProvider.of<AddressRepository>(context).deliveryModel?.flat}',
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
                        const SizedBox(
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

                        const SizedBox(
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
                            : const SizedBox(),
                        _showOneOrMoreItemsAreNotAvailable
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  padding: const EdgeInsets.all(15.0),
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
                            : const SizedBox(),

                        //! shipment
                        _showAllItemsAreNotAvailable
                            ? const Text('')
                            : Column(
                                children: hyperlocalPreviewWidgets,
                              ),
                        // : StickyGroupedListView<HyperlocalPreviewWidget,
                        //     String>(
                        //     shrinkWrap: true,
                        //     elements: hyperlocalPreviewWidgets,
                        //     stickyHeaderBackgroundColor:
                        //         CupertinoColors.systemBackground,
                        //     itemScrollController: _controller,
                        //     groupBy: (HyperlocalPreviewWidget previewWidget) {
                        //       return previewWidget
                        //           .hyperLocalPreviewModel.storeDescriptionId;
                        //     },
                        //     groupSeparatorBuilder:
                        //         (HyperlocalPreviewWidget previewWidget) {
                        //       countNumber = countNumber + 1;
                        //       return _getGroupSeparator(
                        //           previewWidget, countNumber);
                        //     },
                        //     itemBuilder: (context, previewWidgetModel) {
                        //       warningLog(
                        //           'Length passed into builder ${hyperlocalPreviewWidgets.length}');
                        //       return Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 12, vertical: 5),
                        //         child: Card(
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(6.0),
                        //           ),
                        //           elevation: 8.0,
                        //           margin: const EdgeInsets.symmetric(
                        //               horizontal: 10.0),
                        //           child: Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               const SizedBox(
                        //                 width: 1,
                        //                 height: 100,
                        //               ),
                        //               previewWidgetModel.hyperLocalPreviewModel
                        //                               .symbol !=
                        //                           null &&
                        //                       previewWidgetModel
                        //                               .hyperLocalPreviewModel
                        //                               .symbol !=
                        //                           ""
                        //                   ? ClipRRect(
                        //                       borderRadius:
                        //                           BorderRadius.circular(10.0),
                        //                       child: CachedNetworkImage(
                        //                         imageUrl: previewWidgetModel
                        //                             .hyperLocalPreviewModel
                        //                             .symbol,
                        //                         width: 70,
                        //                         height: 70,
                        //                         fit: BoxFit.cover,
                        //                         errorWidget:
                        //                             (context, url, error) =>
                        //                                 Image.asset(
                        //                           ImgManager().santheIcon,
                        //                           width: 70,
                        //                           height: 70,
                        //                           fit: BoxFit.cover,
                        //                         ),
                        //                       ),
                        //                     )
                        //                   : ClipRRect(
                        //                       borderRadius:
                        //                           BorderRadius.circular(10.0),
                        //                       child: Image.asset(
                        //                         ImgManager().santheIcon,
                        //                         width: 70,
                        //                         height: 70,
                        //                         fit: BoxFit.cover,
                        //                       ),
                        //                     ),
                        //               SizedBox(
                        //                 height: 70,
                        //                 child: Padding(
                        //                   padding:
                        //                       const EdgeInsets.only(left: 8.0),
                        //                   child: Column(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.spaceEvenly,
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                     children: [
                        //                       SizedBox(
                        //                           width: 120,
                        //                           child: AutoSizeText(
                        //                             previewWidgetModel
                        //                                 .hyperLocalPreviewModel
                        //                                 .title,
                        //                             style: FontStyleManager()
                        //                                 .s12fw700Brown,
                        //                             maxLines: 2,
                        //                           )),

                        //                       Text(
                        //                         '${previewWidgetModel.hyperLocalPreviewModel.units} units',
                        //                         style: FontStyleManager()
                        //                             .s10fw500Brown,
                        //                       ),
                        //                       //  showStatus ?? false ?
                        //                       //  Text(status.toString(),style: FontStyleManager().s12fw500Grey,) :
                        //                       //  textButtonTitle != null && textButtonOnTap != null ?
                        //                       //      TextButton(
                        //                       //          onPressed: (){
                        //                       //            textButtonOnTap();
                        //                       //          },
                        //                       //          child: Text(textButtonTitle,
                        //                       //          style: FontStyleManager().s12fw500Red,),) :
                        //                       const SizedBox(
                        //                         height: 5,
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ),
                        //               Padding(
                        //                 padding:
                        //                     const EdgeInsets.only(right: 5.0),
                        //                 child: Center(
                        //                   child: SizedBox(
                        //                     width: 70,
                        //                     child: Align(
                        //                       alignment: Alignment.centerRight,
                        //                       child: AutoSizeText(
                        //                         "₹ ${previewWidgetModel.hyperLocalPreviewModel.price}",
                        //                         maxFontSize: 14,
                        //                         minFontSize: 12,
                        //                         style: FontStyleManager()
                        //                             .s16fw600Grey,
                        //                         overflow: TextOverflow.ellipsis,
                        //                         maxLines: 2,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        //! grouping done
                        RepositoryProvider.of<HyperLocalCheckoutRepository>(
                                            context)
                                        .convenienceFee !=
                                    null &&
                                RepositoryProvider.of<
                                                HyperLocalCheckoutRepository>(
                                            context)
                                        .convenienceFee !=
                                    0
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Conveniance Charges : ',
                                      style: TextStyle(
                                          color: AppColors().grey100,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      '₹${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).convenienceFee}',
                                      style: TextStyle(
                                          color: AppColors().black100,
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),

                        // tax != null
                        //     ? Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 30.0, vertical: 10),
                        //         child: Row(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               'Tax : ',
                        //               style: TextStyle(
                        //                   color: AppColors().grey100,
                        //                   fontSize: 15),
                        //             ),
                        //             Text(
                        //               '₹${tax}',
                        //               style: TextStyle(
                        //                   color: AppColors().black100,
                        //                   fontSize: 15),
                        //             )
                        //           ],
                        //         ),
                        //       )
                        //     : const SizedBox(),
                        subTotal != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Subtotal : ',
                                      style: TextStyle(
                                          color: AppColors().grey100,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      '₹${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).subTotal}',
                                      style: TextStyle(
                                          color: AppColors().black100,
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        deliveryCharge != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Delivery Charges : ',
                                      style: TextStyle(
                                          color: AppColors().grey100,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      '₹${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).deliveryCharge}',
                                      style: TextStyle(
                                          color: AppColors().black100,
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        // total != null
                        //     ? Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 30.0, vertical: 10),
                        //         child: Row(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               'Total : ',
                        //               style: TextStyle(
                        //                   color: AppColors().grey100,
                        //                   fontSize: 15),
                        //             ),
                        //             Text(
                        //               '₹${total}',
                        //               style: TextStyle(
                        //                   color: AppColors().black100,
                        //                   fontSize: 15),
                        //             )
                        //           ],
                        //         ),
                        //       )
                        //     : const SizedBox(),
                        const SizedBox(
                          height: 150,
                        ),
                      ],
                    ),
                  );
                },
              ),
              bottomSheet: Container(
                color: CupertinoColors.systemBackground,
                height: 100,
                child: Column(children: [
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          // setState(() {
                          //   isLoadingInit = true;
                          //   _isInitBuffer = true;
                          // });
                          // //! messageId is actually orderId please keep that in mind
                          // Future.delayed(Duration(seconds: 5), () {
                          //   context.read<CheckoutBloc>().add(
                          //         InitializePostEvent(
                          //             order_id: messageID),
                          //       );
                          // });
                          setState(() {
                            isLoadingInit = true;
                          });
                          context.read<HyperlocalCheckoutBloc>().add(
                                PostPaymentCheckoutEvent(
                                  orderId: order_id,
                                ),
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
                        child:
                            // state is FinalizePaymentLoading
                            //     ? Center(
                            //         child: CircularProgressIndicator(
                            //           color: Colors.white,
                            //         ),
                            //       )
                            isLoadingInit
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                //         : isLoadingInitGet
                                //             ? Center(
                                //                 child:
                                //                     CircularProgressIndicator(
                                //                   color: Colors.grey,
                                //                 ),
                                //               )
                                //             :
                                : const Text('PROCEED TO PAY'),
                      ),
                    ),
                  ),
                ]),
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
                                'Checking out',
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
                                'Finalizing order',
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
                                    'Verifying payment',
                                    style: TextStyle(
                                      color: AppColors().brandDark,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Center(
                                    child: Text(
                                      'Please wait while we verify your payment',
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
                    : const Text('')
          ],
        );
      },
    );
  }
}
