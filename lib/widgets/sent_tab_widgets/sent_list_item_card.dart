import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/santhe_list_item_model.dart';

class SentListItemCard extends StatelessWidget {
  final ListItem listItem;
  const SentListItemCard({required this.listItem, Key? key}) : super(key: key);

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
                      imageUrl: int.parse(listItem.itemId.replaceAll(
                                  'projects/santhe-425a8/databases/(default)/documents/item/',
                                  '')) <
                              4000
                          ? 'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${listItem.itemImageId}'
                          : listItem.itemImageId,
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
                        Text(listItem.itemName),
                        listItem.brandType.isEmpty
                            ? AutoSizeText(
                                listItem.notes.isEmpty
                                    ? '${removeDecimalZeroFormat(listItem.quantity)} ${listItem.unit}'
                                    : '${removeDecimalZeroFormat(listItem.quantity)} ${listItem.unit}, ${listItem.notes}',
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.orange,
                                ),
                              )
                            : AutoSizeText(
                                '${removeDecimalZeroFormat(listItem.quantity)} ${listItem.unit}, ${listItem.notes.isEmpty ? '${listItem.brandType}' : '${listItem.brandType}, ${listItem.notes}'}',
                                softWrap: false,
                                maxLines: 2,
                                minFontSize: 10,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: screenWidth * 4,
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
