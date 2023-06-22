// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/core/loggers.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../models/hyperlocal_models/hyperlocal_previewmodel.dart';
import '../../repositories/hyperlocal_cancel_return_repo.dart';

part 'hyperlocal_image_return_request_state.dart';

class HyperlocalImageReturnRequestCubit
    extends Cubit<HyperlocalImageReturnRequestState> with LogMixin {
  final HyperlocalCancelReturnRepository repository;
  HyperlocalImageReturnRequestCubit({required this.repository})
      : super(HyperlocalImageReturnRequestInitial());
  String _orderId = "";
  String _orderNumber = "";
  late HyperLocalPreviewModel _returnProduct;
  final ImagePicker _picker = ImagePicker();
  List<XFile?> imagesList = [];
  List<String> imageUrl = [];
  bool? returnedLoc;

  int thresholdSizeInBytes = 300000;
  int compressedQuality = 50;

  getPrerequisiteData({
    required String orderId,
    required String orderNumber,
    required HyperLocalPreviewModel returnProduct,
    required String code,
  }) {
    _orderId = orderId;
    _orderNumber = orderNumber;
    _returnProduct = returnProduct;
  }

  Future<XFile?> checkImageSize({required XFile? file}) async {
    int bytes = File(file!.path).lengthSync();

    print("============= bytes = $bytes   \n");

    var basename = file.name; //path.basenameWithoutExtension(file.path);
    print("============= basename = $basename   \n");

    var pathString = file.path.replaceAll(basename, "");

    print("============= pathString = $pathString   \n");

    var pathStringWithExtension = "$pathString${basename}_image.jpg";

    ///const suffixes = ["b", "kb", "mb", "gb", "tb"];

    print(
        "============= pathStringWithExtension = $pathStringWithExtension \n");

    if (bytes >= thresholdSizeInBytes) {
      return await compressFile(File(file.path), pathStringWithExtension);
    } else {
      return file;
    }
  }

  Future<XFile?> compressFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path, targetPath,
      quality: compressedQuality,
      //rotate: 180,
    );
    // print(
    //     "=========bytes==== AFTER COMPRESSION = ${File(result!.path).lengthSync()}   \n");
    return result;
  }

  getImagesFromGallery() async {
    // Pick an image
    final XFile? images = await _picker.pickImage(source: ImageSource.gallery);
    final XFile? finalImage = await checkImageSize(file: images);
    imagesList.add(finalImage);

    if (imagesList.length.isEqual(4)) {
      showImages(hideAddImgButton: true);
    } else if (imagesList.length.isGreaterThan(4)) {
      imagesList.clear();
      emit(HyperlocalReturnImagesLimitReachedState());
    } else {
      showImages(hideAddImgButton: false);
    }
  }

  getImagesFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    final XFile? finalImage = await checkImageSize(file: image);
    imagesList.add(finalImage);
    if (imagesList.length.isEqual(4)) {
      showImages(hideAddImgButton: true);
    } else if (imagesList.length.isGreaterThan(4)) {
      imagesList.clear();
      emit(HyperlocalReturnImagesLimitReachedState());
    } else {
      showImages(hideAddImgButton: false);
    }
  }

  showImages({bool? hideAddImgButton}) {
    List<File> imageFiles = [File("do not remove")];
    for (var data in imagesList) {
      if (data != null) {
        imageFiles.add(File(data.path));
      }
    }

    if (hideAddImgButton ?? false) {
      emit(HyperlocalHideAddImagesButtonState(imageFiles: imageFiles));
    } else {
      emit(HyperlocalShowReturnImagesState(imageFiles: imageFiles));
    }
  }

  uploadImages(
      {required BuildContext context,
      required String reason,
      required String orderItemId}) async {
    emit(HyperlocalImageLoadingState());
    errorLog('Image list $imagesList');
    for (var imgFile in imagesList) {
      try {
        warningLog('single image file $imgFile and path ${imgFile!.path}');
        String imgUrl = await repository.uploadImage(imgPath: imgFile!.path);
        imageUrl.add(imgUrl);
        errorLog("####################################################"
            "IMAGE URL ADDED = $imgUrl");
        emit(HyperlocalUploadImagesSuccessState(imageUrls: imageUrl));
      } catch (e) {
        emit(HyperlocalUploadImagesAndReturnErrorState(message: e.toString()));
      }
    }
    postReturnReasons(
        reason: reason, images: imageUrl, orderItemId: orderItemId);
    imagesList.clear();
    // sendReturnRequest();
    // Get.to(() => ONDCAcknowledgementView(
    //       title: "Return Request",
    //       message: "Your return request is received,"
    //           " Once we have received a confirmation "
    //           "from the seller you will get an update "
    //           "from us on the return  status and refund details",
    //       orderNumber: _orderNumber,
    //       onTap: () {
    //         BlocProvider.of<OrderDetailsScreenCubit>(context)
    //             .loadOrderDetails(orderId: _orderId);

    //          Get.close(3);
    //       },
    //     ));
  }

  postReturnReasons(
      {required String reason,
      required List<String> images,
      required String orderItemId}) async {
    final url =
        Uri.parse('https://ondcstaging.santhe.in/santhe/hyperlocal/return');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    emit(HyperlocalReturnRequestLoadingState());
    try {
      final response = await http.post(
        url,
        headers: header,
        body: json.encode(
          {"orderItem_id": orderItemId, "reason": reason, "imagesArr": images},
        ),
      );
      warningLog('Post Return reason ${response.statusCode}');
      final responseBody = json.decode(response.body);
      warningLog('POst return Reason $responseBody');
      emit(HyperlocalReturnRequestSuccessState());
    } catch (e) {
      emit(
        HyperlocalReturnRequestErrorState(
          message: e.toString(),
        ),
      );
    }
  }

  clearImages() {
    imagesList.clear();
    imageUrl.clear();
  }

  // getImageString() async {
  //   emit(LoadingState());

  //   for (var imgFile in imagesList) {
  //     try {
  //       String imgUrl = await repository.uploadImage(imgPath: imgFile!.path);

  //       imageListForContactSupport.add(imgUrl);

  //       isImageLoading.value = false;

  //       print("####################################################"
  //           "IMAGE URL ADDED = ${imgUrl}");
  //     } catch (e) {
  //       emit(UploadImageAndReturnRequestErrorState(message: e.toString()));
  //     }
  //   }
  //   imagesList.clear();
  // }
}
