import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/manager/font_manager.dart';
import '../../../../constants.dart';


class SelectDateFilter extends StatelessWidget {
  const SelectDateFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<String> groupValue = ["7days","30days","custom"];

    String currentValue = groupValue[0];


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
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 30),
      decoration: BoxDecoration(
        color: AppColors().white100,
        borderRadius: BorderRadius.circular(customButtonBorderRadius),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 280,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 110,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LimitedBox(
                        maxWidth: 20,
                        child: Radio(
                            fillColor: MaterialStateProperty.resolveWith((states) {
                              if(currentValue == groupValue[0]){
                                return AppColors().primaryOrange;
                              }
                              return AppColors().grey80;
                            }),

                            activeColor: Colors.red,
                            value: groupValue[0],
                            groupValue: currentValue ,
                            onChanged: (value){
                              currentValue = value.toString();
                            }
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          currentValue = groupValue[0];
                        },
                        child: Text("Last 7 Days",
                            style: currentValue == groupValue[0] ?
                            FontStyleManager().s14fw700Orange:
                            FontStyleManager().s14fw700Grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LimitedBox(
                        maxWidth: 20,
                        child: Radio(
                            fillColor: MaterialStateProperty.resolveWith((states) {
                              if(currentValue == groupValue[1]){
                                return AppColors().primaryOrange;
                              }
                              return AppColors().grey80;
                            }),

                            activeColor: Colors.red,
                            value: groupValue[1],
                            groupValue: currentValue ,
                            onChanged: (value){
                              currentValue = value.toString();
                            }
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          currentValue = groupValue[1];
                        },
                        child: Text("Last 30 Days",
                            style: currentValue == groupValue[1] ?
                            FontStyleManager().s14fw700Orange:
                            FontStyleManager().s14fw700Grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: SizedBox(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LimitedBox(
                      maxWidth: 20,
                      maxHeight: 30,
                      child: Radio(
                          fillColor: MaterialStateProperty.resolveWith((states) {
                            if(currentValue == groupValue[2]){
                              return AppColors().primaryOrange;
                            }
                            return AppColors().grey80;
                          }),

                          activeColor: Colors.red,
                          value: groupValue[2],
                          groupValue: currentValue ,
                          onChanged: (value){
                            currentValue = value.toString();
                          }
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        currentValue = groupValue[2];
                      },
                      child: Text("Custom",
                          style: currentValue == groupValue[2] ?
                          FontStyleManager().s14fw700Orange:
                          FontStyleManager().s14fw700Grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                onTap: () async {
                  currentValue = groupValue[2];
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
                },
                controller: datePickedController,
                style: FontStyleManager().s14fw700Grey,
                readOnly: true,
                decoration: InputDecoration(
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
                      color: AppColors().grey60,)
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
