import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santhe/controllers/custom_image_controller.dart';
import '../../../controllers/boxes_controller.dart';

class AddCustomItemCard extends StatefulWidget {
  final int currentUserListDBKey;
  final String searchQuery;
  const AddCustomItemCard(
      {required this.currentUserListDBKey, required this.searchQuery, Key? key})
      : super(key: key);

  @override
  State<AddCustomItemCard> createState() => _AddCustomItemCardState();
}

class _AddCustomItemCardState extends State<AddCustomItemCard> {
  List<String> availableUnits = ['Kg', 'gms', 'L', 'ml', 'pack/s', 'Piece/s'];

  int customItemId = 4000;

  int custPhone =
      Boxes.getUserCredentialsDB().get('currentUserCredentials')?.phoneNumber ??
          404;
  bool isProcessing = false;
  final imageController = Get.find<CustomImageController>().addItemCustomImageUrl.value = '';

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    final String searchQuery = widget.searchQuery;
    double screenWidth = MediaQuery.of(context).size.width / 100;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth * 15,
                height: screenWidth * 15,
                child: const Icon(
                  CupertinoIcons.news,
                  color: Colors.orange,
                  size: 40.0,
                ),
              ),
              const SizedBox(
                width: 12.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(searchQuery,
                      style: const TextStyle(
                          color: Color(0xff8B8B8B),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0)),
                  const Text(
                    'Add a custom item',
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0),
                  ),
                ],
              ),
            ],
          ),
          const Icon(
                Icons.add,
                color: Colors.orange,
              ),
        ],
      ),
    );
  }
}
