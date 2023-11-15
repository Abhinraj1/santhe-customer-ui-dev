// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

class OndcAddressUpdatedState extends AddressState {
  final String message;
  const OndcAddressUpdatedState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class OndcBillingAddressUpdated extends AddressState {
  final String message;
  const OndcBillingAddressUpdated({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class GotAddressListAndIdState extends AddressState {}

class GotAddressListBillingState extends AddressState {}

class OndcBillingAddressLoading extends AddressState {}

class ErrorGettingAddressState extends AddressState {
  final String message;
  const ErrorGettingAddressState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class OndcUpdateAddressErrorState extends AddressState {
  final String message;
  const OndcUpdateAddressErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
