import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:santhe/manager/font_manager.dart';

import '../../../../../core/app_colors.dart';
import '../../../../../manager/imageManager.dart';

Widget addressColumn(
    {required String title,
    required String addressType,
    required String address,
    bool? hasEditButton,
    Function()? onTap}) {
  return SizedBox(
    width: 360,
    child: Column(
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(color: AppColors().brandDark),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30.0, top: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              addressType,
              style: TextStyle(color: AppColors().brandDark),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 320,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LimitedBox(
                    maxWidth: 275,
                    child: Text(
                      address,
                      style: FontStyleManager().s12fw400Grey,
                    ),
                  ),
                  hasEditButton ?? false
                      ? InkWell(
                          onTap: () {
                            if (hasEditButton ?? false) {
                              onTap!();
                            }
                          },
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: AppColors().primaryOrange,
                              child: Icon(
                                Icons.edit,
                                color: AppColors().white100,
                                size: 14,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(
                          width: 15,
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
