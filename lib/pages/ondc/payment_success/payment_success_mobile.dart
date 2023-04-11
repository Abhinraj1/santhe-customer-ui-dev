part of payment_success_view;

class _PaymentSuccessMobile extends StatefulWidget {
  const _PaymentSuccessMobile();

  @override
  State<_PaymentSuccessMobile> createState() => _PaymentSuccessMobileState();
}

class _PaymentSuccessMobileState extends State<_PaymentSuccessMobile>
    with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
      warningLog("########################## STATE = $state");
    }, builder: (context, state) {
      return WillPopScope(
        onWillPop: () async {
          Get.back();
          Get.back();
          Get.back();
          return true;
        },
        child: Scaffold(
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
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Lottie.asset('assets/successlottie.json'),
                // Stack(
                //   children: [
                //     Center(
                //       child: Image.asset('assets/circlegreen.png'),
                //     ),
                //     Center(
                //       child: Padding(
                //         padding: const EdgeInsets.only(top: 30),
                //         child: Image.asset('assets/tick.png'),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Your order has been successfully placed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors().brandDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Thank you,We are processing your order',
                      style: TextStyle(color: AppColors().grey80, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                    onTap: () {
                      BlocProvider.of<OrderDetailsScreenCubit>(context)
                          .loadOrderDetails(
                              orderId:
                                  RepositoryProvider.of<OndcCheckoutRepository>(
                                          context)
                                      .orderId);

                      Get.offAll(() => ONDCOrderDetailsView(
                            onBackButtonTap: () {
                              Get.to(OndcShopListView(
                                customerModel: customerModel,
                              ));
                            },
                          ));
                    },
                    horizontalPadding: 20,
                    width: 300,
                    buttonTitle: "ORDER DETAILS",
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
