// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/loggers.dart';

import 'package:santhe/models/ondc/shop_model.dart';
import 'package:santhe/pages/ondc/ondc_shop_details/ondc_shop_details_view.dart';
import 'package:santhe/widgets/ondc_widgets/shop_images_intro.dart';

import '../../core/cubits/customer_contact_cubit/customer_contact_cubit.dart';

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
  double distanceD = 0;
  getImagesOfShops() {
    warningLog('${widget.shopModel.items.length}');
    for (var i = 0; i < widget.shopModel.items.length - 1; i++) {
      final string = widget.shopModel.items[i]['symbol'];
      images.add(string);
    }
    for (var element in images) {
      networkImages.add(
        ShopImageIntro(image: element),
      );
    }
  }

  getDistance() {
    if (widget.shopModel.distance != null) {
      double d = widget.shopModel.distance;
      String? distance = d.toStringAsFixed(1);
      setState(() {
        distanceD = double.parse(distance);
      });
    } else {
      setState(() {
        distanceD = 0.0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getImagesOfShops();
    getDistance();
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
          height: 180,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(1, 3),
                spreadRadius: 1,
                blurRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        widget.shopModel.name.toString(),
                        maxLines: 2,
                        style: TextStyle(
                            color: AppColors().brandDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                  // Text('${widget.shopModel.address}'),
                  // Text('${widget.shopModel.ondc_store_id}')
                ],
              ),
              widget.shopModel.items.isEmpty
                  ? Expanded(
                      child: Text(
                        "${widget.shopModel.name}",
                        style: TextStyle(
                            color: AppColors().brandDark,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: networkImages,
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${distanceD} kms',
                        style: TextStyle(
                          color: AppColors().grey80,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${widget.shopModel.item_count} items',
                        style: TextStyle(
                            color: AppColors().brandDark, fontSize: 16),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
