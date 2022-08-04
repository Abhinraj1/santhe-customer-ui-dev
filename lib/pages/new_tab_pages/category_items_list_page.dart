import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

import 'package:get/get.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/core/app_url.dart';
import 'package:santhe/models/new_list/user_list_model.dart';
import 'package:santhe/widgets/protectedCachedNetworkImage.dart';
import '../../controllers/api_service_controller.dart';
import '../../controllers/boxes_controller.dart';
import '../../models/santhe_item_model.dart';
import '../../widgets/pop_up_widgets/new_item_popup_widget.dart';


class CategoryItemsPage extends StatelessWidget {
  final int catID;
  final String listId;
  CategoryItemsPage({required this.catID, required this.listId, Key? key}) : super(key: key);

  final apiController = Get.find<APIs>();
  final AllListController _allListController = Get.find();
  late final UserListModel currentUserList = _allListController.allListMap[listId]!;

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
          Boxes.getCategoriesDB().get(catID)?.catName ?? 'Category Items',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp),
        ),
      ),
      body: Stack(children: [
        FutureBuilder<List<Item>>(
          future: apiController.getCategoryItems(catID),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(left: 8.h, right: 8.h, bottom: 35.h, top: 8.h),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 4 / 5,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Item item = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierColor: const Color.fromARGB(165, 241, 241, 241),
                              builder: (context) {
                                return NewItemPopUpWidget(item: item, listId: listId);
                              });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //main show
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: ProtectedCachedNetworkImage(
                                imageUrl:
                                'https://firebasestorage.googleapis.com/v0/b/${AppUrl.envType}.appspot.com/o/${item.itemImageId.replaceAll('https://firebasestorage.googleapis.com/v0/b/${AppUrl.envType}.appspot.com/o/', '')}',
                                width: 20.vw,
                                height: 20.vw,
                              ),
                            ),
                            Expanded(
                              child: AutoSizeText(
                                item.itemName,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                minFontSize: 10.0,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                Get.close(2);
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
                      child: Row(
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
                          GetBuilder(
                            id: 'itemCount',
                            init: _allListController,
                            builder: (builder) => Column(
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
