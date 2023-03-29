// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class GetAddressListEvent extends AddressEvent {}

class UpdateAddressEvent extends AddressEvent {
  final double lat;
  final double lng;
  final String address_id;
  final String flat;
  final String deliveryName;
  const UpdateAddressEvent(
      {required this.lat,
      required this.lng,
      required this.address_id,
      required this.flat,
      required this.deliveryName});
  @override
  List<Object?> get props => [lat, lng, address_id, flat, deliveryName];
}

class GetAddressListBillingEvent extends AddressEvent {}

class UpdateBillingAddressEvent extends AddressEvent {
  final double lat;
  final double lng;
  final String address_id;
  final String flat;
  final String deliveryName;
  const UpdateBillingAddressEvent({
    required this.lat,
    required this.lng,
    required this.address_id,
    required this.flat,
    required this.deliveryName,
  });
  @override
  List<Object?> get props => [lat, lng, address_id, flat, deliveryName];
}
