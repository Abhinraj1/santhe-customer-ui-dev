// ignore_for_file: public_member_api_docs, sort_constructors_first
part of hyperlocal_returnscreen_view;

class _HyperlocalReturnscreenMobile extends StatefulWidget {
  final HyperLocalPreviewModel hyperlocalPreviewModel;
  final String reason;
  const _HyperlocalReturnscreenMobile({
    Key? key,
    required this.hyperlocalPreviewModel,
    required this.reason,
  }) : super(key: key);

  @override
  State<_HyperlocalReturnscreenMobile> createState() =>
      _HyperlocalReturnscreenMobileState();
}

class _HyperlocalReturnscreenMobileState
    extends State<_HyperlocalReturnscreenMobile> with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isSelected = false;
  String reason = '';
  late final Map quantity;
  late final dynamic mapQuantity;
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HyperlocalImageReturnRequestCubit,
        HyperlocalImageReturnRequestState>(
      listener: (context, state) {
        warningLog('listening$state');
        if (state is HyperlocalUploadImagesSuccessState) {
          // BlocProvider.of<HyperlocalImageReturnRequestCubit>(context)
          //     .postReturnReasons(
          //         reason: widget.reason,
          //         orderItemId: widget.hyperlocalPreviewModel.id,
          //         images: state.imageUrls);
        }
        if (state is HyperlocalReturnRequestSuccessState) {
          ge.Get.to(
            const HyperlocalReturnconfirmView(),
          );
        }
      },
      builder: (context, state) {
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
                      style:
                          TextStyle(color: AppColors().grey100, fontSize: 15),
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
                      style:
                          TextStyle(color: AppColors().black100, fontSize: 15),
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
                      'Upload Pictures',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: AppColors().grey100, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Please upload at least one picture of the product showing any defects or damage',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: AppColors().grey100, fontSize: 16),
                    ),
                  ),
                ),
                const HyperlocalImageGrid(),
                BlocBuilder<HyperlocalImageReturnRequestCubit,
                        HyperlocalImageReturnRequestState>(
                    builder: (context, state) {
                  if (state is HyperlocalShowReturnImagesState) {
                    return CustomButton(
                        buttonTitle: "RETURN ITEM",
                        onTap: () {
                          BlocProvider.of<HyperlocalImageReturnRequestCubit>(
                                  context)
                              .uploadImages(
                                  context: context,
                                  reason: widget.reason,
                                  orderItemId:
                                      widget.hyperlocalPreviewModel.id);
                        },
                        isActive: true,
                        width: 160,
                        verticalPadding: 20);
                  } else if (state is HyperlocalReturnImagesLimitReachedState) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const ErrorContainerWidget(
                            message: "Please Select Maximum Of 4 Images"),
                        CustomButton(
                            buttonTitle: "RETURN ITEM",
                            onTap: () {},
                            isActive: false,
                            width: 160,
                            verticalPadding: 20),
                      ],
                    );
                  } else if (state is HyperlocalHideAddImagesButtonState) {
                    return CustomButton(
                        buttonTitle: "RETURN ITEM",
                        onTap: () {
                          BlocProvider.of<HyperlocalImageReturnRequestCubit>(
                                  context)
                              .uploadImages(
                                  context: context,
                                  reason: widget.reason,
                                  orderItemId:
                                      widget.hyperlocalPreviewModel.id);
                        },
                        isActive: true,
                        width: 160,
                        verticalPadding: 20);
                  } else {
                    return CustomButton(
                        buttonTitle: "RETURN ITEM",
                        onTap: () {},
                        isActive: false,
                        width: 160,
                        verticalPadding: 20);
                  }
                })
              ],
            ),
          ),
        );
      },
    );
  }
}
