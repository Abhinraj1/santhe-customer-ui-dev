import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/ondc/ondc_single_order_details_bloc/ondc_single_order_details_bloc.dart';
import 'package:santhe/manager/font_manager.dart';
import '../../../../constants.dart';


class SelectDateFilter extends StatefulWidget {
  const SelectDateFilter({Key? key}) : super(key: key);

  @override
  State<SelectDateFilter> createState() => _SelectDateFilterState();
}

class _SelectDateFilterState extends State<SelectDateFilter> {

  String selectedValue = "";
  String hint = "";
  @override
  Widget build(BuildContext context) {





   // bool isSelected = selectedValue == groupValue[0] ? true : false;


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
                    Padding(
                      padding: const EdgeInsets.only(top: 27.5),
                      child: Container(
                        height: 4,
                        width: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: isSelected == true
                              ? Colors.white
                              : Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return dayWidget;
        });

    return Container(
      height: 130,
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 30),
      decoration: BoxDecoration(
        color: AppColors().white100,
        borderRadius: BorderRadius.circular(customButtonBorderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:20 ,top: 10.0),
            child: SizedBox(
              width: 300,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      BlocProvider.of<OrderHistoryBloc>(context).add(SevenDaysFilterEvent());
                      setState(() {
                        hint = "";
                        selectedValue = "7days";
                      });
                    },
                    child: SizedBox(
                      width: 125,
                      child:
                      Row(
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
                                    color: selectedValue == "7days"
                                        ? AppColors().primaryOrange
                                        : AppColors().grey100)),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                  backgroundColor: selectedValue == "7days"
                                      ? AppColors().primaryOrange
                                      : AppColors().white100),
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Text(
                              "Last 7 Days",
                              style: selectedValue == "7days" ?
                              FontStyleManager().s14fw700Orange :
                              FontStyleManager().s14fw600Grey
                              ,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  ///30 Days
                  InkWell(
                    onTap: (){
                      setState(() {
                        BlocProvider.of<OrderHistoryBloc>(context).add(ThirtyDaysFilterEvent());
                        selectedValue = "30days";
                        hint = "";
                      });
                    },
                    child: SizedBox(
                      width: 125,
                      child:
                      Row(
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
                                    color: selectedValue == "30days"
                                        ? AppColors().primaryOrange
                                        : AppColors().grey100)),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                  backgroundColor: selectedValue == "30days"
                                      ? AppColors().primaryOrange
                                      : AppColors().white100),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              "Last 30 Days",
                              style: selectedValue == "30days" ?
                              FontStyleManager().s14fw700Orange :
                              FontStyleManager().s14fw600Grey
                              ,
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
            width: 300,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0,top: 10),

                child: InkWell(
                  onTap: ()async {
                    setState(() {
                      selectedValue = "custom";
                    });
                    final values = await showCalendarDatePicker2Dialog(
                      context: context,
                      config: config,
                      dialogSize: const Size(325, 400),
                      borderRadius: BorderRadius.circular(15),
                      dialogBackgroundColor: Colors.white,
                    );

                    if (values != null) {

                      BlocProvider.of<OrderHistoryBloc>(context).add(CustomDaysFilterEvent(
                          selectedDates: values));

                      datePickedController.text = _getValueText(
                        config.calendarType,
                        values,
                      );



                    }
                  },
                  child: SizedBox(
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  color: selectedValue == "custom"
                                      ? AppColors().primaryOrange
                                      : AppColors().grey100)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircleAvatar(
                                backgroundColor: selectedValue == "custom"
                                    ? AppColors().primaryOrange
                                    : AppColors().white100),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              selectedValue = "custom";
                            });
                            final values = await showCalendarDatePicker2Dialog(
                              context: context,
                              config: config,
                              dialogSize: const Size(325, 400),
                              borderRadius: BorderRadius.circular(15),
                              dialogBackgroundColor: Colors.white,
                            );
                            if (values != null) {

                              datePickedController.text = _getValueText(
                                config.calendarType,
                                values,
                              );
                            }
                          }

                          ,
                          child: Text("Custom",
                              style: selectedValue == "custom" ?
                              FontStyleManager().s14fw700Orange:
                              FontStyleManager().s14fw700Grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0,bottom: 10),
            child: SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                onTap: () async {
                  final values = await showCalendarDatePicker2Dialog(
                    context: context,
                    config: config,
                    dialogSize: const Size(325, 400),
                    borderRadius: BorderRadius.circular(15),
                    dialogBackgroundColor: Colors.white,
                  );

                  if (values != null) {

                    BlocProvider.of<OrderHistoryBloc>(context).add(CustomDaysFilterEvent(
                        selectedDates: values));

                    setState(() {
                      selectedValue = "custom";
                      datePickedController.text = _getValueText(
                        config.calendarType,
                        values,
                      );
                      hint = _getValueText(
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
                    hintStyle: FontStyleManager().s14fw700Orange,
                    contentPadding: const EdgeInsets.only(left: 20,bottom: 10),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kTextFieldCircularBorderRadius),
                      borderSide: BorderSide(
                        color: AppColors().primaryOrange,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kTextFieldCircularBorderRadius),
                      borderSide: BorderSide(
                          color: AppColors().grey60
                      ),
                    ),
                    suffixIcon: Icon(Icons.calendar_today,
                      color:  selectedValue == "custom"
                          ? AppColors().primaryOrange
                          : AppColors().grey60,)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
    ) {
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
