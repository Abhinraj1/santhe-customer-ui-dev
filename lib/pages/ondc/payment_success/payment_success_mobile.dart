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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 50,
              ),
              Lottie.network(
                  'https://assets5.lottiefiles.com/packages/lf20_w8cudppm.json'),
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
              Image.asset('assets/successOrder.png'),
              // const SizedBox(
              //   height: 20,
              // ),
              Image.asset('assets/processOrder.png'),
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

                    Get.to(() => const ONDCOrderDetailsView());
                  },
                  horizontalPadding: 20,
                  width: 300,
                  buttonTitle: "ORDER DETAILS",
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
