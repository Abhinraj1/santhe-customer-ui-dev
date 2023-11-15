// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gits_cached_network_image/gits_cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/loggers.dart';

import 'package:santhe/models/hyperlocal_models/hyperlocal_productmodel.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_productdescription/hyperlocal_productdescription_view.dart';

import '../../manager/imageManager.dart';

class HyperLocalProductWidget extends StatefulWidget {
  final HyperLocalProductModel hyperLocalProductModel;
  const HyperLocalProductWidget({Key? key,
    required this.hyperLocalProductModel,
  }) : super(key: key);

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
      child: Container(
        width: width * 0.444,
        height: 80,
        margin: const EdgeInsets.all(10),
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
                        'assets/placeHolder.jpeg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                :
            ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: height * 0.1264,
                      width: width * 0.25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GitsCachedNetworkImage(
                          imageUrl:
                              widget.hyperLocalProductModel.display_image,
                          fit: BoxFit.cover,
                          loadingBuilder: (context) => Lottie.asset(ImgManager().imageLoader),
                          errorBuilder: (context, url, error) => Image.asset(
                            'assets/placeHolder.jpeg',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
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
            discount.toString().split('.').first == "0" ? const SizedBox() :
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
    );
  }
}
