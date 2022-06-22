import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    double screenWidth = MediaQuery.of(context).size.width / 100;
    final screenSize = MediaQuery.of(context).size;
    String removeDecimalZeroFormat(double n) {
      return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CachedNetworkImage(
              imageUrl: int.parse(widget.merchantItem.itemId.replaceAll(
                          'projects/santhe-425a8/databases/(default)/documents/item/',
                          '')) <
                      4000
                  ? 'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${widget.merchantItem.itemImageId}'
                  : 'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/' +
                      widget.merchantItem.itemImageId,
              width: 50.w,
              height: 50.h,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                log('$error');
                return Container(
                  color: Colors.orange,
                  width: screenWidth * 50,
                  height: screenWidth * 50,
                );
              },
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          SizedBox(
            width: screenSize.width * 2 / 5 - 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.merchantItem.itemName,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff8B8B8B),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  child: checkPlaceHolder(widget.merchantItem.brandType).isEmpty
                      ? Text(
                          checkPlaceHolder(widget.merchantItem.itemNotes)
                                  .isEmpty
                              ? '${removeDecimalZeroFormat(widget.merchantItem.quantity)} ${widget.merchantItem.unit}'
                              : '${removeDecimalZeroFormat(widget.merchantItem.quantity)} ${widget.merchantItem.unit}, ${checkPlaceHolder(widget.merchantItem.itemNotes)}',
                          softWrap: true,
                          overflow: expanded ? null : TextOverflow.ellipsis,
                          maxLines: 6,
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 18.sp,
                          ),
                        )
                      : Text(
                          '${removeDecimalZeroFormat(widget.merchantItem.quantity)} ${widget.merchantItem.unit}, ${checkPlaceHolder(widget.merchantItem.itemNotes).isEmpty ? checkPlaceHolder(widget.merchantItem.brandType) : '${checkPlaceHolder(widget.merchantItem.brandType)}, ${checkPlaceHolder(widget.merchantItem.itemNotes)}'}',
                          softWrap: true,
                          // minFontSize: 10,
                          overflow: expanded ? null : TextOverflow.ellipsis,
                          // maxLines: 2,
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 18.sp,
                          ),
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  child: Text(
                    widget.merchantItem.merchNotes,
                    softWrap: true,
                    maxLines: 2,
                    // minFontSize: 10,
                    overflow: expanded ? null : TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 18.sp,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: screenSize.width / 10,
          ),
          Icon(
            widget.merchantItem.merchAvailability
                ? CupertinoIcons.checkmark_circle_fill
                : CupertinoIcons.xmark_circle_fill,
            color: widget.merchantItem.merchAvailability
                ? Colors.green
                : Colors.red,
          ),
          SizedBox(
            width: 2.w,
          ),
          Expanded(
            child: SizedBox(
              width: screenSize.width * 1 / 5,
              child: Text(
                '₹ ${widget.merchantItem.merchPrice}',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.fade,
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
