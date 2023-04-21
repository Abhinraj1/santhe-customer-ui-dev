import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as ge;
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:santhe/core/cubits/upload_image_and_return_request_cubit/upload_image_and_return_request_state.dart';
import 'package:santhe/pages/ondc/ondc_acknowledgement_screen/ondc_acknowledgement_view.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/ondc_order_details_view.dart';
import '../../../constants.dart';
import '../../../models/ondc/preview_ondc_cart_model.dart';
import '../../../models/ondc/single_order_model.dart';
import '../../../pages/ondc/ondc_customer_order_history_screen/ondc_order_history_view.dart';
import '../../../pages/ondc/ondc_return_screens/ondc_return_upload_photo_screen/ondc_return_upload_photo_screen_mobile.dart';
import '../../../pages/ondc/ondc_shop_list/ondc_shop_list_view.dart';
import '../../../utils/order_details_screen_routing_logic.dart';
import '../../repositories/ondc_checkout_repository.dart';
import '../../repositories/ondc_order_cancel_and_return_repository.dart';
import '../ondc_order_details_screen_cubit/ondc_order_details_screen_cubit.dart';



class UploadImageAndReturnRequestCubit extends Cubit<UploadImageAndReturnRequestState>{
  final ONDCOrderCancelAndReturnRepository repository;

  UploadImageAndReturnRequestCubit({required this.repository}) :
        super(InitialState());

  String _orderId = "";
  String _orderNumber = "";
  late PreviewWidgetModel _returnProduct;
  final ImagePicker _picker = ImagePicker();
  List<XFile?> imagesList = [];
  List<String> imageUrl = [];
  String _code = "";

  getPrerequisiteData({ required String orderId,
    required String orderNumber,
  required PreviewWidgetModel returnProduct,
    required String code,
  }){

    _orderId = orderId;
    _orderNumber = orderNumber;
    _returnProduct = returnProduct;
    _code = code;}




  getImagesFromGallery()async{

    // Pick an image
    final XFile? images = await _picker.pickImage(source: ImageSource.gallery);

    imagesList.add(images);


  if(imagesList.length.isEqual(4)){
     showImages(hideAddImgButton: true);

   }else if(imagesList.length.isGreaterThan(4)){
     imagesList.clear();
     emit(ImagesLimitReached());
   }else{
      showImages(hideAddImgButton: false);
    }


  }

  getImagesFromCamera()async{

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    imagesList.add(image);

    if(imagesList.length.isEqual(4)){
      showImages(hideAddImgButton: true);

    }else if(imagesList.length.isGreaterThan(4)){
      imagesList.clear();
      emit(ImagesLimitReached());
    }else{
      showImages(hideAddImgButton: false);
    }
  }

  showImages({bool? hideAddImgButton}){
    List<File> imageFiles = [File("do not remove")];
    for(var data in imagesList){

      if(data != null){
        imageFiles.add(File(data.path));
      }

    }

    if(hideAddImgButton ?? false){

      emit(HideAddImagesButton(imageFiles: imageFiles));

    }else{
      emit(ShowImages(imageFiles: imageFiles));
    }

  }

  uploadImages(BuildContext context) async{

    emit(LoadingState());

    for (var imgFile in imagesList) {

      try{

       String imgUrl = await repository.uploadImage(
           imgPath: imgFile!.path);

       imageUrl.add(imgUrl);

       print("####################################################"
           "IMAGE URL ADDED = ${imgUrl}");

      }catch(e){

        emit(UploadImageAndReturnRequestErrorState(message: e.toString()));

      }
    }
    imagesList.clear();
    sendReturnRequest();
    Get.to(()=> ONDCAcknowledgementView(
      title: "Return Request",
      message: "Your return request is received,"
          " Once we have received a confirmation "
          "from the seller you will get an update "
          "from us on the return  status and refund details",

      orderNumber: _orderNumber,

      onTap: (){
        BlocProvider.of<OrderDetailsScreenCubit>(context)
            .loadOrderDetails(
            orderId: _orderId);

        Get.offAll(()=> ONDCOrderDetailsView(
          onBackButtonTap: (){
            orderDetailsScreenRoutingLogic();
          },
        ),
        transition: ge.Transition.leftToRight);
      },));

  }



  sendReturnRequest() async{

    print("############################## sendReturnRequest calleddddd");
    try{
      print("############################## INSIDE TRY");

      print("############################## orderId = $_orderId "
          "########_code = $_code ########## CartPriceId = ${_returnProduct.status} "
          "####### quantity = ${_returnProduct.quantity}");


      String response = await repository.requestReturnOrPartialCancel(
          orderId: _orderId,
          code: _code,
          cartItemPricesId: _returnProduct.id,
          images: imageUrl,
          quantity: _returnProduct.quantity.toString(),
          isReturn: true
      );

      if(response == "SUCCESS"){
        Get.to(()=> ONDCAcknowledgementView(
          title: "Return Request",
          message: "Your return request is received,"
              " Once we have received a confirmation "
              "from the seller you will get an update "
              "from us on the return  status and refund details",

          orderNumber: _orderNumber,

          onTap: (){
            Get.offAll( ONDCOrderDetailsView(
              onBackButtonTap: (){
                orderDetailsScreenRoutingLogic();
                },
            ),
                transition: ge.Transition.leftToRight);
          },) );

      }
      emit(InitialState());

      print("####################################################"
          "RESPONSE AFTER RETURN REQUEST = $response");

    }catch(e){

      emit(UploadImageAndReturnRequestErrorState(message: e.toString()));

    }
  }

  clearImages(){
    imagesList.clear();
    imageUrl.clear();
  }
}