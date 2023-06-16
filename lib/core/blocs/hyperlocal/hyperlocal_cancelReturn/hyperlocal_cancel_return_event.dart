// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'hyperlocal_cancel_return_bloc.dart';

abstract class HyperlocalCancelReturnEvent extends Equatable {
  const HyperlocalCancelReturnEvent();

  @override
  List<Object> get props => [];
}

class GetHyperlocalCancelReasonsEvent extends HyperlocalCancelReturnEvent {}

class PostHyperlocalCancelReasonsEvent extends HyperlocalCancelReturnEvent {
  final String orderID;
  final String reason;

  const PostHyperlocalCancelReasonsEvent({
    required this.orderID,
    required this.reason,
  });
  @override
  List<Object> get props => [orderID, reason];
}

class ResetHyperlocalCancelReasonEvent extends HyperlocalCancelReturnEvent {}
