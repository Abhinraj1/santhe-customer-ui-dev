// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gits_cached_network_image/gits_cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_cart/hyperlocal_cart_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_cartmodel.dart';
import 'package:santhe/widgets/custom_widgets/custom_snackBar.dart';


class HyperLocalCartWidget extends StatefulWidget {
  final HyperLocalCartModel hyperLocalCartModel;
  const HyperLocalCartWidget({
    required this.hyperLocalCartModel,
  });

  @override
  State<HyperLocalCartWidget> createState() => _HyperLocalCartWidgetState();
}

class _HyperLocalCartWidgetState extends State<HyperLocalCartWidget>
    with LogMixin {
  late final Map quantity;
  late final dynamic mapQuantity;
  getInitialValues() {
    widget.hyperLocalCartModel.valueM = 0;
    widget.hyperLocalCartModel.maximum_valueM = 0;
    widget.hyperLocalCartModel.valueM =
        double.parse(widget.hyperLocalCartModel.offer_price.toString()) *
            double.parse(widget.hyperLocalCartModel.quantity.toString());
    widget.hyperLocalCartModel.maximum_valueM =
        double.parse(widget.hyperLocalCartModel.mrp.toString()) *
            double.parse(widget.hyperLocalCartModel.quantity.toString());
  }

  add() {

    if(widget.hyperLocalCartModel.quantity +1 <= widget.hyperLocalCartModel.inventory){
      setState(() {
        widget.hyperLocalCartModel.add();
      });
      context.read<HyperlocalCartBloc>().add(
        UpdateCartItemQuantityEvent(cartModel: widget.hyperLocalCartModel),
      );
    }else{
      customSnackBar(message: "Oops! That's all in stocks",
          showOnTop: true,isErrorMessage: true);
    }
  }

  minus() {
    if (widget.hyperLocalCartModel.quantity != 0) {
      setState(() {
        widget.hyperLocalCartModel.minus();
      });
      context.read<HyperlocalCartBloc>().add(
            UpdateCartItemQuantityEvent(cartModel: widget.hyperLocalCartModel),
          );
    }
  }

  getQuantity() {
    warningLog('${widget.hyperLocalCartModel.net_quantity}');
    quantity = json.decode(
      widget.hyperLocalCartModel.net_quantity.toString(),
    );
    errorLog('Quantity $quantity');
    mapQuantity = quantity['value'].toString() + quantity['unit'];
    errorLog('Final quantity $mapQuantity');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuantity();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    getInitialValues();
    warningLog('${widget.hyperLocalCartModel} also ');
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        child: Dismissible(
          key: ValueKey(widget.hyperLocalCartModel.productId),
          behavior: HitTestBehavior.values.first,
          onDismissed: (direction) async {
            // widget.hyperLocalCartModel.removeFromCart();
            // await cart.deleteCartItem(
            //   productOndcModelLocal: widget.hyperLocalCartModel,
            // );
            warningLog('Called to dismiss');
            Future.delayed(const Duration(milliseconds: 50), () {
              // widget.hyperLocalCartModel.removeFromCart();
              context.read<HyperlocalCartBloc>().add(
                    DeleteHyperCartItemEvent(
                      cartModel: widget.hyperLocalCartModel,
                    ),
                  );
            });
          },
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 50, top: 50),
            color: Colors.white,
            child: Column(
              children: [
                Icon(
                  Icons.delete,
                  color: AppColors().brandDark,
                  size: 25,
                ),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: AppColors().brandDark,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ),
          child: Container(
            width: width * 0.9,
            height: height * 0.18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 10,
                  spreadRadius: 1,
                  color: Colors.grey,
                )
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.hyperLocalCartModel.symbol == null
                          ? Image.asset(
                              'assets/cart.png',
                              fit: BoxFit.fill,
                              height: 90,
                              width: 70,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                height: height * 0.1,
                                width: width * 0.194444,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GitsCachedNetworkImage(
                                    imageUrl: widget.hyperLocalCartModel.symbol,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context) => Lottie.asset("assets/imageLoading.json"),
                                    errorBuilder: (context, error, stackTrace) => Image.asset(
                                      'assets/cart.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: height * 0.013588),
                              child: Container(
                                width: width * 0.6,
                                height: height * 0.04,
                                color: Colors.white,
                                child: AutoSizeText(
                                  '${widget.hyperLocalCartModel.product_name}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14,
                                  ),
                                  minFontSize: 13,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.016,
                            ),
                            Row(
                              children: [
                                widget.hyperLocalCartModel.net_quantity == null
                                    ? Container(
                                        width: width * 0.3,
                                        color: Colors.white,
                                        child: const Text(''),
                                      )
                                    : Container(
                                        width: width * 0.3,
                                        color: Colors.white,
                                        child: Text(
                                          //! make a check here as to what should be put in
                                          '${mapQuantity}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  width: width * 0.06,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: width * 0.28,
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: minus,
                                          child: const Icon(
                                            Icons.remove,
                                            size: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const VerticalDivider(
                                          color: Colors.black,
                                          thickness: 1,
                                        ),
                                        Text(
                                          '${widget.hyperLocalCartModel.quantity}',
                                          style: TextStyle(
                                            color: AppColors().brandDark,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const VerticalDivider(
                                          color: Colors.black,
                                          thickness: 1,
                                        ),
                                        GestureDetector(
                                          onTap: add,
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.grey,
                                            size: 18,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //! do a conditional check once data is available
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              height: height * 0.04,
                              width: width * 0.6,
                              color: Colors.white,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AutoSizeText(
                                      '₹ ${widget.hyperLocalCartModel.maximum_valueM}',
                                      style: TextStyle(
                                          color: AppColors().brandDark,
                                          fontSize: 8,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    AutoSizeText(
                                      '₹ ${widget.hyperLocalCartModel.valueM}',
                                      style: TextStyle(
                                          color: AppColors().brandDark,
                                          fontSize: 8,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 8,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 13.0, bottom: 3),
                //   child: Row(
                //     //! remove const
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       const SizedBox(
                //         width: 100,
                //         child: Text(
                //           'Delivery In',
                //           style: TextStyle(
                //             overflow: TextOverflow.ellipsis,
                //             fontSize: 13,
                //             color: Colors.black87,
                //           ),
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.only(right: 15.0),
                //         child: SizedBox(
                //           width: 100,
                //           child: Align(
                //             alignment: Alignment.centerRight,
                //             child: Text(
                //               '${widget.hyperLocalCartModel.time_to_ship}',
                //               style: const TextStyle(
                //                 overflow: TextOverflow.ellipsis,
                //                 fontSize: 13,
                //                 color: Colors.black87,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
