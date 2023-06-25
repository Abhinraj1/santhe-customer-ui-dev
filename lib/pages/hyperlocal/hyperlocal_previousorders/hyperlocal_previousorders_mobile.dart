// ignore_for_file: use_build_context_synchronously, unused_field

part of hyperlocal_previousorders_view;

class _HyperlocalPreviousordersMobile extends StatefulWidget {
  const _HyperlocalPreviousordersMobile();

  @override
  State<_HyperlocalPreviousordersMobile> createState() =>
      _HyperlocalPreviousordersMobileState();
}

class _HyperlocalPreviousordersMobileState
    extends State<_HyperlocalPreviousordersMobile> with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<HyperlocalOrderDetailWidget> orderList = [];
  List<HyperlocalOrderDetailModel> orderModels = [];
  List<HyperlocalOrderDetailWidget> originalList = [];
  List<HyperlocalOrderDetailModel> originalModels = [];
  final ScrollController _sevenScrollController = ScrollController();
  final ScrollController _thirtyScrollController = ScrollController();
  final ScrollController _customScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  bool customControllerSelected = false;
  bool sevenControllerSelected = false;
  bool thirtyControllerSelected = false;
  bool _isLoading = false;
  int nSeven = 0;
  int nThirty = 0;
  int nCustom = 0;
  String selectedValue = "";
  String hint = "";
  bool _isEmpty = false;
  dynamic selectedDates;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    errorLog('called on rebuild');
    context.read<HyperlocalOrderhistoryBloc>().add(
          SevenDaysFilterHyperLocalOrderEvent(nSeven: nSeven),
        );
    _sevenScrollController.addListener(() {
      if (_sevenScrollController.position.pixels ==
          _sevenScrollController.position.maxScrollExtent) {
        setState(() {
          nSeven = nSeven + 10;
        });
        warningLog('new search items and limit Seven $nSeven');
        context
            .read<HyperlocalOrderhistoryBloc>()
            .add(SevenDaysFilterHyperlocalOrderScrollEvent(nSeven: nSeven));
      }
    });
    _thirtyScrollController.addListener(() {
      if (_thirtyScrollController.position.pixels ==
          _thirtyScrollController.position.maxScrollExtent) {
        setState(() {
          nThirty = nThirty + 10;
        });
        warningLog('new search items and limit Thirty $nThirty');
        context
            .read<HyperlocalOrderhistoryBloc>()
            .add(ThirtyDaysFilterScrollHyperlocalOrderEvent(nthirty: nThirty));
      }
    });
    _customScrollController.addListener(() {
      if (_customScrollController.position.pixels ==
          _customScrollController.position.maxScrollExtent) {
        setState(() {
          nCustom = nCustom + 10;
        });
        warningLog('new search items and limit Custom $nCustom');
        context.read<HyperlocalOrderhistoryBloc>().add(
            CustomDaysScrollFilterHyperlocalOrderEvent(
                nCustom: nCustom, selectedDates: selectedDates));
      }
    });
  }

  String _getValueText2(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    errorLog('Called');
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate- $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  @override
  Widget build(BuildContext context) {
    warningLog(
        'length of order model regardless of filter ${orderModels.length}');
    final ProfileController profileController = ge.Get.find<ProfileController>();

    TextEditingController datePickedController = TextEditingController();

    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
        TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
        dayTextStyle: dayTextStyle,
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor: AppColors().primaryOrange,
        closeDialogOnCancelTapped: true,
        firstDayOfWeek: 1,
        weekdayLabelTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        controlsTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
        dayTextStylePredicate: ({required date}) {
          TextStyle? textStyle;
          if (date.weekday == DateTime.saturday ||
              date.weekday == DateTime.sunday) {
            textStyle = weekendTextStyle;
          }
          if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
            textStyle = anniversaryTextStyle;
          }
          return textStyle;
        },
        dayBuilder: ({
          required date,
          textStyle,
          decoration,
          isSelected,
          isDisabled,
          isToday,
        }) {
          Widget? dayWidget;
          if (date.day % 3 == 0 && date.day % 9 != 0) {
            dayWidget = Container(
              decoration: decoration,
              child: Center(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Text(
                      MaterialLocalizations.of(context).formatDecimal(date.day),
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            );
          }
          return dayWidget;
        });
    return BlocConsumer<HyperlocalOrderhistoryBloc,
        HyperlocalOrderhistoryState>(
      listener: (context, state) {
        debugLog('$state');
        if( state is ThirtyDaysLoadingState ||
            state is CustomDaysLoadingState ||
            state is SevenDaysLoadingState){
        _isLoading = true;
        Future.delayed(const Duration(seconds: 2)).then((value) =>       setState(() {_isLoading = false;}));

        }
        if (state is SevenDaysFilterHyperlocalOrderState) {
          List<HyperlocalOrderDetailWidget> locWidgets = [];
          orderModels = [];
          orderList.clear();
          orderModels.clear();
          orderModels = state.orderDetailsModels;
          for (var element in state.orderDetailsModels) {
            locWidgets.add(
              HyperlocalOrderDetailWidget(hyperlocalOrderDetailModel: element),
            );
          }
          setState(() {
            _isLoading = false;
            selectedValue = "7days";
            sevenControllerSelected = true;
            customControllerSelected = false;
            thirtyControllerSelected = false;
            orderModels = state.orderDetailsModels;
            orderList = locWidgets;
          });
          warningLog('Seven days${orderList.length}');
          context
              .read<HyperlocalOrderhistoryBloc>()
              .add(ResetOrderHistoryEvent());
        }
        if (state is SevenDaysFilterHyperlocalOrderScrollState) {
          List<HyperlocalOrderDetailWidget> locWidgets = [];
          for (var element in state.orderDetailsModels) {
            locWidgets.add(
              HyperlocalOrderDetailWidget(hyperlocalOrderDetailModel: element),
            );
          }
          setState(() {
            orderModels.addAll(state.orderDetailsModels);
            orderList.addAll(locWidgets);
          });
          context
              .read<HyperlocalOrderhistoryBloc>()
              .add(ResetOrderHistoryEvent());
          errorLog('seven${orderList.length}');
        }
        if (state is ThirtyDaysFilterHyperlocalOrderState) {
          List<HyperlocalOrderDetailWidget> locWidgets = [];
          orderModels.clear();
          orderList.clear();
          for (var element in state.orderDetailsModels) {
            locWidgets.add(HyperlocalOrderDetailWidget(
                hyperlocalOrderDetailModel: element));
          }
          setState(() {
            sevenControllerSelected = false;
            thirtyControllerSelected = true;
            customControllerSelected = false;
            orderModels = state.orderDetailsModels;
            orderList = locWidgets;
          });
          warningLog('ThirtyDays ${orderList.length}');
          context
              .read<HyperlocalOrderhistoryBloc>()
              .add(ResetOrderHistoryEvent());
        }
        if (state is ThirtyDaysFilterHyperlocalOrderScrollState) {
          List<HyperlocalOrderDetailWidget> locWidgets = [];
          for (var element in state.orderDetailsModels) {
            locWidgets.add(
              HyperlocalOrderDetailWidget(hyperlocalOrderDetailModel: element),
            );
          }
          setState(() {
            orderModels.addAll(state.orderDetailsModels);
            orderList.addAll(locWidgets);
          });
          context
              .read<HyperlocalOrderhistoryBloc>()
              .add(ResetOrderHistoryEvent());
          errorLog('thirty${orderList.length}');
        }
        if (state is CustomDaysFilterHyperlocalOrderState) {
          List<HyperlocalOrderDetailWidget> locWidgets = [];
          orderList.clear();
          orderModels.clear();
          orderModels = state.orderDetailsModels;
          errorLog('CustomDaysFilterHyperlocalOrderState ${orderList.length}');
          for (var element in orderModels) {
            locWidgets.add(HyperlocalOrderDetailWidget(
                hyperlocalOrderDetailModel: element));
          }
          setState(() {
            sevenControllerSelected = false;
            thirtyControllerSelected = false;
            customControllerSelected = true;
            orderModels = state.orderDetailsModels;
            orderList = locWidgets;
          });
          warningLog('customNav ${orderList.length}');
          context
              .read<HyperlocalOrderhistoryBloc>()
              .add(ResetOrderHistoryEvent());
        }
        if (state is CustomScrollFilterHyperlocalState) {
          List<HyperlocalOrderDetailWidget> locWidgets = [];
          for (var element in state.orderDetailsModels) {
            locWidgets.add(
              HyperlocalOrderDetailWidget(hyperlocalOrderDetailModel: element),
            );
          }
          setState(() {
            orderModels.addAll(state.orderDetailsModels);
            orderList.addAll(locWidgets);
            if(orderList.isEmpty){
              _isEmpty = true;
            }
          });
          context
              .read<HyperlocalOrderhistoryBloc>()
              .add(ResetOrderHistoryEvent());
          errorLog('custom${orderList.length}');
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: _key,
          drawer: const CustomNavigationDrawer(),
          appBar: AppBar(
            backgroundColor: AppColors().brandDark,
            title:
                AutoSizeText("Santhe", style: FontStyleManager().kAppNameStyle),
            leading: IconButton(
              onPressed: () async {
               ge.Get.to(()=>HyperlocalShophomeView(
                    lat: profileController.customerDetails!.lat,
                    lng: profileController.customerDetails!.lng),
                transition: ge.Transition.leftToRight);
               // _key.currentState!.openDrawer();
              },
              splashRadius: 25.0,
              icon: const Icon(Icons.arrow_back),
            ),
            shadowColor: AppColors().appBarShadow,
            actions: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 4.5),
              //   child: IconButton(
              //     onPressed: () {
              //       if (Platform.isIOS) {
              //         Share.share(
              //           AppHelpers().appStoreLink,
              //         );
              //       } else {
              //         Share.share(
              //           AppHelpers().playStoreLink,
              //         );
              //       }
              //     },
              //     splashRadius: 25.0,
              //     icon: const Icon(
              //       Icons.share,
              //       color: Colors.white,
              //       size: 27.0,
              //     ),
              //   ),
              // ),
              GestureDetector(
                // onTap: () => Get.off(
                //   const OndcIntroView(),
                // ),
                onTap: () => ge.Get.off(HyperlocalShophomeView(
                    lat: profileController.customerDetails!.lat,
                    lng: profileController.customerDetails!.lng)),
                child: const Padding(
                  padding: EdgeInsets.only(right: 4.5),
                  child: Icon(Icons.home),
                ),
              )
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                controller: customControllerSelected == true
                    ? _customScrollController
                    : thirtyControllerSelected == true
                        ? _thirtyScrollController
                        : _sevenScrollController,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        'Below are the orders you have placed on Santhe',
                        style: TextStyle(
                            color: AppColors().brandDark,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(
                      thickness: 0.8,
                      color: Colors.grey,
                    ),
                    //! data selector
                    Container(
                      height: 130,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors().white100,
                        borderRadius:
                            BorderRadius.circular(customButtonBorderRadius),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 10.0),
                            child: SizedBox(
                              // width: 300,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // BlocProvider.of<OrderHistoryBloc>(context).add(SevenDaysFilterEvent());
                                      context
                                          .read<HyperlocalOrderhistoryBloc>()
                                          .add(
                                            SevenDaysFilterHyperLocalOrderEvent(
                                                nSeven: nSeven),
                                          );
                                      // sevenDayFilter(orderModels7: orderModels);
                                      setState(() {
                                        hint = "";
                                        selectedValue = "7days";
                                        nSeven = 0;
                                      });
                                    },
                                    child: SizedBox(
                                      width: 125,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 15,
                                            width: 15,
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                    width: 1.5,
                                                    color:
                                                        selectedValue == "7days"
                                                            ? AppColors()
                                                                .primaryOrange
                                                            : AppColors()
                                                                .grey100)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: CircleAvatar(
                                                  backgroundColor:
                                                      selectedValue == "7days"
                                                          ? AppColors()
                                                              .primaryOrange
                                                          : AppColors()
                                                              .white100),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              "Last 7 Days",
                                              style: selectedValue == "7days"
                                                  ? FontStyleManager()
                                                      .s14fw700Orange
                                                  : FontStyleManager()
                                                      .s14fw600Grey,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  ///30 Days
                                  InkWell(
                                    onTap: () {
                                      // thirtyDayFilter(
                                      //     orderModels30: orderModels);
                                      setState(() {
                                        selectedValue = "30days";
                                        hint = "";
                                        nThirty = 0;
                                      });
                                      context
                                          .read<HyperlocalOrderhistoryBloc>()
                                          .add(
                                            ThirtyDaysFilterHyperLocalOrderEvent(
                                                nthirty: nThirty),
                                          );
                                    },
                                    child: SizedBox(
                                      width: 125,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 15,
                                            width: 15,
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                    width: 1.5,
                                                    color: selectedValue ==
                                                            "30days"
                                                        ? AppColors()
                                                            .primaryOrange
                                                        : AppColors().grey100)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: CircleAvatar(
                                                  backgroundColor:
                                                      selectedValue == "30days"
                                                          ? AppColors()
                                                              .primaryOrange
                                                          : AppColors()
                                                              .white100),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              "Last 30 Days",
                                              style: selectedValue == "30days"
                                                  ? FontStyleManager()
                                                      .s14fw700Orange
                                                  : FontStyleManager()
                                                      .s14fw600Grey,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          ///Custom
                          SizedBox(
                            // width: 300,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20.0, top: 10),
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      selectedValue = "custom";
                                      selectedDates = '';
                                      nCustom = 0;
                                    });
                                    selectedDates =
                                        await showCalendarDatePicker2Dialog(
                                      context: context,
                                      config: config,
                                      dialogSize: const Size(325, 400),
                                      borderRadius: BorderRadius.circular(15),
                                      dialogBackgroundColor: Colors.white,
                                    );
                                    if (selectedDates != null) {
                                      context
                                          .read<HyperlocalOrderhistoryBloc>()
                                          .add(
                                            CustomDaysFilterHyperLocalOrderEvent(
                                                selectedDates: selectedDates,
                                                nCustom: nCustom),
                                          );
                                      // customDateFilter(
                                      //     valuesLoc: values,
                                      //     orderDetailsCustom: orderModels);
                                      datePickedController.text =
                                          _getValueText2(
                                        config.calendarType,
                                        selectedDates,
                                      );
                                      hint = _getValueText2(
                                        config.calendarType,
                                        selectedDates,
                                      );
                                    }
                                  },
                                  child: SizedBox(
                                    // width: 80,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 15,
                                          width: 15,
                                          margin: const EdgeInsets.only(
                                              right: 10, left: 0),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              border: Border.all(
                                                  width: 1.5,
                                                  color: selectedValue ==
                                                          "custom"
                                                      ? AppColors()
                                                          .primaryOrange
                                                      : AppColors().grey100)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    selectedValue == "custom"
                                                        ? AppColors()
                                                            .primaryOrange
                                                        : AppColors().white100),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            setState(() {
                                              selectedValue = "custom";
                                              selectedDates = '';
                                              nCustom = 0;
                                            });
                                            selectedDates =
                                                await showCalendarDatePicker2Dialog(
                                              context: context,
                                              config: config,
                                              dialogSize: const Size(325, 400),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              dialogBackgroundColor:
                                                  Colors.white,
                                            );
                                            if (selectedDates != null) {
                                              // customDateFilter(
                                              //     valuesLoc: values,
                                              //     orderDetailsCustom:
                                              //         orderModels);
                                              context
                                                  .read<
                                                      HyperlocalOrderhistoryBloc>()
                                                  .add(
                                                    CustomDaysFilterHyperLocalOrderEvent(
                                                        selectedDates:
                                                            selectedDates,
                                                        nCustom: nCustom),
                                                  );
                                              datePickedController.text =
                                                  _getValueText2(
                                                config.calendarType,
                                                selectedDates,
                                              );
                                              hint = _getValueText2(
                                                config.calendarType,
                                                selectedDates,
                                              );
                                            }
                                          },
                                          child: Text("Custom",
                                              style: selectedValue == "custom"
                                                  ? FontStyleManager()
                                                      .s14fw700Orange
                                                  : FontStyleManager()
                                                      .s14fw700Grey),
                                        ),
                                        const Spacer()
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, bottom: 10, right: 30),
                            child: SizedBox(
                              height: 40,
                              // width: 250,
                              child: TextField(
                                onTap: () async {
                                  setState(() {
                                    selectedDates = '';
                                    nCustom = 0;
                                  });
                                  selectedDates =
                                      await showCalendarDatePicker2Dialog(
                                    context: context,
                                    config: config,
                                    dialogSize: const Size(325, 400),
                                    borderRadius: BorderRadius.circular(15),
                                    dialogBackgroundColor: Colors.white,
                                  );

                                  if (selectedDates != null) {
                                    // BlocProvider.of<OrderHistoryBloc>(context).add(CustomDaysFilterEvent(
                                    //     selectedDates: values));
                                    context
                                        .read<HyperlocalOrderhistoryBloc>()
                                        .add(
                                          CustomDaysFilterHyperLocalOrderEvent(
                                              selectedDates: selectedDates,
                                              nCustom: nCustom),
                                        );

                                    setState(() {
                                      selectedValue = "custom";

                                      datePickedController.text =
                                          _getValueText2(
                                        config.calendarType,
                                        selectedDates,
                                      );
                                      hint = _getValueText2(
                                        config.calendarType,
                                        selectedDates,
                                      );
                                    });
                                  }
                                },
                                controller: datePickedController,
                                readOnly: true,
                                decoration: InputDecoration(
                                    hintText: hint,
                                    hintStyle:
                                        FontStyleManager().s14fw700Orange,
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, bottom: 10),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kTextFieldCircularBorderRadius),
                                      borderSide: BorderSide(
                                        color: AppColors().primaryOrange,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kTextFieldCircularBorderRadius),
                                      borderSide:
                                          BorderSide(color: AppColors().grey60),
                                    ),
                                    suffixIcon: Icon(
                                      Icons.calendar_today,
                                      color: selectedValue == "custom"
                                          ? AppColors().primaryOrange
                                          : AppColors().grey60,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //! Date Selector ends
                    _isEmpty
                        ? Text(
                            'No Orders found',
                            style: TextStyle(
                              color: AppColors().brandDark,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    state is ThirtyDaysLoadingState ||
                        state is CustomDaysLoadingState ||
                        state is SevenDaysLoadingState
                        ?

                    const SizedBox() :
                    // Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           const Center(
                    //             child: CircularProgressIndicator(),
                    //           ),
                    //           Text(
                    //             "Loading",
                    //             style: TextStyle(color: AppColors().brandDark),
                    //           )
                    //         ],
                    //       )
                        // : state is CustomDaysLoadingState
                        //     ? Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           const Center(
                        //             child: CircularProgressIndicator(),
                        //           ),
                        //           Text(
                        //             "Loading",
                        //             style:
                        //                 TextStyle(color: AppColors().brandDark),
                        //           )
                        //         ],
                        //       )
                        //     : state is SevenDaysLoadingState
                        //         ? Column(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               const Center(
                        //                 child: CircularProgressIndicator(),
                        //               ),
                        //               Text(
                        //                 "Loading",
                        //                 style: TextStyle(
                        //                     color: AppColors().brandDark),
                        //               )
                        //             ],
                        //           )
                    orderList.isEmpty ?
                    Text(
                      'No Orders found',
                      style: TextStyle(
                        color: AppColors().brandDark,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                                : Column(
                                    children: orderList,
                                  ),
                    // state is SevenDaysFilterHyperlocalLoadingSrollState
                    //     ? const Center(
                    //         child: CircularProgressIndicator(),
                    //       )
                    //     : state is ThirtyDaysFilterHyperlocalOrderScrollLoadingState
                    //         ? const Center(
                    //             child: CircularProgressIndicator(),
                    //           )
                    //         : state is CustomScrollFilterHyperlocalLoadingState
                    //             ? const Center(
                    //                 child: CircularProgressIndicator(),
                    //               )
                    //             : const SizedBox(),
                  ],
                ),
              ),
              _isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                        Text(
                          "Loading",
                          style: TextStyle(color: AppColors().brandDark),
                        )
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
