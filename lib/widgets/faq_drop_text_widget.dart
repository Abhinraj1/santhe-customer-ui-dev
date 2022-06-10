import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:santhe/widgets/animated_clip_r_rect_widget.dart';

class TextDropWidget extends StatefulWidget {
  final String question, answer;

  const TextDropWidget({required this.question, required this.answer, Key? key})
      : super(key: key);

  @override
  _TextDropWidgetState createState() => _TextDropWidgetState();
}

class _TextDropWidgetState extends State<TextDropWidget> {
  //Colors
  Color qClr = Colors.grey.shade700;
  Color bgClr = Colors.grey.shade200.withOpacity(0.65);
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    //getting constructor values
    final String question = widget.question;
    final String answer = widget.answer;
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Padding(
      padding: const EdgeInsets.only(
        right: 15.0,
        left: 15.0,
        bottom: 5.0,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded ? qClr = Colors.grey.shade600 : qClr = Colors.white;
                isExpanded
                    ? bgClr = Colors.grey.shade200.withOpacity(0.65)
                    : bgClr = Colors.orange;
              });
              isExpanded = !isExpanded;
            },
            child: Container(
              decoration: BoxDecoration(
                color: bgClr,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          question,
                          style: TextStyle(
                            color: qClr,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    isExpanded
                        ? const Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.grey.shade600,
                          ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5.0,
              bottom: 10.0,
              left: 10.0,
              right: 10.0,
            ),
            child: AnimatedClipRect(
                open: isExpanded,
                horizontalAnimation: false,
                verticalAnimation: true,
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 450),
                curve: Curves.ease,
                reverseCurve: Curves.ease,
                reverseDuration: const Duration(milliseconds: 450),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 5.0,
                    bottom: 10.0,
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Text(
                    answer,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16.sp,
                      height: 1.5,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
