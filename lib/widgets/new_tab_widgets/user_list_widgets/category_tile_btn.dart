import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santhe/models/santhe_category_model.dart';
import '../../../pages/new_tab_pages/category_items_list_page.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final String listId;
  const CategoryTile(
      {required this.category, required this.listId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          /*Get.to(() => CategoryItemsPage(
                catID: category.catId,
                currentUserListDBKey: currentUserListDBKey,
              ));*/
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${category.catImageId}',
                width: screenWidth * 25,
                height: screenWidth * 25,
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
}
