// ignore_for_file: public_member_api_docs, sort_constructors_first
part of hyperlocal_returnreason_view;

class _HyperlocalReturnreasonMobile extends StatefulWidget {
  final HyperLocalPreviewModel hyperlocalPreviewModel;
  const _HyperlocalReturnreasonMobile({
    required this.hyperlocalPreviewModel,
  });

  @override
  State<_HyperlocalReturnreasonMobile> createState() =>
      _HyperlocalReturnreasonMobileState();
}

class _HyperlocalReturnreasonMobileState
    extends State<_HyperlocalReturnreasonMobile> with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late final Map quantity;
  late final dynamic mapQuantity;
  List<HyperlocalCancelWidget> returnWidget = [];
  List<HyperlocalCancelModel> returnModels = [];
  bool isSelected = false;
  String reason = '';
  bool _showCancelButton = false;
  int length = 0;
  getQuantity() {
    quantity = json.decode(
      widget.hyperlocalPreviewModel.quantity.toString(),
    );
    errorLog('Quantity $quantity');
    mapQuantity = quantity['value'].toString() + quantity['unit'];
    errorLog('Final quantity $mapQuantity');
  }

  @override
  void initState() {
    super.initState();

    getQuantity();
    context
        .read<HyperlocalCancelReturnBloc>()
        .add(GetHyperlocalReturnReasonsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HyperlocalCancelReturnBloc,
        HyperlocalCancelReturnState>(
      listener: (context, state) {
        debugLog('${state}');
        if (state is GetHyperlocalReturnReasonsSuccessState) {
          List<HyperlocalCancelModel> returnModelsLoc = [];
          returnModelsLoc = state.returnModels;
          setState(() {
            returnModels = returnModelsLoc;
            length = returnModels.length;
          });
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
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
                            'Return Order',
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
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Text(
                          'You wish to return the following item: ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors().grey100, fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${widget.hyperlocalPreviewModel.title}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors().black100, fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${widget.hyperlocalPreviewModel.units} * $mapQuantity',
                          style: FontStyleManager().s10fw500Brown,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Please select a reason for cancelling your order',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors().grey100, fontSize: 16),
                        ),
                      ),
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
                                if (returnModels[length].isSelected == true) {
                                  setState(() {
                                    returnModels[length].isSelected = false;
                                    _showCancelButton = false;
                                  });
                                } else {
                                  setState(() {
                                    returnModels[length].isSelected = true;
                                    _showCancelButton = true;
                                  });
                                  for (var element in returnModels) {
                                    if (element.id != returnModels[length].id) {
                                      setState(() {
                                        element.isSelected = false;
                                        reason = returnModels[length].reason;
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
                                                returnModels[length].isSelected
                                                    ? AppColors().primaryOrange
                                                    : AppColors().grey100)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircleAvatar(
                                          backgroundColor:
                                              returnModels[length].isSelected
                                                  ? AppColors().primaryOrange
                                                  : AppColors().white100),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 280,
                                    child: Text(
                                      '${returnModels[length].reason}',
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
                                ge.Get.to(
                                  HyperlocalReturnscreenView(
                                    hyperlocalPreviewModel:
                                        widget.hyperlocalPreviewModel,
                                    reason: reason,
                                  ),
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
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Center(
                                      child: Text(
                                        "Next",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
            state is GetHyperlocalReturnReasonsLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox()
          ],
        );
      },
    );
  }
}
