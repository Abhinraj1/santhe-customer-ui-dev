// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/loggers.dart';

import 'package:santhe/models/hyperlocal_models/hyperlocal_shopmodel.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_shopdetails/hyperlocal_shopdetails_view.dart';
import 'package:santhe/widgets/ondc_widgets/shop_images_intro.dart';

class HyperLocalShopWidget extends StatefulWidget {
  final HyperLocalShopModel hyperLocalShopModel;
  const HyperLocalShopWidget({
    Key? key,
    required this.hyperLocalShopModel,
  }) : super(key: key);

  @override
  State<HyperLocalShopWidget> createState() => _HyperLocalShopWidgetState();
}

class _HyperLocalShopWidgetState extends State<HyperLocalShopWidget>
    with LogMixin {
  List<String> images = [];
  List<ShopImageIntro> networkImages = [];
  dynamic distanceD = 0;

  getImagesOfShops() {
    if (widget.hyperLocalShopModel.images.length != null) {
      for (var i = 0; i < widget.hyperLocalShopModel.images.length - 1; i++) {
        final string = widget.hyperLocalShopModel.images[i]['display_image'];
        if (string.toString().contains('null')) {
          images.add('assets/cart.png');
        } else {
          images.add(string);
        }
      }
      for (var element in images) {
        networkImages.add(
          ShopImageIntro(image: element),
        );
      }
    }
  }

  getDistance() {
    if (widget.hyperLocalShopModel.distance != null) {
      dynamic d = widget.hyperLocalShopModel.distance;
      String? distance = d.toStringAsFixed(1);
      setState(() {
        distanceD = double.parse(distance!);
      });
    } else {
      setState(() {
        distanceD = 0.0;
      });
    }
  }

  @override
  void initState() {
    getImagesOfShops();
    getDistance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    errorLog('Images of hyper local ${widget.hyperLocalShopModel.images}');
    return GestureDetector(
      onTap: () => Get.to(
        HyperlocalShopdetailsView(
            hyperLocalShopModel: widget.hyperLocalShopModel),
      ),
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
                        widget.hyperLocalShopModel.name.toString(),
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
              widget.hyperLocalShopModel.images.isEmpty
                  ? Expanded(
                      child: Text(
                        "${widget.hyperLocalShopModel.name}",
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
                        '${widget.hyperLocalShopModel.itemCount} items',
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
