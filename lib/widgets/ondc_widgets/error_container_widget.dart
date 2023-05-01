import 'package:flutter/material.dart';
import 'package:santhe/core/app_colors.dart';

class ErrorContainerWidget extends StatelessWidget {
  final String message;
  const ErrorContainerWidget({Key? key,
    required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors().grey60),
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        child:  Center(
          child: Text(
            message,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
