import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:santhe/widgets/pop_up_widgets/new_item_popup_widget.dart';
import '../../../models/santhe_item_model.dart';

class ItemTileBtn extends StatefulWidget {
  final Item item;
  final String listId;
  const ItemTileBtn(
      {required this.item, required this.listId, Key? key})
      : super(key: key);

  @override
  State<ItemTileBtn> createState() => _ItemTileBtnState();
}

class _ItemTileBtnState extends State<ItemTileBtn> {

  @override
  Widget build(BuildContext context) {
    final Item item = widget.item;
    double screenWidth = MediaQuery.of(context).size.width / 100;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              barrierColor: const Color.fromARGB(165, 241, 241, 241),
              builder: (context) {
                return NewItemPopUpWidget(item: item, listId: widget.listId);
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
