// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:santhe/core/app_colors.dart';
import 'package:santhe/models/ondc/preview_ondc_cart_model.dart';

class PreviewWidgetOndcItem extends StatelessWidget {
  final PreviewWidgetModel previewWidgetModel;
  const PreviewWidgetOndcItem({
    Key? key,
    required this.previewWidgetModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '${previewWidgetModel.title}',
                style: TextStyle(
                  color: AppColors().grey100,
                  fontSize: 13,
                  overflow: TextOverflow.values.first,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${previewWidgetModel.quantity}',
                    style: TextStyle(
                      color: AppColors().grey100,
                      overflow: TextOverflow.values.first,
                    ),
                  ),
                  Text(
                    '₹ ${previewWidgetModel.price}',
                    style: TextStyle(
                      color: AppColors().grey100,
                      overflow: TextOverflow.values.first,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
