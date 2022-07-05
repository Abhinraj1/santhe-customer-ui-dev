import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:santhe/controllers/custom_image_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:santhe/core/app_helpers.dart';

import 'package:flutter/material.dart';

import '../controllers/sent_tab_offer_card_controller.dart';

class FirebaseHelper {
  final sentUserListController = Get.find<SentUserListController>();

  offerStream() {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        log(doc["first_name"].toString());
      }
    });
  }

//Upload user image to firestore
  Future<String> addCustomItemImage(
      String imageName, bool shootPic, bool addNewItem) async {
    final imageController = Get.find<CustomImageController>();

    final ImagePicker _picker = ImagePicker();

    var image = await _picker.pickImage(
      source: shootPic ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 25,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    FirebaseStorage storage = FirebaseStorage.instance;

    int custPhone = int.parse(AppHelpers().getPhoneNumberWithoutCountryCode);
    try {
      File file;
      if (image != null) {
        Directory tempPath = await getTemporaryDirectory();
        file = await File('${tempPath.path}/compressedImage.png').create();
        var byteImg = await image.readAsBytes();
        var compressedImage = await FlutterImageCompress.compressWithList(
          byteImg,
          format: CompressFormat.png,
          quality: 25,
          minHeight: 512,
          minWidth: 512,
        );
        file.writeAsBytesSync(compressedImage);
      } else {
        file = File(image?.path ?? '/DCIM/Camera');
      }
      Reference ref = storage.ref().child("customItem/$custPhone-$imageName");
      UploadTask uploadTask = ref.putFile(file);
      uploadTask.snapshotEvents.listen((event) {
        imageController.imageUploadProgress.value =
            '${event.bytesTransferred.toDouble() / event.totalBytes.toDouble()}';
      });


      final snapshot = await uploadTask.whenComplete(() => null);
      final urlDownload = await snapshot.ref.getDownloadURL();
      file.delete();
      if (addNewItem) {
        imageController.addItemCustomImageUrl.value = urlDownload;
      } else {
        imageController.editItemCustomImageUrl.value = urlDownload;
      }
      log('Download Url: $urlDownload');
      imageController.imageUploadProgress.value = '';
      Get.snackbar(
        '',
        '',
        titleText: const SizedBox.shrink(),
        messageText: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('Image Successfully updated!'),
        ),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(8.0),
        backgroundColor: Colors.white,
        shouldIconPulse: true,
        icon: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            CupertinoIcons.checkmark_alt_circle_fill,
            color: Colors.green,
            size: 45,
          ),
        ),
      );

      return urlDownload;
    } on FirebaseException catch (e) {
      log(e.toString());
      return '';
    }

    // final TaskSnapshot downloadUrl = (await uploadTask);
    // final String url = downloadUrl.ref.getDownloadURL();
    // return url;
  }
}
