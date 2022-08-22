import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/app_url.dart';
import 'package:santhe/models/hive_models/item.dart';
import 'package:santhe/models/new_list/list_item_model.dart';

import 'package:santhe/models/santhe_item_model.dart';
import 'package:santhe/widgets/protectedCachedNetworkImage.dart';
import '../../../controllers/getx/all_list_controller.dart';

import '../../pop_up_widgets/new_item_popup_widget.dart';

class ListItemCard extends StatefulWidget {
  final ListItemModel listItem;
  final String listId;

  const ListItemCard({required this.listItem, Key? key, required this.listId})
      : super(key: key);

  @override
  State<ListItemCard> createState() => _ListItemCardState();
}

class _ListItemCardState extends State<ListItemCard> {
  final AllListController _allListController = Get.find();

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    //for quantity field validation

    const String placeHolderIdentifier = 'H+MbQeThWmYq3t6w';
    String checkPlaceHolder(String data) {
      if (data.contains(placeHolderIdentifier)) {
        return '';
      }
      return data;
    }

    final screenSize = MediaQuery.of(context).size;

    String img = widget.listItem.itemImageId.replaceAll(
        'https://firebasestorage.googleapis.com/v0/b/${AppUrl.envType}.appspot.com/o/',
        '');
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ProtectedCachedNetworkImage(
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/${AppUrl.envType}.appspot.com/o/$img',
                      width: 50.h,
                      height: 50.h,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.listItem.itemName,
                          style: TextStyle(
                            color: AppColors().grey100,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            expanded = !expanded;
                          }),
                          child: SizedBox(
                            width: screenSize.width / 3,
                            child: checkPlaceHolder(widget.listItem.brandType)
                                    .isEmpty
                                ? Text(
                                    checkPlaceHolder(widget.listItem.notes)
                                            .isEmpty
                                        ? '${AppHelpers.replaceDecimalZero(widget.listItem.quantity)} ${widget.listItem.unit}'
                                        : '${AppHelpers.replaceDecimalZero(widget.listItem.quantity)} ${widget.listItem.unit},\n${checkPlaceHolder(widget.listItem.notes)}',
                                    // softWrap: false,
                                    overflow:
                                        expanded ? null : TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : Text(
                                    '${AppHelpers.replaceDecimalZero(widget.listItem.quantity)}${widget.listItem.unit},\n${checkPlaceHolder(widget.listItem.notes).isEmpty ? checkPlaceHolder(widget.listItem.brandType) : '${checkPlaceHolder(widget.listItem.brandType)}, ${checkPlaceHolder(widget.listItem.notes)}'}',
                                    textAlign: TextAlign.start,
                                    overflow:
                                        expanded ? null : TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
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
                            return NewItemPopUpWidget(
                              item: Item(
                                status: '',
                                catId: widget.listItem.catId.toString(),
                                dItemNotes: widget.listItem.notes,
                                itemId: int.parse(widget.listItem.itemId.replaceAll(
                                    'projects/${AppUrl.envType}/databases/(default)/documents/item/',
                                    '')),
                                unit: widget.listItem.possibleUnits,
                                dUnit: widget.listItem.unit,
                                dBrandType: widget.listItem.brandType,
                                dQuantity: int.parse(widget.listItem.quantity),
                                itemAlias: '',
                                itemImageId: widget.listItem.itemImageId,
                                itemImageTn: '',
                                itemName: widget.listItem.itemName,
                                updateUser: 0,
                                createUser: 0,
                              ),
                              edit: true,
                              listId: widget.listId,
                            );
                          });
                    },
                    splashRadius: 0.1,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.orange,
                    )),
                IconButton(
                    onPressed: () {
                      _allListController.allListMap[widget.listId]!.items
                          .removeWhere((element) =>
                              element.itemId == widget.listItem.itemId);
                      _allListController
                          .update(['addedItems', 'itemCount', 'newList']);
                    },
                    icon: const Icon(Icons.delete_forever_outlined,
                        color: Colors.orange)),
              ],
            ),
          ],
        ));
  }
}
