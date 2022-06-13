import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:group_button/group_button.dart';
import 'package:santhe/models/santhe_item_model.dart';
import '../../../controllers/api_service_controller.dart';
import 'package:santhe/models/santhe_list_item_model.dart';
import '../../../controllers/boxes_controller.dart';
import '../../../controllers/custom_image_controller.dart';
import '../../../controllers/error_user_fallback.dart';
import '../../../firebase/firebase_helper.dart';
import '../../../models/santhe_user_list_model.dart';
import '../../../pages/new_tab_pages/image_page.dart';
import 'package:santhe/constants.dart';

import '../../pop_up_widgets/new_item_popup_widget.dart';

class ListItemCard extends StatelessWidget {
  final ListItem listItem;
  final int currentUserListDBKey;
  const ListItemCard(
      {required this.listItem, required this.currentUserListDBKey, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var apiController = Get.find<APIs>();
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;
    //for quantity field validation
    final GlobalKey<FormState> _formKey = GlobalKey();
    final imageController = Get.find<CustomImageController>();
    String removeDecimalZeroFormat(double n) {
      return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
    }

    final TextEditingController _qtyController = TextEditingController(
        text: listItem.quantity.toString());
    final TextEditingController _brandController =
        TextEditingController(text: listItem.brandType);
    final TextEditingController _notesController =
        TextEditingController(text: listItem.notes);

    final int unitIndex = listItem.possibleUnits
        .indexWhere((element) => element == listItem.unit);
    final _unitsController = GroupButtonController(selectedIndex: unitIndex);


    String selectedUnit = listItem.unit;

    UserList currentUserList = Boxes.getUserListDB().get(currentUserListDBKey) ?? fallBack_error_userList;

    const TextStyle kLabelTextStyle = TextStyle(color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 15);

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    String img = listItem.itemImageId.replaceAll('https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/', '');
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
                      imageUrl: 'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/$img',
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
                            ? Text(
                                listItem.notes.isEmpty
                                    ? '${listItem.quantity} ${listItem.unit}'
                                    : '${listItem.quantity} ${listItem.unit},\n${listItem.notes}',
                                // softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 16.sp,
                                ),
                              )
                            : Text(
                                '''${listItem.quantity} ${listItem.unit}, ${listItem.notes.isEmpty ? '${listItem.brandType}' : '${listItem.brandType},\n${listItem.notes}'}''',
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
                            ScreenUtil.init(
                                BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width,
                                    maxHeight:
                                        MediaQuery.of(context).size.height),
                                designSize: const Size(390, 844),
                                context: context,
                                minTextAdapt: true,
                                orientation: Orientation.portrait);
                            print('here');
                            print(listItem.itemId);
                            return NewItemPopUpWidget(item: Item(
                              status: '',
                              catId: listItem.catId.toString(),
                              dItemNotes: listItem.notes,
                              itemId: int.parse(listItem.itemId.replaceAll('projects/santhe-425a8/databases/(default)/documents/item/projects/santhe-425a8/databases/(default)/documents/item/projects/santhe-425a8/databases/(default)/documents/item/', '')),
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
                            ), currentUserListDBKey: currentUserListDBKey, edit: true,);
                          });
                    },
                    splashRadius: 0.1,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.orange,
                    )),
                IconButton(
                    onPressed: () {
                      //TODO implement delete feature

                      //deleting item
                      currentUserList.items.remove(listItem);

                      //make changes persistent
                      currentUserList.save();
                    },
                    icon: const Icon(Icons.delete_forever_outlined,
                        color: Colors.orange)),
              ],
            ),
          ],
        ));
  }
}
