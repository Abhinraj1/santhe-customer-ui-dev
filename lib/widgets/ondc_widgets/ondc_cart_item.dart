// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/ondc_cart/cart_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/ondc_cart_repository.dart';
import 'package:santhe/models/ondc/cart_item_model.dart';

class OndcCartItem extends StatefulWidget {
  final CartitemModel productOndcModel;
  const OndcCartItem({
    Key? key,
    required this.productOndcModel,
  }) : super(key: key);

  @override
  State<OndcCartItem> createState() => _OndcCartItemState();
}

class _OndcCartItemState extends State<OndcCartItem> with LogMixin {
  late final CartBloc cartBloc;
  // int quantity = 0;

  @override
  void initState() {
    super.initState();
    cartBloc = context.read<CartBloc>();
  }

  getInitialValues() {
    widget.productOndcModel.valueM = 0;
    widget.productOndcModel.maximum_valueM = 0;
    widget.productOndcModel.valueM =
        double.parse(widget.productOndcModel.value.toString()) *
            double.parse(widget.productOndcModel.quantity.toString());
    widget.productOndcModel.maximum_valueM =
        double.parse(widget.productOndcModel.maximum_value.toString()) *
            double.parse(widget.productOndcModel.quantity.toString());
  }

  add() {
    setState(() {
      widget.productOndcModel.add();
    });
    context
        .read<CartBloc>()
        .add(UpdateQuantityEvent(cartModel: widget.productOndcModel));
  }

  minus() {
    if (widget.productOndcModel.quantity != 0) {
      setState(() {
        widget.productOndcModel.minus();
      });
      context.read<CartBloc>().add(
            UpdateQuantityEvent(cartModel: widget.productOndcModel),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final cart = RepositoryProvider.of<OndcCartRepository>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    getInitialValues();
    warningLog('${widget.productOndcModel} also ');
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        child: Dismissible(
          key: ValueKey(widget.productOndcModel.id),
          behavior: HitTestBehavior.values.first,
          onDismissed: (direction) async {
            // widget.productOndcModel.removeFromCart();
            // await cart.deleteCartItem(
            //   productOndcModelLocal: widget.productOndcModel,
            // );
            warningLog('Called to dismiss');
            Future.delayed(const Duration(milliseconds: 50), () {
              // widget.productOndcModel.removeFromCart();
              context.read<CartBloc>().add(
                    DeleteCartItemEvent(
                        productOndcModel: widget.productOndcModel),
                  );
              // context.read<CartBloc>().add(
              //       DeleteCartItemEvent(
              //           productOndcModel: widget.productOndcModel),
              //     );
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
                    children: [
                      widget.productOndcModel.symbol == null
                          ? Image.asset(
                              'assets/cart.png',
                              fit: BoxFit.fill,
                              height: 90,
                              width: 70,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                height: height * 0.09831461,
                                width: width * 0.194444,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.productOndcModel.symbol,
                                    fit: BoxFit.contain,
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/cart.png',
                                      fit: BoxFit.fill,
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
                              padding: EdgeInsets.only(top: height * 0.01356),
                              child: Container(
                                width: width * 0.6,
                                height: height * 0.04,
                                color: Colors.white,
                                child: AutoSizeText(
                                  '${widget.productOndcModel.item_name}',
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
                                widget.productOndcModel.net_quantity == null
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
                                          '${widget.productOndcModel.net_quantity}',
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
                                          '${widget.productOndcModel.quantity}',
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
                                      '₹ ${widget.productOndcModel.maximum_valueM}',
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
                                      '₹ ${widget.productOndcModel.valueM}',
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
                //               '${widget.productOndcModel.time_to_ship}',
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
