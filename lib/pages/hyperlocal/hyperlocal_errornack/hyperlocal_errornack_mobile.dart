part of hyperlocal_errornack_view;

class _HyperlocalErrornackMobile extends StatefulWidget {
  const _HyperlocalErrornackMobile();

  @override
  State<_HyperlocalErrornackMobile> createState() =>
      _HyperlocalErrornackMobileState();
}

class _HyperlocalErrornackMobileState
    extends State<_HyperlocalErrornackMobile> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
      ),
    );
  }
}
