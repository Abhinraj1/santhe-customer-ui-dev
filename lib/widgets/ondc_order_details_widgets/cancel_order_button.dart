import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../manager/font_manager.dart';

class CancelOrderButton extends StatelessWidget {
  final Function() onTap;
  const CancelOrderButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return     Column(
      children: [
        Text("OR",
          style: FontStyleManager().s12fw600Grey60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5,bottom: 20,left: 20,right: 20),
          child: MaterialButton(
            color: Colors.white,
            elevation: 2,
            onPressed: (){
              onTap();
            },
            height: 40,
            shape: RoundedRectangleBorder(
              borderRadius:BorderRadius.circular(customButtonBorderRadius),
            ),
            minWidth: 250,
            child: Center(
              child: Text("CANCEL ORDER",
                style:
                FontStyleManager().s14fw700Red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

