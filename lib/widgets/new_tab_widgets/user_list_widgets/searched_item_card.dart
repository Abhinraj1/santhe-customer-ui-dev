import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:get/get.dart';

import 'package:group_button/group_button.dart';
import 'package:santhe/controllers/error_user_fallback.dart';
import '../../../controllers/api_service_controller.dart';
import '../../../controllers/boxes_controller.dart';
import '../../../controllers/custom_image_controller.dart';
import '../../../models/santhe_category_model.dart';
import '../../../models/santhe_item_model.dart';
import '../../../models/santhe_user_list_model.dart';

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

    
    List<Category> _categoryList = Boxes.getCategoriesDB().values.toList();
    return Padding(
        padding: const EdgeInsets.all(8.0),
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
                          item.catId == '999' ? 'Custom Category' : getCategoryName(_categoryList),
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
            const Icon(
              Icons.add,
              color: Colors.orange,
            ),
          ],
        ));
  }

  String getCategoryName(List<Category> categoryList){
    List<Category> temp = categoryList.where((element) => element.catId == int.parse(item.catId.replaceAll('projects/santhe-425a8/databases/(default)/documents/category/', ''))).toList();
    if(temp.isEmpty) {
      return 'Custom Category';
    } else {
      return temp.first.catName;
    }
  }
}
