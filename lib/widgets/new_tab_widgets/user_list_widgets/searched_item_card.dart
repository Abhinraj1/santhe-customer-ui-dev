import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:santhe/controllers/error_user_fallback.dart';
import 'package:santhe/widgets/pop_up_widgets/new_item_popup_widget.dart';
import '../../../controllers/api_service_controller.dart';
import '../../../controllers/boxes_controller.dart';
import '../../../controllers/custom_image_controller.dart';
import '../../../firebase/firebase_helper.dart';
import '../../../models/santhe_category_model.dart';
import '../../../models/santhe_item_model.dart';
import '../../../models/santhe_list_item_model.dart';
import '../../../models/santhe_user_list_model.dart';
import '../../../pages/new_tab_pages/image_page.dart';
import '../../../pages/new_tab_pages/user_list_page.dart';
import 'package:santhe/constants.dart';

class SearchedItemCard extends StatelessWidget {
  final String searchQuery;
  final Item item;
  final int currentUserListDBKey;
  final VoidCallback clearSearchQuery;
  const SearchedItemCard(
      {required this.searchQuery,
      required this.item,
      required this.currentUserListDBKey,
      required this.clearSearchQuery,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;

    //for quantity field validation
    final GlobalKey<FormState> _formKey = GlobalKey();

    final TextEditingController _qtyController =
        TextEditingController(text: '${item.dQuantity}');
    final TextEditingController _brandController = TextEditingController();
    final TextEditingController _notesController = TextEditingController();
    final _unitsController = GroupButtonController(
        selectedIndex: item.unit.indexWhere(
            (element) => element.toLowerCase() == item.dUnit.toLowerCase()));
    String selectedUnit = item.unit[item.unit.indexWhere(
        (element) => element.toLowerCase() == item.dUnit.toLowerCase())];

    print(item.dUnit);
    print(item.unit);

    final apiController = Get.find<APIs>();
    final imageController2 =
        Get.find<CustomImageController>().editItemCustomImageUrl.value = '';

    const TextStyle kLabelTextStyle = TextStyle(
        color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 15);

    final imageController = Get.find<CustomImageController>();

    String removeDecimalZeroFormat(double n) {
      return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
    }

    UserList currentUserList =
        Boxes.getUserListDB().get(currentUserListDBKey) ??
            fallBack_error_userList;
    int custPhone = Boxes.getUserCredentialsDB()
            .get('currentUserCredentials')
            ?.phoneNumber ??
        404;

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    List<Category> _categoryList = Boxes.getCategoriesDB().values.toList();
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                barrierColor: const Color.fromARGB(165, 241, 241, 241),
                builder: (context) {
                  return NewItemPopUpWidget(item: item, currentUserListDBKey: currentUserListDBKey);
                });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${item.itemImageId}',
                        width: screenWidth * 15,
                        height: screenWidth * 15,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return Container(
                            color: Colors.orange,
                            width: screenWidth * 25,
                            height: screenWidth * 25,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            item.itemName,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700),
                          ),
                          Text(
                            item.catId == '999' ? 'Custom Category' : _categoryList.firstWhere((element) => element.catId == int.parse(item.catId.replaceAll('projects/santhe-425a8/databases/(default)/documents/category/', ''))).catName,
                            style: const TextStyle(
                              color: Colors.orange,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierColor:
                            const Color.fromARGB(165, 241, 241, 241),
                        builder: (context) {
                          return NewItemPopUpWidget(item: item, currentUserListDBKey: currentUserListDBKey);
                        });
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.orange,
                  )),
            ],
          ),
        ));
  }
}
