import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/controllers/custom_image_controller.dart';
import 'package:santhe/models/santhe_item_model.dart';
import 'package:santhe/widgets/pop_up_widgets/custom_item_popup_widget.dart';

import '../../../controllers/api_service_controller.dart';
import '../../../controllers/boxes_controller.dart';
import '../../../firebase/firebase_helper.dart';
import '../../../models/santhe_list_item_model.dart';

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
  //for quantity field validation
  final GlobalKey<FormState> _formKey = GlobalKey();

  // final TextEditingController _customerCategoryNameController =
  //     TextEditingController();
  final TextEditingController _customQtyController =
      TextEditingController(text: '1');
  final TextEditingController _customBrandController = TextEditingController();
  final TextEditingController _customNotesController = TextEditingController();
  final _unitsController = GroupButtonController(selectedIndex: 0);
  List<String> availableUnits = ['Kg', 'gms', 'L', 'ml', 'pack/s', 'Piece/s'];

  int customItemId = 4000;

  static const TextStyle kLabelTextStyle = TextStyle(
      color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 15);

  //todo add login check
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
    final int currentUserListDBKey = widget.currentUserListDBKey;
    final String searchQuery = widget.searchQuery;
    final imageController = Get.find<CustomImageController>();
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;
    final apiController = Get.find<APIs>();
    final TextEditingController _customItemNameController =
        TextEditingController(text: searchQuery);
    String selectedUnit = availableUnits[0];

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
          IconButton(
              onPressed: () {
                //todo implement add to user list on firebase
                showDialog(
                    context: context,
                    barrierColor: const Color.fromARGB(165, 241, 241, 241),
                    builder: (context) {
                      return CustomItemPopUpWidget(currentUserListDBKey: currentUserListDBKey, searchQuery: searchQuery);
                    });
              },
              icon: const Icon(
                Icons.add,
                color: Colors.orange,
              )),
        ],
      ),
    );
  }
}
