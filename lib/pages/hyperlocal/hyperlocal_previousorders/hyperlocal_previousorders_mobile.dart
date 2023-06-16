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
  bool _isLoading = false;
  String selectedValue = "";
  String hint = "";
  bool _isEmpty = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    warningLog('called on rebuild');

    context
        .read<HyperlocalOrderhistoryBloc>()
        .add(GetHyperlocalOrderHistoryEvent());
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

  sevenDayFilter({required List<HyperlocalOrderDetailModel> orderModels7}) {
    DateTime today = DateTime.now();
    DateTime startingDate = today.subtract(const Duration(days: 8));
    List<HyperlocalOrderDetailModel> filteredModels = [];
    List<HyperlocalOrderDetailWidget> filteredWidget = [];

    for (var element in orderModels7) {
      warningLog(
          'Order Models ${orderModels7.length} Starting Date $startingDate and parse  ${DateTime.parse(element.createdAt.toString())} condition check ${DateTime.parse(element.createdAt.toString()).isAfter(startingDate)}');
      if (DateTime.parse(element.createdAt.toString()).isAfter(startingDate)) {
        filteredModels.add(element);
      }
    }
    for (var element in filteredModels) {
      filteredWidget.add(
          HyperlocalOrderDetailWidget(hyperlocalOrderDetailModel: element));
    }
    warningLog('$filteredWidget');
    setState(() {
      orderList = filteredWidget;
    });
    if (orderList.isEmpty) {
      setState(() {
        _isEmpty = true;
      });
    } else {
      setState(() {
        _isEmpty = false;
      });
    }
  }

  thirtyDayFilter({required List<HyperlocalOrderDetailModel> orderModels30}) {
    DateTime today = DateTime.now();
    DateTime startingDate = today.subtract(const Duration(days: 31));
    List<HyperlocalOrderDetailModel> filteredModels = [];
    List<HyperlocalOrderDetailWidget> filteredWidget = [];
    for (var element in orderModels30) {
      if (DateTime.parse(element.createdAt.toString()).isAfter(startingDate)) {
        filteredModels.add(element);
      }
    }
    for (var element in filteredModels) {
      filteredWidget.add(
          HyperlocalOrderDetailWidget(hyperlocalOrderDetailModel: element));
    }
    warningLog('Order Models ${orderModels30.length}, Thirty $filteredWidget');
    setState(() {
      orderList = filteredWidget;
    });
    if (orderList.isEmpty) {
      setState(() {
        _isEmpty = true;
      });
    } else {
      _isEmpty = false;
    }
  }

  customDateFilter(
      {required List<DateTime?>? valuesLoc,
      required List<HyperlocalOrderDetailModel> orderDetailsCustom}) {
    List<HyperlocalOrderDetailModel> filteredModels = [];
    List<HyperlocalOrderDetailWidget> filteredWidget = [];
    for (var element in orderDetailsCustom) {
      if (DateTime.parse(element.createdAt.toString())
                  .isAfter((valuesLoc!.first)!) ==
              true &&
          DateTime.parse(element.createdAt.toString())
                  .isBefore((valuesLoc.last)!.add(const Duration(days: 1))) ==
              true) {
        warningLog(
            'Date vals${valuesLoc.first} and last ${valuesLoc.last} Custom ${DateTime.parse(element.createdAt.toString())} condition check ${DateTime.parse(element.createdAt.toString()).isAfter((valuesLoc.first)!)} and before time stamp ${DateTime.parse(element.createdAt.toString()).isBefore((valuesLoc.last)!.subtract(const Duration(days: 1)))}');
        filteredModels.add(element);
        warningLog(
            'element added ${element.createdAt}} to models ${filteredModels.length}');
      }
    }
    for (var element in filteredModels) {
      filteredWidget.add(
          HyperlocalOrderDetailWidget(hyperlocalOrderDetailModel: element));
    }
    warningLog(
        'Order Models ${orderDetailsCustom.length} Custom${filteredWidget}');
    setState(() {
      orderList = filteredWidget;
    });
    if (orderList.isEmpty) {
      setState(() {
        _isEmpty = true;
      });
    } else {
      setState(() {
        _isEmpty = false;
      });
    }
    warningLog('Custom Widget$orderList');
  }

  @override
  Widget build(BuildContext context) {
    warningLog(
        'length of order model regardless of filter ${orderModels.length}');
    final ProfileController profileController = Get.find<ProfileController>();

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
        if (state is GetHyperlocalOrderHistorySuccessState) {
          List<HyperlocalOrderDetailModel> locModels = [];
          List<HyperlocalOrderDetailWidget> locWidgets = [];
          locModels = state.orderDetail;
          for (var element in locModels) {
            locWidgets.add(HyperlocalOrderDetailWidget(
                hyperlocalOrderDetailModel: element));
          }
          setState(() {
            orderModels = locModels;
            orderList = locWidgets;
            _isLoading = false;
            selectedValue = "7days";
          });
          warningLog('OrderList $orderList');
          if (orderList.isEmpty) {
            setState(() {
              _isEmpty = true;
            });
          } else {
            setState(() {
              sevenDayFilter(orderModels7: orderModels);
            });
          }

          // context.read<HyperlocalOrderhistoryBloc>().add(
          //     SevenDaysFilterHyperLocalOrderEvent(orderModels: orderModels));
        }
        if (state is SevenDaysFilterHyperlocalOrderState) {
          List<HyperlocalOrderDetailWidget> locWidgets = [];
          for (var element in state.orderDetailsModels) {
            locWidgets.add(HyperlocalOrderDetailWidget(
                hyperlocalOrderDetailModel: element));
          }
          setState(() {
            orderList = locWidgets;
          });
          warningLog('Seven days${orderList.length}');
          context
              .read<HyperlocalOrderhistoryBloc>()
              .add(ResetOrderHistoryEvent());
        }
        if (state is ThirtyDaysFilterHyperlocalOrderState) {
          List<HyperlocalOrderDetailWidget> locWidgets = [];
          for (var element in state.orderDetailsModels) {
            locWidgets.add(HyperlocalOrderDetailWidget(
                hyperlocalOrderDetailModel: element));
          }
          setState(() {
            orderList = locWidgets;
          });
          warningLog('ThirtyDays ${orderList.length}');
          context
              .read<HyperlocalOrderhistoryBloc>()
              .add(ResetOrderHistoryEvent());
        }
        if (state is CustomDaysFilterHyperlocalOrderState) {
          List<HyperlocalOrderDetailWidget> locWidgets = [];
          for (var element in state.orderDetailsModels) {
            locWidgets.add(HyperlocalOrderDetailWidget(
                hyperlocalOrderDetailModel: element));
          }
          setState(() {
            orderList = locWidgets;
          });
          warningLog('customNav ${orderList.length}');
          context
              .read<HyperlocalOrderhistoryBloc>()
              .add(ResetOrderHistoryEvent());
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
                _key.currentState!.openDrawer();
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
                onTap: () => Get.off(HyperlocalShophomeView(
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
                                      // context
                                      //     .read<HyperlocalOrderhistoryBloc>()
                                      //     .add(
                                      //       SevenDaysFilterHyperLocalOrderEvent(
                                      //           orderModels: orderModels),
                                      //     );
                                      sevenDayFilter(orderModels7: orderModels);
                                      setState(() {
                                        hint = "";
                                        selectedValue = "7days";
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
                                      thirtyDayFilter(
                                          orderModels30: orderModels);
                                      setState(() {
                                        // context
                                        //     .read<HyperlocalOrderhistoryBloc>()
                                        //     .add(
                                        //       ThirtyDaysFilterHyperLocalOrderEvent(
                                        //           orderModels: orderModels),
                                        //     );
                                        selectedValue = "30days";
                                        hint = "";
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
                                    });
                                    final values =
                                        await showCalendarDatePicker2Dialog(
                                      context: context,
                                      config: config,
                                      dialogSize: const Size(325, 400),
                                      borderRadius: BorderRadius.circular(15),
                                      dialogBackgroundColor: Colors.white,
                                    );
                                    if (values != null) {
                                      customDateFilter(
                                          valuesLoc: values,
                                          orderDetailsCustom: orderModels);
                                      datePickedController.text =
                                          _getValueText2(
                                        config.calendarType,
                                        values,
                                      );
                                      hint = _getValueText2(
                                        config.calendarType,
                                        values,
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
                                            });
                                            final values =
                                                await showCalendarDatePicker2Dialog(
                                              context: context,
                                              config: config,
                                              dialogSize: const Size(325, 400),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              dialogBackgroundColor:
                                                  Colors.white,
                                            );
                                            if (values != null) {
                                              customDateFilter(
                                                  valuesLoc: values,
                                                  orderDetailsCustom:
                                                      orderModels);
                                              datePickedController.text =
                                                  _getValueText2(
                                                config.calendarType,
                                                values,
                                              );
                                              hint = _getValueText2(
                                                config.calendarType,
                                                values,
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
                                  final values =
                                      await showCalendarDatePicker2Dialog(
                                    context: context,
                                    config: config,
                                    dialogSize: const Size(325, 400),
                                    borderRadius: BorderRadius.circular(15),
                                    dialogBackgroundColor: Colors.white,
                                  );

                                  if (values != null) {
                                    // BlocProvider.of<OrderHistoryBloc>(context).add(CustomDaysFilterEvent(
                                    //     selectedDates: values));

                                    setState(() {
                                      selectedValue = "custom";
                                      customDateFilter(
                                          valuesLoc: values,
                                          orderDetailsCustom: orderModels);
                                      datePickedController.text =
                                          _getValueText2(
                                        config.calendarType,
                                        values,
                                      );
                                      hint = _getValueText2(
                                        config.calendarType,
                                        values,
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
                    ...orderList,
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
                  : const SizedBox()
            ],
          ),
        );
      },
    );
  }
}
