// ignore_for_file: public_member_api_docs, sort_constructors_first
part of error_nack_view;

class _ErrorNackMobile extends StatefulWidget {
  final String message;
  _ErrorNackMobile({required this.message});

  @override
  State<_ErrorNackMobile> createState() => _ErrorNackMobileState();
}

class _ErrorNackMobileState extends State<_ErrorNackMobile> with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        debugLog('$state');
        if (state is FinalizePaymentErrorState) {}
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Image.asset('assets/circleerror.png'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Image.asset('assets/errororder.png'),
              const SizedBox(
                height: 20,
              ),
              Image.asset('assets/checkerrordetail.png')
            ],
          ),
        );
      },
    );
  }
}
