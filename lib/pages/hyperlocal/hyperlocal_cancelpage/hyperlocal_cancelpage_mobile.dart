// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

part of hyperlocal_cancelpage_view;

class _HyperlocalCancelpageMobile extends StatefulWidget {
  final String orderID;
  _HyperlocalCancelpageMobile({required this.orderID});

  @override
  State<_HyperlocalCancelpageMobile> createState() =>
      _HyperlocalCancelpageMobileState();
}

class _HyperlocalCancelpageMobileState
    extends State<_HyperlocalCancelpageMobile> with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<HyperlocalCancelWidget> cancelWidgets = [];
  List<HyperlocalCancelModel> cancelModels = [];
  int length = 0;
  bool isSelected = false;
  String reason = '';
  bool _showCancelButton = false;

  @override
  void initState() {
    super.initState();
    context
        .read<HyperlocalCancelReturnBloc>()
        .add(GetHyperlocalCancelReasonsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HyperlocalCancelReturnBloc,
        HyperlocalCancelReturnState>(
      listener: (context, state) {
        warningLog('state is $state');
        if (state is GetHyperlocalCancelReasonsState) {
          List<HyperlocalCancelWidget> cancelWidgetsLoc = [];
          List<HyperlocalCancelModel> cancelModelLoc = [];
          cancelModelLoc = state.cancelReasons;
          for (var element in cancelModelLoc) {
            cancelWidgetsLoc.add(
              HyperlocalCancelWidget(hyperlocalCancelModel: element),
            );
          }
          setState(() {
            cancelModels = cancelModelLoc;
            cancelWidgets = cancelWidgetsLoc;
            length = cancelModels.length;
          });
        }
        if (state is PostHyperlocalCancelReasonSuccessState) {
          ge.Get.to(
            HyperlocalCancelreasonView(
              orderID: widget.orderID,
            ),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
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
                    SizedBox(
                      height: 30,
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
                                ge.Get.back();
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
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Text(
                          'All items in your order will be cancelled. Please select a reason for cancelling your order',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors().grey100, fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      itemCount: length,
                      shrinkWrap: true,
                      itemBuilder: (context, length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: InkWell(
                              onTap: () {
                                if (cancelModels[length].isSelected == true) {
                                  setState(() {
                                    cancelModels[length].isSelected = false;
                                    _showCancelButton = false;
                                  });
                                } else {
                                  setState(() {
                                    cancelModels[length].isSelected = true;
                                    _showCancelButton = true;
                                  });
                                  for (var element in cancelModels) {
                                    if (element.id != cancelModels[length].id) {
                                      setState(() {
                                        element.isSelected = false;
                                        reason = cancelModels[length].reason;
                                      });
                                    }
                                  }
                                }
                                warningLog('Checking for reason $reason');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 15,
                                    width: 15,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1.5,
                                            color:
                                                cancelModels[length].isSelected
                                                    ? AppColors().primaryOrange
                                                    : AppColors().grey100)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircleAvatar(
                                          backgroundColor:
                                              cancelModels[length].isSelected
                                                  ? AppColors().primaryOrange
                                                  : AppColors().white100),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 280,
                                    child: Text(
                                      '${cancelModels[length].reason}',
                                      maxLines: 3,
                                      style: isSelected
                                          ? FontStyleManager().s16fw600Orange
                                          : FontStyleManager().s16fw500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    _showCancelButton
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: 30, bottom: 20, left: 50, right: 50),
                            child: MaterialButton(
                              color: AppColors().brandDark,
                              elevation: 2,
                              onPressed: () {
                                context.read<HyperlocalCancelReturnBloc>().add(
                                      PostHyperlocalCancelReasonsEvent(
                                          orderID: widget.orderID,
                                          reason: reason),
                                    );
                              },
                              height: 40,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    customButtonBorderRadius),
                              ),
                              minWidth: 250,
                              child: state
                                      is PostHyperlocalCancelReasonLoadingState
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        "CANCEL ORDER",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            state is GetHyperlocalCancelReasonsLoadingState
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox()
          ],
        );
      },
    );
  }
}
