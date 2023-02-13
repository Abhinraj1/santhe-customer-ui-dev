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

class GotAddressListAndIdState extends AddressState {}

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
