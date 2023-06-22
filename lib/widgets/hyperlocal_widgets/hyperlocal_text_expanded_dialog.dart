import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../manager/font_manager.dart';



AlertDialog textExpandFunction({required String text}){

  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(
        15)),
    actionsOverflowAlignment: OverflowBarAlignment.center,
    content: TextExpandContent(text: text),
    scrollable: true,

  );
}

class TextExpandContent extends StatelessWidget {
  final String text;
  const TextExpandContent({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return
      SizedBox(
        width: 320,
        height: 350,
        child:Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0,horizontal: 10),
          child: Text(text,
              style: FontStyleManager().s14fw700Grey,
              textAlign: TextAlign.center),
        ),
      );
  }
}
