// ignore_for_file: public_member_api_docs, sort_constructors_first
part of hyperlocal_cancelreason_view;

class _HyperlocalCancelreasonMobile extends StatefulWidget {
  final String orderId;
  const _HyperlocalCancelreasonMobile({required this.orderId});

  @override
  State<_HyperlocalCancelreasonMobile> createState() =>
      _HyperlocalCancelreasonMobileState();
}

class _HyperlocalCancelreasonMobileState
    extends State<_HyperlocalCancelreasonMobile> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.5),
            child: IconButton(
              onPressed: () {
                // ge.Get.off(
                //   () => const OndcIntroView(),
                // );
                ge.Get.back();
                ge.Get.back(result: 'Cancelled');
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
                        // ge.Get.back(result: 'Cancelled');
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
                    'Cancel Order',
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
            // Center(
            //   child: Text(
            //     'Order ID : ${widget.orderId}',
            //     style: TextStyle(color: AppColors().grey100),
            //   ),
            // ),
            const SizedBox(
              height: 140,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Your cancellation request is received,'
                      ' Refund will be initiated in next 72 hours',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors().grey100, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
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
    context.read<HyperlocalCheckoutBloc>().add(
      GetOrderInfoEvent(
        orderId: RepositoryProvider.of<HyperLocalCheckoutRepository>(context)
          .shopOrderId,
      ),
    );
    ge.Get.close(1);
    ge.Get.back(result: 'Cancelled');
  }
}
