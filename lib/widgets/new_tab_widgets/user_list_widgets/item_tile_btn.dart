import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:santhe/controllers/error_user_fallback.dart';
import 'package:santhe/firebase/firebase_helper.dart';
import 'package:santhe/widgets/pop_up_widgets/custom_item_popup_widget.dart';
import 'package:santhe/widgets/pop_up_widgets/new_item_popup_widget.dart';
import '../../../controllers/api_service_controller.dart';
import '../../../controllers/boxes_controller.dart';
import '../../../controllers/custom_image_controller.dart';
import '../../../models/santhe_item_model.dart';
import '../../../models/santhe_list_item_model.dart';
import '../../../models/santhe_user_list_model.dart';
import '../../../pages/new_tab_pages/image_page.dart';
import 'package:santhe/constants.dart';

class ItemTileBtn extends StatefulWidget {
  final Item item;
  final int currentUserListDBKey;
  const ItemTileBtn(
      {required this.item, required this.currentUserListDBKey, Key? key})
      : super(key: key);

  @override
  State<ItemTileBtn> createState() => _ItemTileBtnState();
}

class _ItemTileBtnState extends State<ItemTileBtn> {

  @override
  Widget build(BuildContext context) {
    final Item item = widget.item;
    final int currentUserListDBKey = widget.currentUserListDBKey;
    double screenWidth = MediaQuery.of(context).size.width / 100;

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //main show
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${item.itemImageId}',
                width: screenWidth * 25,
                height: screenWidth * 25,
                fit: BoxFit.cover,
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
  }
}
