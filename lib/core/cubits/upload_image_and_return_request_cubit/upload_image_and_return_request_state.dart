



import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class UploadImageAndReturnRequestState{}

class InitialState extends UploadImageAndReturnRequestState{}

class LoadingState extends UploadImageAndReturnRequestState{}

class ImagesLimitReached extends UploadImageAndReturnRequestState{}

class HideAddImagesButton extends UploadImageAndReturnRequestState{
  final List<File> imageFiles;

  HideAddImagesButton({required this.imageFiles});
}

class ShowImages extends UploadImageAndReturnRequestState{
  final List<File> imageFiles;

  ShowImages({required this.imageFiles});
}

///class RequestReturn extends UploadImageAndReturnRequestState{}

class UploadImageAndReturnRequestErrorState extends
UploadImageAndReturnRequestState{
  final String message;
  UploadImageAndReturnRequestErrorState({required this.message});
}