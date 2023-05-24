// ignore_for_file: public_member_api_docs, sort_constructors_first
part of hyperlocal_orderdetail_view;

class _HyperlocalOrderdetailMobile extends StatefulWidget {
  final String shopDescriptionId;
  const _HyperlocalOrderdetailMobile({
    required this.shopDescriptionId,
  });

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

  getHomeDelivery() {
    errorLog(
        'Checking for home Deliver${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).homeDelivery}');
    final dynamic homeDeli = json.decode(
        RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
            .homeDelivery);
    warningLog('Home Delivery $homeDeli');
    if (homeDeli['home_delivery'].toString().contains('true')) {
      errorLog('Triggered0');
      homeDelivery = 'Yes';
    } else {
      homeDelivery = 'No';
    }
    errorLog('$homeDelivery');
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
    }
    setState(() {
      previewWidgets = previewWidgetsLoc;
      previewModels = previewModelsLoc;
      _isLoading = false;
    });
    debugLog('Checking for newmodels $previewWidgets');
  }

  @override
  void initState() {
    super.initState();
    // getPreviewWidgets();
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
                          const CustomBackButton(),

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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Shop'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                          ),
                          Text(
                              '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).shopName}'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Shop Email'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).shopEmail}'),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Shop Address'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.28,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).shopAddress}'),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Order Date'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.34,
                          ),
                          Text(
                              '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).paymentModel.created_at}'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Order Id'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.385,
                          ),
                          Expanded(
                            child: Text(
                                '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).shopOrderId}'),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Order status'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                          ),
                          Text(
                              '${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).shopOrderStatus}'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Payment status'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                          ),
                          RepositoryProvider.of<HyperLocalCheckoutRepository>(
                                      context)
                                  .shopPaymentStatus
                                  .toString()
                                  .contains('true')
                              ? const Text('Paid')
                              : const Text('Checking'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Home Delivery'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                          ),
                          Text('$homeDelivery'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ],
                      ),
                    ),
                    //! shop and order details end
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
                                      color: AppColors().grey100, fontSize: 15),
                                ),
                                RepositoryProvider.of<
                                                HyperLocalCheckoutRepository>(
                                            context)
                                        .shopOrderStatus
                                        .toString()
                                        .contains('In Delivery')
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 18.0),
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
                    RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
                                    .convenienceFee !=
                                null &&
                            RepositoryProvider.of<HyperLocalCheckoutRepository>(
                                        context)
                                    .convenienceFee !=
                                0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Conveniance Charges : ',
                                  style: TextStyle(
                                      color: AppColors().grey100, fontSize: 15),
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
                    RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
                                .subTotal !=
                            null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal : ',
                                  style: TextStyle(
                                      color: AppColors().grey100, fontSize: 15),
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
                    RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
                                .deliveryCharge !=
                            null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Charges : ',
                                  style: TextStyle(
                                      color: AppColors().grey100, fontSize: 15),
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
                    RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
                                .total !=
                            null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
                            .shopOrderStatus
                            .toString()
                            .contains('Created')
                        ? CancelOrderButton(onTap: () {})
                        : const SizedBox(),
                    RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
                            .shopOrderStatus
                            .toString()
                            .contains('Delivered')
                        ? CustomerSupportButton(onTap: () {})
                        : const SizedBox()
                  ],
                ),
              ),
            ),
            _isLoading
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
