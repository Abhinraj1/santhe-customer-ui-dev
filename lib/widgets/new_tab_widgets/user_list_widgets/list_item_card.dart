import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/models/new_list/list_item_model.dart';

import 'package:santhe/models/santhe_item_model.dart';
import 'package:santhe/models/santhe_list_item_model.dart';
import '../../../controllers/boxes_controller.dart';
import '../../../controllers/error_user_fallback.dart';
import '../../../models/santhe_user_list_model.dart';

import '../../pop_up_widgets/new_item_popup_widget.dart';

class ListItemCard extends StatelessWidget {
  final ListItemModel listItem;

  const ListItemCard(
      {required this.listItem, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    //for quantity field validation

    const String placeHolderIdentifier = 'H+MbQeThWmYq3t6w';
    String checkPlaceHolder(String data) {
      if (data.contains(placeHolderIdentifier)) {
        return '';
      }
      return data;
    }

    String img = listItem.itemImageId.replaceAll(
        'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/',
        '');
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/$img',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
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
                            ? Text(
                                checkPlaceHolder(listItem.notes).isEmpty
                                    ? AppHelpers.replaceDecimalZero(
                                            '${listItem.quantity}') +
                                        ' ${listItem.unit}'
                                    : AppHelpers.replaceDecimalZero(
                                            '${listItem.quantity}') +
                                        ' ${listItem.unit},\n${checkPlaceHolder(listItem.notes)}',
                                // softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 16.sp,
                                ),
                              )
                            : Text(
                                AppHelpers.replaceDecimalZero(
                                        '${listItem.quantity}') +
                                    '${listItem.unit}, ${checkPlaceHolder(listItem.notes).isEmpty ? checkPlaceHolder(listItem.brandType) : '${checkPlaceHolder(listItem.brandType)},\n${checkPlaceHolder(listItem.notes)}'}'
                                        '',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
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
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierColor:
                              const Color.fromARGB(165, 241, 241, 241),
                          builder: (context) {
                            return SizedBox();

                            /*return NewItemPopUpWidget(
                              item: Item(
                                status: '',
                                catId: listItem.catId.toString(),
                                dItemNotes: listItem.notes,
                                itemId: int.parse(listItem.itemId.replaceAll(
                                    'projects/santhe-425a8/databases/(default)/documents/item/',
                                    '')),
                                unit: listItem.possibleUnits,
                                dUnit: listItem.unit,
                                dBrandType: listItem.brandType,
                                dQuantity: listItem.quantity,
                                itemAlias: '',
                                itemImageId: listItem.itemImageId,
                                itemImageTn: '',
                                itemName: listItem.itemName,
                                updateUser: 0,
                                createUser: 0,
                              ),
                              currentUserListDBKey: currentUserListDBKey,
                              edit: true,
                            );*/
                          });
                    },
                    splashRadius: 0.1,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.orange,
                    )),
                IconButton(
                    onPressed: () {
                      /*//TODO implement delete feature

                      //deleting item
                      currentUserList.items.remove(listItem);

                      //make changes persistent
                      currentUserList.save();*/
                    },
                    icon: const Icon(Icons.delete_forever_outlined, color: Colors.orange)),
              ],
            ),
          ],
        ));
  }
}
