import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:santhe/models/new_list/list_item_model.dart';

class SentListItemCard extends StatelessWidget {
  final ListItemModel listItem;

  const SentListItemCard({required this.listItem, Key? key}) : super(key: key);

  final String placeHolderIdentifier = 'H+MbQeThWmYq3t6w';

  String checkPlaceHolder(String data) {
    if (data.contains(placeHolderIdentifier)) {
      return '';
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
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
                        : 'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/' +
                            listItem.itemImageId.replaceAll(
                              'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/',
                              '',
                            ),
                    width: 50,
                    height: 50,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listItem.itemName),
                      checkPlaceHolder(listItem.brandType).isEmpty
                          ? AutoSizeText(
                              checkPlaceHolder(listItem.notes).isEmpty
                                  ? '${listItem.quantity} ${listItem.unit}'
                                  : '${listItem.quantity} ${listItem.unit}, ${checkPlaceHolder(listItem.notes)}',
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.orange,
                              ),
                            )
                          : AutoSizeText(
                              '${listItem.quantity} ${listItem.unit}, ${checkPlaceHolder(listItem.notes).isEmpty ? checkPlaceHolder(listItem.brandType) : '${checkPlaceHolder(listItem.brandType)}, ${checkPlaceHolder(listItem.notes)}'}',
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
      ),
    );
  }
}
