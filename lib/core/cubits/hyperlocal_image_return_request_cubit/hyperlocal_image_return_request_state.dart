// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'hyperlocal_image_return_request_cubit.dart';

abstract class HyperlocalImageReturnRequestState extends Equatable {
  const HyperlocalImageReturnRequestState();

  @override
  List<Object> get props => [];
}

class HyperlocalImageReturnRequestInitial
    extends HyperlocalImageReturnRequestState {}

class HyperlocalImageLoadingState extends HyperlocalImageReturnRequestState {}

class HyperlocalReturnImagesLimitReachedState
    extends HyperlocalImageReturnRequestState {}

class HyperlocalHideAddImagesButtonState
    extends HyperlocalImageReturnRequestState {
  final List<File> imageFiles;
  const HyperlocalHideAddImagesButtonState({
    required this.imageFiles,
  });
  @override
  List<Object> get props => [imageFiles];
}

class HyperlocalReturnRequestSuccessState
    extends HyperlocalImageReturnRequestState {}

class HyperlocalReturnRequestLoadingState
    extends HyperlocalImageReturnRequestState {}

class HyperlocalReturnRequestErrorState
    extends HyperlocalImageReturnRequestState {
  final String message;
  const HyperlocalReturnRequestErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class HyperlocalShowReturnImagesState
    extends HyperlocalImageReturnRequestState {
  final List<File> imageFiles;
  const HyperlocalShowReturnImagesState({
    required this.imageFiles,
  });
  @override
  List<Object> get props => [imageFiles];
}

class HyperlocalUploadImagesSuccessState
    extends HyperlocalImageReturnRequestState {
  late List<String> imageUrls;
  HyperlocalUploadImagesSuccessState({required this.imageUrls});
  @override
  List<Object> get props => [imageUrls];
}

class HyperlocalUploadImagesAndReturnErrorState
    extends HyperlocalImageReturnRequestState {
  final String message;
  const HyperlocalUploadImagesAndReturnErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
