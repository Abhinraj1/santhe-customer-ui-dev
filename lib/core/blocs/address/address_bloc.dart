// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:santhe/core/repositories/address_repository.dart';
import 'package:santhe/models/ondc/address_ondc_model.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository addressRepository;

  AddressBloc({required this.addressRepository}) : super(AddressInitial()) {
    on<AddressEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<UpdateAddressEvent>((event, emit) async {
      try {
        final String message = await addressRepository.updateAddress(
          lat: event.lat,
          lng: event.lng,
          flat: event.flat,
          deliveryName: event.deliveryName.toString(),
          address_id: event.address_id,
        );
        emit(OndcAddressUpdatedState(message: message));
      } on OndcUpdateAddressErrorState catch (e) {
        emit(
          OndcUpdateAddressErrorState(message: e.message),
        );
      }
    });

    on<UpdateBillingAddressEvent>((event, emit) async {
      emit(OndcBillingAddressLoading());
      try {
        final String message = await addressRepository.updateAddress(
          lat: event.lat,
          lng: event.lng,
          flat: event.flat,
          deliveryName: event.deliveryName.toString(),
          address_id: event.address_id,
        );
        emit(OndcBillingAddressUpdated(message: message));
      } on OndcUpdateAddressErrorState catch (e) {
        emit(
          OndcUpdateAddressErrorState(message: e.message),
        );
      }
    });

    on<GetAddressListEvent>((event, emit) async {
      try {
        await addressRepository.getAddressList();
        emit(GotAddressListAndIdState());
      } on ErrorGettingAddressState catch (e) {
        emit(
          ErrorGettingAddressState(message: e.message),
        );
      }
    });
    on<GetAddressListBillingEvent>((event, emit) async {
      emit(OndcBillingAddressLoading());
      try {
        await addressRepository.getAddressList();
        emit(GotAddressListBillingState());
      } on ErrorGettingAddressState catch (e) {
        emit(
          ErrorGettingAddressState(message: e.message),
        );
      }
    });
    on<ResetAddressEvent>((event, emit) {
      emit(AddressInitial());
    });
  }
}
