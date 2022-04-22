import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../controllers/api_service_controller.dart';
import '../../controllers/boxes_controller.dart';
import '../../controllers/error_user_fallback.dart';
import '../../models/santhe_item_model.dart';
import '../../models/santhe_user_list_model.dart';
import '../../widgets/new_tab_widgets/user_list_widgets/item_tile_btn.dart';

// final int catID;
// final int currentUserListID;

class CategoryItemsPage extends StatefulWidget {
  final int catID;
  final int currentUserListDBKey;
  const CategoryItemsPage(
      {required this.catID, required this.currentUserListDBKey, Key? key})
      : super(key: key);

  @override
  State<CategoryItemsPage> createState() => _CategoryItemsPageState();
}

class _CategoryItemsPageState extends State<CategoryItemsPage> {
  final apiController = Get.find<APIs>();

  @override
  Widget build(BuildContext context) {
    final int catID = widget.catID;
    final int currentUserListDBKey = widget.currentUserListDBKey;

    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;

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
          Boxes.getCategoriesDB().get(catID)?.catName ?? 'Category Items',
          style: GoogleFonts.mulish(
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
                  padding: const EdgeInsets.all(8),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 4 / 5,
                  ),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return ItemTileBtn(
                      item: snapshot.data![index],
                      currentUserListDBKey: currentUserListDBKey,
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
                                maxHeight:
                                MediaQuery.of(context).size.height),
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
                                style: GoogleFonts.mulish(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xffB0B0B0),
                                    fontSize: 18.sp),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '${currentUserList.items.length}',
                                  style: GoogleFonts.mulish(
                                      fontSize: 21.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.orange),
                                ),
                                Text(
                                  currentUserList.items.length < 2
                                      ? 'Item'
                                      : 'Items',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.mulish(
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
        )
      ]),
    );
  }
}
