// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/loggers.dart';

import 'package:santhe/models/ondc/product_ondc.dart';
import 'package:santhe/pages/ondc/product_description_ondc/product_description_ondc_view.dart';

class OndcProductWidget extends StatefulWidget {
  final ProductOndcModel productOndcModel;
  const OndcProductWidget({
    Key? key,
    required this.productOndcModel,
  }) : super(key: key);

  @override
  State<OndcProductWidget> createState() => _OndcProductWidgetState();
}

class _OndcProductWidgetState extends State<OndcProductWidget> with LogMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ProductDescriptionOndcView(
              productOndcModel: widget.productOndcModel),
        );
      },
      child: Stack(
        children: [
          Container(
            width: 160,
            height: 190,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 1),
                  spreadRadius: 1,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Column(
              children: [
                widget.productOndcModel.symbol == null
                    ? Expanded(child: Image.asset('assets/cart.png'))
                    : Expanded(
                        child: CachedNetworkImage(
                          imageUrl: widget.productOndcModel.symbol,
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/cart.png'),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.productOndcModel.name,
                      style: const TextStyle(
                          color: Colors.black,
                          overflow: TextOverflow.fade,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.productOndcModel.value.toString(),
                    style: TextStyle(
                      color: AppColors().brandDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 145,
            child: Container(
              width: 160,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors().brandDark,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
              ),
              child: const Center(
                child: Text(
                  'Add To Cart',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
