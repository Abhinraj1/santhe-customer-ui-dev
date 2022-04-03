import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhe/models/offer/santhe_offer_item_model.dart';

class MerchantItemCard extends StatelessWidget {
  final OfferItem merchantItem;
  const MerchantItemCard({required this.merchantItem, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;
    String removeDecimalZeroFormat(double n) {
      return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
    }

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: int.parse(merchantItem.itemId.replaceAll(
                                  'projects/santhe-425a8/databases/(default)/documents/item/',
                                  '')) <
                              4000
                          ? 'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${merchantItem.itemImageId}'
                          : merchantItem.itemImageId,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        print(error);
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(merchantItem.itemName),
                        merchantItem.brandType.isEmpty
                            ? Text(
                                merchantItem.itemNotes.isEmpty
                                    ? '${removeDecimalZeroFormat(merchantItem.quantity)} ${merchantItem.unit}'
                                    : '${removeDecimalZeroFormat(merchantItem.quantity)} ${merchantItem.unit}, ${merchantItem.itemNotes}',
                                // softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.mulish(
                                  color: Colors.orange,
                                  fontSize: 16.sp,
                                ),
                              )
                            : Text(
                                '${removeDecimalZeroFormat(merchantItem.quantity)} ${merchantItem.unit}, ${merchantItem.itemNotes.isEmpty ? '${merchantItem.brandType}' : '${merchantItem.brandType}, ${merchantItem.itemNotes}'}',
                                // softWrap: true,
                                maxLines: 2,
                                // minFontSize: 10,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.mulish(
                                  color: Colors.orange,
                                  fontSize: 14.sp,
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Icon(
                    merchantItem.merchAvailability
                        ? CupertinoIcons.checkmark_circle_fill
                        : CupertinoIcons.xmark_circle_fill,
                    color: merchantItem.merchAvailability
                        ? Colors.green
                        : Colors.red),
                const SizedBox(width: 10.0),
                Text(
                  'Rs. ${merchantItem.merchPrice}',
                  style: GoogleFonts.mulish(color: Colors.orange),
                ),
              ],
            ),
          ],
        ));
  }
}
