// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'hyperlocal_cancel_return_bloc.dart';

abstract class HyperlocalCancelReturnState extends Equatable {
  const HyperlocalCancelReturnState();

  @override
  List<Object> get props => [];
}

class HyperlocalCancelReturnInitial extends HyperlocalCancelReturnState {}

class GetHyperlocalCancelReasonsState extends HyperlocalCancelReturnState {
  List<HyperlocalCancelModel> cancelReasons = [];
  GetHyperlocalCancelReasonsState({
    required this.cancelReasons,
  });
  @override
  List<Object> get props => [cancelReasons];
}

class GetHyperlocalCancelReasonsErrorState extends HyperlocalCancelReturnState {
  final String message;
  const GetHyperlocalCancelReasonsErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class GetHyperlocalCancelReasonsLoadingState
    extends HyperlocalCancelReturnState {}

class PostHyperlocalCancelReasonLoadingState
    extends HyperlocalCancelReturnState {}

class PostHyperlocalCancelReasonSuccessState
    extends HyperlocalCancelReturnState {
  late bool cancelled;
  PostHyperlocalCancelReasonSuccessState({required this.cancelled});
  @override
  List<Object> get props => [cancelled];
}

class PostHyperlocalCancelReasonErrorState extends HyperlocalCancelReturnState {
  final String message;
  const PostHyperlocalCancelReasonErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
