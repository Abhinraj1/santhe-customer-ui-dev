



import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class UploadImageAndReturnRequestState{}

class InitialState extends UploadImageAndReturnRequestState{}

///class GetImages extends UploadImageAndReturnRequestState{}


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