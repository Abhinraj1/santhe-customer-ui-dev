import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:santhe/controllers/custom_image_controller.dart';
import 'package:santhe/widgets/confirmation_widgets/success_snackbar_widget.dart';

import '../controllers/boxes_controller.dart';
import 'package:flutter/material.dart';

import '../controllers/sent_tab_offer_card_controller.dart';
import '../models/santhe_user_list_model.dart';

class FirebaseHelper {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final sentUserListController = Get.find<SentUserListController>();

  offerStream() {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["first_name"]);
      });
    });
  }

  // Stream<QuerySnapshot> offerStream() {
  //   CollectionReference collectionReference =
  //       _firebaseFirestore.collection('customerList');
  //
  //   Stream<QuerySnapshot> data = collectionReference
  //       .where('listId', isGreaterThanOrEqualTo: '919769420366')
  //       .where('custListStatus', isEqualTo: 'sent')
  //       // .orderBy('custListSentTime')
  //       .snapshots();
  //
  //   return data;
  // }

//Upload user image to firestore
  Future<String> addCustomItemImage(String imageName, bool shootPic,
      bool addNewItem, bool editListItem) async {
    final imageController = Get.find<CustomImageController>();

    final ImagePicker _picker = ImagePicker();

    XFile? image = await _picker.pickImage(
        source: shootPic ? ImageSource.camera : ImageSource.gallery);

    FirebaseStorage storage = FirebaseStorage.instance;

    int custPhone = Boxes.getUserCredentialsDB()
            .get('currentUserCredentials')
            ?.phoneNumber ??
        404;
    try {
      Reference ref = storage.ref().child("customItem/$custPhone-$imageName");
      File file = File(image?.path ?? '/DCIM/Camera');
      UploadTask uploadTask = ref.putFile(file);
      uploadTask.snapshotEvents.listen((event) {
        imageController.imageUploadProgress.value =
            '${event.bytesTransferred.toDouble() / event.totalBytes.toDouble()}';
      });

      final snapshot = await uploadTask.whenComplete(() => null);
      final urlDownload = await snapshot.ref.getDownloadURL();
      if (addNewItem) {
        imageController.addItemCustomImageUrl.value = urlDownload;
      } else if (editListItem) {
        imageController.listItemEditItemImageUrl.value = urlDownload;
      } else {
        imageController.editItemCustomImageUrl.value = urlDownload;
      }

      print('Download Url: $urlDownload');
      imageController.imageUploadProgress.value = '';

      successMsg('Upload Complete', 'Image Successfully Uploaded!');
      return urlDownload;
    } on FirebaseException catch (e) {
      print(e);
      return '';
    }

    // final TaskSnapshot downloadUrl = (await uploadTask);
    // final String url = downloadUrl.ref.getDownloadURL();
    // return url;
  }
}
