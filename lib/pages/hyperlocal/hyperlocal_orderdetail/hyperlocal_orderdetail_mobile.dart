// // ignore_for_file: public_member_api_docs, sort_constructors_first

part of hyperlocal_orderdetail_view;

class _HyperlocalOrderdetailMobile extends StatefulWidget {
 // final String shopDescriptionId;
  final String orderId;
  const _HyperlocalOrderdetailMobile({
    Key? key,
   // required this.shopDescriptionId,
    required this.orderId,
  }) : super(key: key);

  @override
  State<_HyperlocalOrderdetailMobile> createState() =>
      _HyperlocalOrderdetailMobileState();
}

class _HyperlocalOrderdetailMobileState
    extends State<_HyperlocalOrderdetailMobile> with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<HyperlocalPreviewWidget> previewWidgets = [];
  List<HyperLocalPreviewModel> previewModels = [];
  bool _isLoading = false;
  dynamic homeDelivery = '';
  int cancellableCount = 0;
  dynamic formattedDate;
  bool _isloading = false;
  bool _isCancelled = false;
  String supportId = "";

  getHomeDelivery() {
    errorLog(
        'Checking for home Deliver${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).homeDelivery}');
    final dynamic homeDeli = json.decode(
        RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
            .homeDelivery);
    dynamic newFormattedDate = DateTime.parse(
        RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
            .shopOrderDate);
    formattedDate = DateFormat.yMd().format(newFormattedDate);
    warningLog(
        'Home Delivery $homeDeli formatted Date $newFormattedDate formatted Date $formattedDate');
    if (homeDeli['home_delivery'].toString().contains('true')) {
      errorLog('Triggered0');
      homeDelivery = 'Yes';
    } else {
      homeDelivery = 'No';
    }
    errorLog('$homeDelivery');
    setState(() {
      _isloading = false;
    });
  }

  getPreviewWidgets() {
    List<HyperLocalPreviewModel> previewModelsLoc = [];
    List<HyperlocalPreviewWidget> previewWidgetsLoc = [];
    setState(() {
      _isLoading = true;
      previewModelsLoc =
          RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
              .hyperlocalPreviewModels;
    });
    warningLog('Preview Models in order Detail Screen $previewModelsLoc');
    for (var element in previewModelsLoc) {
      previewWidgetsLoc.add(
        HyperlocalPreviewWidget(hyperLocalPreviewModel: element),
      );
      if (element.cancellable == true) {
        setState(() {
          cancellableCount = cancellableCount + 1;
        });
      }
    }
    setState(() {
      previewWidgets = previewWidgetsLoc;
      previewModels = previewModelsLoc;
      _isLoading = false;
    });
    errorLog(
        'Checking for newmodels $previewWidgets and cancellable count $cancellableCount');
  }

  @override
  void initState() {
    super.initState();
    // getPreviewWidgets();
    cancellableCount = 0;
    setState(() {
      _isloading = true;
    });
    context.read<HyperlocalCheckoutBloc>().add(
          GetOrderInfoEvent(
            orderId: widget.orderId,
          ),
        );
    BlocProvider.of<ContactSupportCubit>(context).resetContactSupportCubit();
  }

  Future<void> getUpdatedOrderINfo() async {
    cancellableCount = 0;
    context.read<HyperlocalCheckoutBloc>().add(
          GetOrderInfoEvent(
            orderId:
                RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
                    .shopOrderId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HyperlocalCheckoutBloc, HyperlocalCheckoutState>(
      listener: (context, state) {
        warningLog('HyperlocalCheckoutState $state');
        if (state is GetOrderInfoSuccessState) {
          getPreviewWidgets();
          getHomeDelivery();
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: getUpdatedOrderINfo,
          child: Stack(
            children: [
              WillPopScope(
                onWillPop: () async {
                  Get.back();
                  return false;
                },
                child: Scaffold(
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
                  body: SingleChildScrollView(
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
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: InkWell(
                                  onTap: () {
                                    ge.Get.back();
                                    // Get.off(
                                    //   () =>
                                    //       const HyperlocalPreviousordersView(),
                                    //   transition:ge.Transition.leftToRight,
                                    // );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: AppColors().brandDark,
                                    radius: 13,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 7.0),
                                      child: Icon(Icons.arrow_back_ios,
                                          size: 17,
                                          color: AppColors().white100),
                                    ),
                                  ),
                                ),
                              ),

                              Text(
                                'ORDER DETAILS',
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
                          height: 30,
                        ),
                        //! shop and order details start
                        // RepositoryProvider.of<HyperLocalCheckoutRepository>(context).shopPaymentStatus.toString().contains('true'? const Text('Paid'): const Text('Checking'),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.top,
                            children: [
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text('Shop:'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).shopName}',
                                        textAlign: TextAlign.right),
                                  )
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text('Shop Email:'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).shopEmail}',
                                        textAlign: TextAlign.right),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text('Shop Phone Number:'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).shopPhoneNumber}',
                                        textAlign: TextAlign.right),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text('Shop Address:'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).shopAddress}',
                                        textAlign: TextAlign.right),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text('Order Date'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text('$formattedDate',
                                        textAlign: TextAlign.right),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text('Order ID:'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).userOrderId}',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text('Order Status:'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).shopOrderStatus}',
                                        textAlign: TextAlign.right),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text('Payment Status:'),
                                  ),
                                  RepositoryProvider.of<
                                                  HyperLocalCheckoutRepository>(
                                              context)
                                          .shopPaymentStatus
                                          .toString()
                                          .contains('true')
                                      ? const Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text('Paid',
                                              textAlign: TextAlign.right),
                                        )
                                      : Text(
                                          '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).shopPaymentStatus}',
                                          textAlign: TextAlign.right,
                                        ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      'Home Delivery:',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text('$homeDelivery',
                                        textAlign: TextAlign.right),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, right: 15, bottom: 5),
                            child: GestureDetector(
                              onTap: () {
                                launchUrl(
                                  Uri.parse(
                                      '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).orderInvoice}'),
                                  mode:
                                      LaunchMode.externalNonBrowserApplication,
                                );
                              },
                              child: Text(
                                'Invoice',
                                style: TextStyle(
                                  color: AppColors().red100,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        //! shop and order details end
                        RepositoryProvider.of<HyperLocalCheckoutRepository>(
                                        context)
                                    .returnMessage !=
                                null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).returnMessage}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors().grey100,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(height: 8)
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        homeDelivery.toString().contains('No')
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 15),
                                child: Column(
                                  children: [
                                    Text(
                                      'This is a Self Pickup Order. You will be contacted by Shop to pick up your order, alternately you can contact the shop too. ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors().grey100,
                                          fontSize: 15),
                                    ),
                                    RepositoryProvider.of<
                                                    HyperLocalCheckoutRepository>(
                                                context)
                                            .shopOrderStatus
                                            .toString()
                                            .contains('In Delivery')
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18.0),
                                            child: Text(
                                              'Please verify the items during pick up as returns is not accepted after pick up. ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppColors().grey100,
                                                  fontSize: 15),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        // _isCancelled
                        //     ? Padding(
                        //         padding: const EdgeInsets.all(20.0),
                        //         child: Text(
                        //           'You cancelled this order. '
                        //               'Refund will be initiated in next 72 hours',
                        //           textAlign: TextAlign.center,
                        //           style: TextStyle(
                        //               color: AppColors().grey100, fontSize: 15),
                        //         ),
                        //       )
                        //     : const SizedBox(),

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
                        Column(
                          children: previewWidgets,
                        ),
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
                        RepositoryProvider.of<HyperLocalCheckoutRepository>(
                                        context)
                                    .subTotal !=
                                null
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
                        RepositoryProvider.of<HyperLocalCheckoutRepository>(
                                        context)
                                    .deliveryCharge !=
                                null
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
                        RepositoryProvider.of<HyperLocalCheckoutRepository>(
                                        context)
                                    .total !=
                                null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total : ',
                                      style: TextStyle(
                                          color: AppColors().black100,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '₹${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).total}',
                                      style: TextStyle(
                                          color: AppColors().black100,
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        cancellableCount == previewWidgets.length
                            ? _isCancelled
                                ? const SizedBox()
                                : RepositoryProvider.of<
                                                HyperLocalCheckoutRepository>(
                                            context)
                                        .shopOrderStatus
                                        .toString()
                                        .contains('Cancelled')
                                    ? const SizedBox()
                                    : CancelOrderButton(
                                        onTap: () async {
                                          final String cancelled =
                                              await ge.Get.to(() =>
                                                  HyperlocalCancelpageView(
                                                    orderId: RepositoryProvider
                                                            .of<HyperLocalCheckoutRepository>(
                                                                context)
                                                        .shopOrderId,
                                                  ));
                                          warningLog(
                                              'Checking for cancelled message $cancelled');
                                          if (cancelled.contains('Cancelled')) {
                                            setState(() {
                                              _isCancelled = true;
                                            });
                                          }
                                          warningLog(
                                              'Checking for cancelled message $cancelled and $_isCancelled');
                                        },
                                      )
                            : const SizedBox(),

                        // RepositoryProvider.of<HyperLocalCheckoutRepository>(
                        //                 context)
                        //             .shopOrderStatus
                        //             .toString()
                        //             .contains('Delivered') &&
                        //         RepositoryProvider.of<
                        //                         HyperLocalCheckoutRepository>(
                        //                     context)
                        //                 .support ==
                        //             null
                        //     ? CustomerSupportButton(onTap: () {})
                        //     : RepositoryProvider.of<
                        //                         HyperLocalCheckoutRepository>(
                        //                     context)
                        //                 .shopOrderStatus
                        //                 .toString()
                        //                 .contains('Delivered') &&
                        //             RepositoryProvider.of<
                        //                             HyperLocalCheckoutRepository>(
                        //                         context)
                        //                     .support !=
                        //                 null
                        //         ? Padding(
                        //             padding: const EdgeInsets.only(
                        //                 bottom: 5, left: 20, right: 20),
                        //             child: MaterialButton(
                        //               onPressed: () {},
                        //               height: 40,
                        //               shape: RoundedRectangleBorder(
                        //                   borderRadius: BorderRadius.circular(
                        //                       customButtonBorderRadius),
                        //                   side: BorderSide(
                        //                       color: AppColors().grey40,
                        //                       width: 1)),
                        //               minWidth: 250,
                        //               child: Text(
                        //                 "Support Ticket",
                        //                 style: FontStyleManager().s14fw700Grey,
                        //               ),
                        //             ),
                        //           )
                        //         : const SizedBox(),
                        _showContactSupportButton() ?
                        CustomerSupportButton(
                          title:_showSupportTicketButton() ?
                          "SUPPORT TICKET" : null,
                            onTap: () async{
                            if(_showSupportTicketButton()){

                              Get.to(()=> HyperlocalContactSupportDetailsScreenMobile(
                              supportId: supportId,
                              ),
                                  transition: ge.Transition.rightToLeft);
                            }else{
                              String data = await Get.to(()=>
                                  OpenSupportTicketScreenMobile(
                                orderId: widget.orderId,
                              ),
                              transition: ge.Transition.rightToLeft);

                              if(data.isNotEmpty){
                                getUpdatedOrderINfo();
                              }
                            }
                            }) :
                        const SizedBox(),

                      ],
                    ),
                  ),
                ),
              ),
              _isloading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const Text('')
            ],
          ),
        );
      },
    );
  }

  bool _showContactSupportButton(){
  DateTime createdAt = RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
      .shopOrderDate!= null ?
        DateTime.parse(
      RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
      .shopOrderDate) : DateTime.now();

    DateTime today = DateTime.now();

    String orderStatus = RepositoryProvider.of<
        HyperLocalCheckoutRepository>(context).shopOrderStatus.toString();
    if(orderStatus.contains("Return") ||
        orderStatus.contains("Delivered") && (
            today.isAfter(createdAt.add(const Duration(days: 2))) &&
            today.isBefore(createdAt.add(const Duration(days: 30))))){

      return true;
    }else{
      return false;
    }
  }

  bool _showSupportTicketButton(){
    model.OrderInfo orderInfo = RepositoryProvider.of
    <HyperLocalCheckoutRepository>(context).orderInfo;

    if(orderInfo.data!.support != null){
      supportId = orderInfo.data!.support!.id.toString();
      return true;

    }else{
      return false;
    }
  }
}
