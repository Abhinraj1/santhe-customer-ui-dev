part of payment_buffer_view;

class _PaymentBufferMobile extends StatefulWidget {
  _PaymentBufferMobile();

  @override
  State<_PaymentBufferMobile> createState() => _PaymentBufferMobileState();
}

class _PaymentBufferMobileState extends State<_PaymentBufferMobile>
    with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
      warningLog('$state');
      if (state is FinalizePaymentSuccessState) {
        RepositoryProvider.of<OndcCartRepository>(context)
            .cartOndcModels
            .clear();
        // context.read<CartBloc>().clear();
        Get.off(
          () => const PaymentSuccessView(),
        );
      }
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/circularProgress.png'),
                const SizedBox(
                  height: 60,
                ),
                Text(
                  'Processing your Payment',
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
                  'Please wait while we are processing your payment',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
