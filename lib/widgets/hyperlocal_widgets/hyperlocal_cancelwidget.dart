// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:santhe/core/app_colors.dart';
import 'package:santhe/manager/font_manager.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_cancel.dart';

class HyperlocalCancelWidget extends StatefulWidget {
  final HyperlocalCancelModel hyperlocalCancelModel;
  const HyperlocalCancelWidget({
    Key? key,
    required this.hyperlocalCancelModel,
  }) : super(key: key);

  @override
  State<HyperlocalCancelWidget> createState() => _HyperlocalCancelWidgetState();
}

class _HyperlocalCancelWidgetState extends State<HyperlocalCancelWidget> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: InkWell(
          onTap: () {
            if (isSelected == true) {
              setState(() {
                isSelected = false;
              });
            } else {
              setState(() {
                isSelected = true;
              });
            }
          },
          child: Row(
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
                        color: isSelected
                            ? AppColors().primaryOrange
                            : AppColors().grey100)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                      backgroundColor: isSelected
                          ? AppColors().primaryOrange
                          : AppColors().white100),
                ),
              ),
              SizedBox(
                width: 280,
                child: Text(
                  '${widget.hyperlocalCancelModel.reason}',
                  maxLines: 3,
                  style: isSelected
                      ? FontStyleManager().s16fw600Orange
                      : FontStyleManager().s16fw500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
