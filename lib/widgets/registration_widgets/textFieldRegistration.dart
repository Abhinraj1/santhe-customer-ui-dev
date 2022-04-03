import 'package:flutter/material.dart';

import '../../constants.dart';

class RegisterationTextFeild extends StatelessWidget {
  RegisterationTextFeild(
      {required this.controller,
      required this.icon,
      required this.hintText,
      required this.labelText,
      required this.readOnly});
  String labelText;
  String hintText;
  IconData icon;
  TextEditingController controller;
  bool readOnly;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              labelText,
              style: Constant.mediumOrangeText16,
            ),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: Constant.bgColor,
                  child: Icon(
                    icon,
                    color: Constant.white,
                    size: 25,
                  ),
                ),
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                  color: Color(0xffD1D1D1),
                  fontSize: 16,
                  fontStyle: FontStyle.italic),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(kTextFieldCircularBorderRadius),
                borderSide: const BorderSide(width: 1.0, color: kTextFieldGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(kTextFieldCircularBorderRadius),
                borderSide: const BorderSide(width: 1.0, color: kTextFieldGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
