// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/loggers.dart';

import 'package:santhe/models/ondc/shop_model.dart';
import 'package:santhe/pages/ondc/ondc_shop_details/ondc_shop_details_view.dart';
import 'package:santhe/widgets/ondc_widgets/shop_images_intro.dart';

class OndcShopWidget extends StatefulWidget {
  final ShopModel shopModel;
  const OndcShopWidget({
    Key? key,
    required this.shopModel,
  }) : super(key: key);

  @override
  State<OndcShopWidget> createState() => _OndcShopWidgetState();
}

class _OndcShopWidgetState extends State<OndcShopWidget> with LogMixin {
  List<String> images = [];
  List<ShopImageIntro> networkImages = [];
  getImagesOfShops() {
    warningLog('${widget.shopModel.items.length}');
    for (var i = 0; i < widget.shopModel.items.length; i++) {
      final string = widget.shopModel.items[i]['symbol'];
      images.add(string);
    }
    for (var element in images) {
      networkImages.add(
        ShopImageIntro(image: element),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getImagesOfShops();
  }

  @override
  Widget build(BuildContext context) {
    // warningLog(
    //     '${widget.shopModel.symbol.toString().length}, ${widget.shopModel.address}, ${widget.shopModel}');
    return GestureDetector(
      onTap: () {
        Get.to(
          OndcShopDetailsView(shopModel: widget.shopModel),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: 120,
          width: 355,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.shopModel.name.toString(),
                      style: TextStyle(
                        color: AppColors().brandDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Text('${widget.shopModel.address}'),
                  // Text('${widget.shopModel.ondc_store_id}')
                  // Text(
                  //     '${widget.shopModel.distance.toString().substring(0, 3)} kms'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${widget.shopModel.item_count} items',
                      style: TextStyle(
                        color: AppColors().brandDark,
                      ),
                    ),
                  )
                ],
              ),
              widget.shopModel.items.isEmpty
                  ? Expanded(
                      child: Text(
                        widget.shopModel.description,
                        style: TextStyle(
                            color: AppColors().brandDark,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: networkImages,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
