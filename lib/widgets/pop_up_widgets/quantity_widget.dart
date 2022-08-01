import 'package:flutter/material.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:resize/resize.dart';

class QuantityWidget extends StatelessWidget {
  final TextEditingController qtyController;

  const QuantityWidget({required this.qtyController, Key? key})
      : super(key: key);

  String removeDecimalZeroFormat(double n) {
    final data = n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
    return AppHelpers.replaceDecimalZero(data);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final length = screenSize.width / 3;

    return Container(
      height: 60.sp,
      width: length,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: kTextFieldGrey,
          width: 1.0,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(kTextFieldCircularBorderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (qtyController.text.isEmpty) {
                qtyController.text = 0.toString();
              }
              double i = double.parse(qtyController.text);
              if (i > 0) {
                i--;
                qtyController.text = removeDecimalZeroFormat(i);
              }
            },
            child: Container(
              height: 60.sp,
              width: length / 3 - 10,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors().grey60,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(kTextFieldCircularBorderRadius),
                  bottomLeft: Radius.circular(kTextFieldCircularBorderRadius),
                ),
              ),
              child: Icon(
                Icons.remove,
                color: AppColors().white100,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 60.sp,
              alignment: Alignment.center,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  } else if (double.parse(value) == 0 ||
                      double.parse(value).isNegative ||
                      double.parse(value).isInfinite) {
                    return 'Enter a valid quantity';
                  }
                  return null;
                },
                controller: qtyController,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.center,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                maxLength: 5,
                textAlignVertical: TextAlignVertical.center,
                inputFormatters: [DecimalTextInputFormatter(decimalRange: 1)],
                style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0),
                onSaved: (value) {
                  qtyController.text = value!;
                },
                decoration: const InputDecoration(
                  hintText: '0',
                  counterText: '',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (qtyController.text.isEmpty) {
                qtyController.text = 0.toString();
              }

              double i = double.parse(qtyController.text);
              i++;
              qtyController.text = removeDecimalZeroFormat(i);
            },
            child: Container(
              height: 60.sp,
              width: length / 3 - 10,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors().grey60,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(kTextFieldCircularBorderRadius),
                  bottomRight: Radius.circular(kTextFieldCircularBorderRadius),
                ),
              ),
              child: Icon(
                Icons.add,
                color: AppColors().white100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
