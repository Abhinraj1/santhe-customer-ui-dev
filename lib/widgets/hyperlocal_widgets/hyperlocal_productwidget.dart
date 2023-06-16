// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/loggers.dart';

import 'package:santhe/models/hyperlocal_models/hyperlocal_productmodel.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_productdescription/hyperlocal_productdescription_view.dart';

class HyperLocalProductWidget extends StatefulWidget {
  final HyperLocalProductModel hyperLocalProductModel;
  const HyperLocalProductWidget({
    required this.hyperLocalProductModel,
  });

  @override
  State<HyperLocalProductWidget> createState() =>
      _HyperLocalProductWidgetState();
}

class _HyperLocalProductWidgetState extends State<HyperLocalProductWidget>
    with LogMixin {
  bool isSameValue = false;
  double discount = 0;

  checkValue() {
    if (widget.hyperLocalProductModel.mrp !=
        widget.hyperLocalProductModel.offer_price) {
      setState(() {
        isSameValue = false;
      });
    } else {
      setState(() {
        isSameValue = true;
      });
    }
  }

  getDiscountPrice() {
    discount = 0;
    discount = (widget.hyperLocalProductModel.mrp -
            widget.hyperLocalProductModel.offer_price) /
        widget.hyperLocalProductModel.mrp *
        100;
    warningLog('Discount $discount');
  }

  @override
  void initState() {
    super.initState();
    checkValue();
    getDiscountPrice();
  }

  int n = 0;
  void add() {
    setState(() {
      n++;
    });
  }

  void minus() {
    setState(() {
      if (n != 0) {
        n--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Get.to(
          () => HyperlocalProductdescriptionView(
              productModel: widget.hyperLocalProductModel),
        );
      },
      child: Stack(
        children: [
          Container(
            width: width * 0.444,
            height: height * 0.28089,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Align(
                //     alignment: Alignment.topRight,
                //     child: widget.hyperLocalProductModel.active
                //         ? Image.asset(
                //             'assets/nonveg.png',
                //             height: 17,
                //             width: 17,
                //           )
                //         : Image.asset('assets/veg.png'),
                //   ),
                // ),
                const SizedBox(
                  height: 17,
                  width: 17,
                ),
                widget.hyperLocalProductModel.display_image == null
                    ? SizedBox(
                        height: height * 0.1264,
                        width: 90,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            'assets/cart.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: height * 0.1264,
                          width: width * 0.25,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl:
                                  widget.hyperLocalProductModel.display_image,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/cart.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 2),
                    child: Container(
                      height: height * 0.042134,
                      color: Colors.white,
                      child: AutoSizeText(
                        widget.hyperLocalProductModel.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 11),
                        minFontSize: 8,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: AutoSizeText(
                  '${discount.toString().split('.').first}% off',
                  minFontSize: 9,
                  maxFontSize: 10,
                  style: TextStyle(
                      color: AppColors().green100, fontWeight: FontWeight.bold),
                )),
                isSameValue
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Rs ${widget.hyperLocalProductModel.offer_price.toString()}',
                              style: TextStyle(
                                  color: AppColors().brandDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Rs ${widget.hyperLocalProductModel.mrp}',
                                style: TextStyle(
                                  color: AppColors().brandDark,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 4,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Rs ${widget.hyperLocalProductModel.offer_price.toString()}',
                                style: TextStyle(
                                    color: AppColors().brandDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      )
              ],
            ),
          ),
          // Positioned(
          //   top: 145,
          //   child: GestureDetector(
          //     onTap: () {
          //       setState(() {
          //         n++;
          //       });
          //     },
          //     child: n > 0
          //         ? Container(
          //             width: 160,
          //             height: 45,
          //             decoration: const BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.only(
          //                 bottomLeft: Radius.circular(15.0),
          //                 bottomRight: Radius.circular(15.0),
          //               ),
          //             ),
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 35.0),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   GestureDetector(
          //                     onTap: add,
          //                     child: const Icon(
          //                       Icons.add,
          //                       color: Colors.black,
          //                       size: 17,
          //                     ),
          //                   ),
          //                   Text(
          //                     n.toString(),
          //                     style: TextStyle(
          //                         color: AppColors().brandDark,
          //                         fontWeight: FontWeight.bold,
          //                         fontSize: 18),
          //                   ),
          //                   GestureDetector(
          //                     onTap: minus,
          //                     child: const Icon(
          //                       Icons.remove,
          //                       color: Colors.black,
          //                       size: 17,
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //           )
          //         : Container(
          //             width: 160,
          //             height: 45,
          //             decoration: BoxDecoration(
          //               color: AppColors().brandDark,
          //               borderRadius: const BorderRadius.only(
          //                 bottomLeft: Radius.circular(15.0),
          //                 bottomRight: Radius.circular(15.0),
          //               ),
          //             ),
          //             child: const Center(
          //               child: Text(
          //                 'Add To Cart',
          //                 style: TextStyle(
          //                     color: Colors.white, fontWeight: FontWeight.bold),
          //               ),
          //             ),
          //           ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
