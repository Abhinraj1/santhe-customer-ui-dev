import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/models/offer/santhe_offer_item_model.dart';

class MerchantItemCard extends StatefulWidget {
  final OfferItem merchantItem;

  const MerchantItemCard({required this.merchantItem, Key? key})
      : super(key: key);

  @override
  State<MerchantItemCard> createState() => _MerchantItemCardState();
}

class _MerchantItemCardState extends State<MerchantItemCard> {
  final String placeHolderIdentifier = 'H+MbQeThWmYq3t6w';

  bool expanded = false;

  String checkPlaceHolder(String data) {
    if (data.contains(placeHolderIdentifier)) {
      return '';
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    String removeDecimalZeroFormat(double n) {
      return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: 'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${widget.merchantItem.itemImageId}',
              width: 50.sp,
              height: 50.sp,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                log('$error');
                return Container(
                  color: Colors.orange,
                  width: 50.sp,
                  height: 50.sp,
                );
              },
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 121.w,
                      child: Text(
                        widget.merchantItem.itemName,
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors().grey80,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width / 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        widget.merchantItem.merchAvailability
                            ? CupertinoIcons.checkmark_circle_fill
                            : CupertinoIcons.xmark_circle_fill,
                        color: widget.merchantItem.merchAvailability
                            ? Colors.green
                            : Colors.red,
                        size: 17.sp,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: SizedBox(
                        width: screenSize.width * 1 / 5,
                        child: Text(
                          '₹ ${widget.merchantItem.merchPrice}',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenSize.width * 2 / 5 - 40,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                        child: checkPlaceHolder(widget.merchantItem.brandType)
                                .isEmpty
                            ? Text(
                                checkPlaceHolder(widget.merchantItem.itemNotes)
                                        .isEmpty
                                    ? '${removeDecimalZeroFormat(widget.merchantItem.quantity)} ${widget.merchantItem.unit}'
                                    : '${removeDecimalZeroFormat(widget.merchantItem.quantity)} ${widget.merchantItem.unit}, ${checkPlaceHolder(widget.merchantItem.itemNotes)}',
                                softWrap: true,
                                overflow:
                                    expanded ? null : TextOverflow.ellipsis,
                                maxLines: 6,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 14.sp,
                                ),
                              )
                            : Text(
                                '${removeDecimalZeroFormat(widget.merchantItem.quantity)} ${widget.merchantItem.unit}, ${checkPlaceHolder(widget.merchantItem.itemNotes).isEmpty ? checkPlaceHolder(widget.merchantItem.brandType) : '${checkPlaceHolder(widget.merchantItem.brandType)}, ${checkPlaceHolder(widget.merchantItem.itemNotes)}'}',
                                softWrap: true,
                                // minFontSize: 10,
                                overflow:
                                    expanded ? null : TextOverflow.ellipsis,
                                // maxLines: 2,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 14.sp,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 2 / 5 - 40,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                        child: Text(
                          widget.merchantItem.merchNotes,
                          softWrap: true,
                          textAlign: TextAlign.right,
                          maxLines: 4,
                          // minFontSize: 10,
                          overflow: expanded ? null : TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
