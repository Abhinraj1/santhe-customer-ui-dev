import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import '../../controllers/boxes_controller.dart';
import '../../controllers/error_user_fallback.dart';
import '../../models/santhe_user_list_model.dart';
import '../../widgets/new_tab_widgets/user_list_widgets/category_tile_btn.dart';
import 'package:get/get.dart';

class CategoriesPage extends StatelessWidget {
  final int currentUserListDBKey;
  const CategoriesPage({required this.currentUserListDBKey, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;
    final apiController = Get.find<APIs>();
    UserList currentCustomerList =
        Boxes.getUserListDB().get(currentUserListDBKey) ??
            fallBack_error_userList;

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: screenHeight * 5.5,
        leading: IconButton(
          splashRadius: 0.1,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 13.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Categories',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp),
        ),
      ),
      body: Stack(children: [
        GridView.builder(
            padding: const EdgeInsets.all(8.0),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 4 / 5),
            itemCount: Boxes.getCategoriesDB().keys.length,
            itemBuilder: (context, index) {
              return CategoryTile(
                category: Boxes.getCategoriesDB().get(100 + index) ??
                    fallBack_error_category,
                currentUserListDBKey: currentUserListDBKey,
              );
            }),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Hero(
                tag: 'item_counter',
                child: Container(
                  width: 344.sp,
                  height: 69.sp,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.21),
                        blurRadius: 15.0, // soften the shadow
                        spreadRadius: 3.6, //extend the shadow
                        offset: const Offset(
                          0.0,
                          0.0,
                        ),
                      )
                    ],
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 10.0),
                      child: ValueListenableBuilder<Box<UserList>>(
                        valueListenable: Boxes.getUserListDB().listenable(),
                        builder: (context, box, widget) {
                          UserList currentUserList =
                              Boxes.getUserListDB().get(currentUserListDBKey) ??
                                  fallBack_error_userList;

                          ScreenUtil.init(
                              BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width,
                                  maxHeight: MediaQuery.of(context).size.height),
                              designSize: const Size(390, 844),
                              context: context,
                              minTextAdapt: true,
                              orientation: Orientation.portrait);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  currentUserList.listName,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  minFontSize: 14,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xffB0B0B0),
                                      fontSize: 18.sp),
                                ),
                              ),
                              Column(
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${currentUserList.items.length}',
                                      style: TextStyle(
                                          fontSize: 21.sp,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.orange),
                                    ),
                                  ),
                                  Text(
                                    currentUserList.items.length < 2
                                        ? 'Item'
                                        : 'Items',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        color: Colors.orange),
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
