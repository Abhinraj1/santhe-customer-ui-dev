import 'package:flutter/material.dart';

import '../../core/app_colors.dart';



Widget homeIconButton(){
  return
    IconButton(
        onPressed: (){
          ///Navigate to Home
        },
        icon: Icon(Icons.home_filled,
          size: 35,
          color: AppColors().white100,));
}