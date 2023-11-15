part of hyperlocal_returnconfirm_view;

class _HyperlocalReturnconfirmMobile extends StatefulWidget {
  const _HyperlocalReturnconfirmMobile();

  @override
  State<_HyperlocalReturnconfirmMobile> createState() =>
      _HyperlocalReturnconfirmMobileState();
}

class _HyperlocalReturnconfirmMobileState
    extends State<_HyperlocalReturnconfirmMobile> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: InkWell(
                      onTap: () {
                        _onBack();
                        // ge.Get.back();
                        // ge.Get.back();
                        // ge.Get.back(result: 'Returned');
                      },
                      child: CircleAvatar(
                        backgroundColor: AppColors().brandDark,
                        radius: 13,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 7.0),
                          child: Icon(Icons.arrow_back_ios,
                              size: 17, color: AppColors().white100),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Return Order',
                    style:
                        TextStyle(color: AppColors().brandDark, fontSize: 20),
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
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1.',
                      style: TextStyle(
                        color: AppColors().grey100,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Your return request is received, Once we have received a confirmation from the seller/shop you will get an update from us on the return status',
                        style: TextStyle(
                          color: AppColors().grey100,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2.',
                      style: TextStyle(
                        color: AppColors().grey100,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Please be aware that if the shop doesn’t pick up return items,'
                            ' you will have to ship the'
                            ' items to shop at your own cost. Please contact the '
                            'shop to arrange for returns.',
                        style: TextStyle(
                          color: AppColors().grey100,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      '3.',
                      style: TextStyle(
                        color: AppColors().grey100,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Terms and Conditions Applies',
                        style: TextStyle(
                          color: AppColors().grey100,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, bottom: 20, left: 50, right: 50),
              child: MaterialButton(
                color: AppColors().brandDark,
                elevation: 2,
                onPressed: () {
                  _onBack();
                  // ge.Get.back();
                  // ge.Get.back(result: 'Cancelled');
                },
                height: 40,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(customButtonBorderRadius),
                ),
                minWidth: 250,
                child: const Center(
                  child: Text(
                    "Back",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  _onBack(){
    ge.Get.close(4);
    ge.Get.to(()=> HyperlocalOrderdetailView(
      orderId:RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
          .shopOrderId,
    ));
  }
}
