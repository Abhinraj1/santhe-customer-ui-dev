// ignore_for_file: prefer_const_constructors_in_immutables

part of ondc_intro_view;

class _OndcIntroMobile extends StatefulWidget {
  _OndcIntroMobile();

  @override
  State<_OndcIntroMobile> createState() => _OndcIntroMobileState();
}

class _OndcIntroMobileState extends State<_OndcIntroMobile>
    with TickerProviderStateMixin, LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final AllListController _allListController = Get.find();
  final ProfileController _profileController = Get.find();
  final HomeController _homeController = Get.find();
  final NotificationController _notificationController = Get.find();
  final APIs apiController = Get.find();

  _launchUrl() async {
    final url = Uri.parse('https://www.youtube.com/watch?v=BkvCsbmzkU8');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  initFunction() async {
    _homeController.homeTabController =
        TabController(length: 3, vsync: this, initialIndex: 0);
    sv.SystemChrome.setSystemUIOverlayStyle(const sv.SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    await _profileController.initialise();
    await _profileController.getOperationalStatus();
    _allListController.getAllList();
    _allListController.checkSubPlan();
    /*Connectivity().onConnectivityChanged.listen((ConnectivityResult result) =>
        _connectivityController.listenConnectivity(result));*/
    APIs().updateDeviceToken(
      AppHelpers()
          .getPhoneNumberWithoutFoundedCountryCode(AppHelpers().getPhoneNumber),
    );
    apiController.searchedItemResult('potato');
    _notificationController.fromNotification = false;
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
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
              fontWeight: FontWeight.w800, color: Colors.white, fontSize: 24),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.5),
            child: IconButton(
              onPressed: () {
                if (Platform.isIOS) {
                  Share.share(
                    AppHelpers().appStoreLink,
                  );
                } else {
                  Share.share(
                    AppHelpers().playStoreLink,
                  );
                }
              },
              splashRadius: 25.0,
              icon: const Icon(
                Icons.share,
                color: Colors.white,
                size: 27.0,
              ),
            ),
          )
        ],
      ),
      body: GetBuilder(
          init: profileController,
          id: 'navDrawer',
          builder: (context) {
            CustomerModel currentUser =
                profileController.customerDetails ?? fallback_error_customer;
            return RefreshIndicator(
              onRefresh: () => initFunction(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: AutoSizeText(
                        'Welcome ${currentUser.customerName}!',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Image.asset('assets/createList.png'),
                            const Text(
                              '*Includes waiting for merchants\n to give prices, but you have more\n options here',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                              ),
                              onPressed: () {
                                Get.to(
                                  const MapMerchant(),
                                  transition: Transition.leftToRight,
                                );
                              },
                              child: const Text(
                                'Create List',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset('assets/ondclist.png'),
                            const Text(
                              '*Buy from ONDC registered \n shops near you.\n *You can see prices immediately\n and checkout,but your options\n are limite',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                              ),
                              onPressed: () {

                                Get.to(
                                  () => OndcShopListView(
                                    customerModel: currentUser,
                                  ),
                                );
                              },
                              child: const Text(
                                'Shop Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }


}
