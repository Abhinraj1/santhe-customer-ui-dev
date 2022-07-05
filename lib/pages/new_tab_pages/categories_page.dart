import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/models/new_list/user_list_model.dart';
import '../../controllers/boxes_controller.dart';
import '../../models/santhe_category_model.dart';
import '../../models/santhe_user_list_model.dart';
import 'package:get/get.dart';

import 'category_items_list_page.dart';

class CategoriesPage extends StatelessWidget {
  final String listId;
  CategoriesPage({required this.listId, Key? key})
      : super(key: key);

  final AllListController _allListController = Get.find();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 100;
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
              return _tileButton(Boxes.getCategoriesDB().get(100 + index)!);
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
                      child: GetBuilder(
                        init: _allListController,
                        id: 'newList',
                        builder: (ctr){
                          UserListModel currentUserList = _allListController.allListMap[listId]!;
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

  Widget _tileButton(Category category) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: () {
        Get.to(() => CategoryItemsPage(
                catID: category.catId,
                listId: listId,
              ));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${category.catImageId}',
              width: 20.vw,
              height: 20.vw,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: AutoSizeText(
              category.catName,
              textAlign: TextAlign.center,
              minFontSize: 10,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    ),
  );
}
