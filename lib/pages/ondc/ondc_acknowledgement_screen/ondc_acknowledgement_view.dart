import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'ondc_acknowledgement_screen_mobile.dart';





class ONDCAcknowledgementView extends StatelessWidget {
  final String message;
  final String title;
  final String orderNumber;
  final Function() onTap;

  const ONDCAcknowledgementView({Key? key, required this.orderNumber,
    required this.message, required this.title,
    required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Builder(builder: (context) {
        return ScreenTypeLayout(
          mobile:  ONDCAcknowledgementScreenMobile(
            title: title,
            message: message,
            orderNumber: orderNumber,
            onTap: (){
              onTap();
            },
          ),
          // desktop: _OndcProductGlobalDesktop(),
          // tablet: _OndcProductGlobalTablet(),
        );
      });
  }
}
