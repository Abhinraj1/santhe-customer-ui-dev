part of api_error_view;

class _ApiErrorMobile extends StatefulWidget {
  _ApiErrorMobile();

  @override
  State<_ApiErrorMobile> createState() => _ApiErrorMobileState();
}

class _ApiErrorMobileState extends State<_ApiErrorMobile> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    return Scaffold(
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
                // Get.off(() => const OndcIntroView());
                Get.off(
                  HyperlocalShophomeView(
                      // lat: profileController.customerDetails!.lat,
                      // lng: profileController.customerDetails!.lng
                  ),
                );
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
              'https://assets8.lottiefiles.com/packages/lf20_suhe7qtm.json'),
          const SizedBox(
            height: 30,
          ),
          Text(
            'Error occurred, Please try again',
            style: TextStyle(
                color: AppColors().brandDark, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
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
              onPressed: () => Get.back(),
              child: const Text('BACK'),
            ),
          )
        ],
      ),
    );
  }
}
