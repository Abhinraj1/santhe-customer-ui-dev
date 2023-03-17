
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:santhe/core/cubits/upload_image_and_return_request_cubit/upload_image_and_return_request_state.dart';
import '../../../models/ondc/single_order_model.dart';
import '../../../pages/ondc/ondc_return_screens/ondc_return_upload_photo_screen/ondc_return_upload_photo_screen_mobile.dart';
import '../../repositories/ondc_order_cancel_and_return_repository.dart';



class UploadImageAndReturnRequestCubit extends Cubit<UploadImageAndReturnRequestState>{
  final ONDCOrderCancelAndReturnRepository repository;

  UploadImageAndReturnRequestCubit({required this.repository}) :
        super(InitialState());

  String _orderId = "";
  String _orderNumber = "";
  late CartItemPrices _returnProduct;
  final ImagePicker _picker = ImagePicker();
  List<XFile?> imagesList = [];
  List<String> imageUrl = [];

  getPrerequisiteData({ required String orderId,
    required String orderNumber,
  required CartItemPrices returnProduct
  }){



    _orderId = orderId;
    _orderNumber = orderNumber;
    _returnProduct = returnProduct;

    Get.to(()=>const ONDCOrderUploadPhotoScreenMobile());

  }

  getImagesFromGallery()async{

    // Pick an image
    final List<XFile?> images = await _picker.pickMultiImage();

    images.forEach((image) {
      imagesList.add(image);
    });


    showImages();

  }

  getImagesFromCamera()async{

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    imagesList.add(image);

    showImages();
  }

  showImages(){
    List<File> imageFiles = [File("do not remove")];
    for(var data in imagesList){

      if(data != null){
        imageFiles.add(File(data.path));
      }

    }

    emit(ShowImages(imageFiles: imageFiles));
  }

  uploadImages() async{

    imagesList.forEach((imgFile) async{

      print("######################### openRead ##################### "
          "${ imgFile!.openRead()}");

      // print("######################### readAsBytes "
      //     "##################### ${imgFile!.readAsBytes().toString()}");


      try{

       String imgUrl = await repository.uploadImage(
            imgPath: imgFile.path);

       imageUrl.add(imgUrl);

      }catch(e){

        emit(UploadImageAndReturnRequestErrorState(message: e.toString()));

      }
    });
    imagesList.clear();
  }

  sendReturnRequest(){


  }

}