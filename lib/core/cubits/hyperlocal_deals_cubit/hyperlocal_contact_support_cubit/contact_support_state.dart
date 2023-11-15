part of 'contact_support_cubit.dart';

@immutable
abstract class ContactSupportState {}

class ContactSupportInitial extends ContactSupportState {}

class ContactSupportLoading extends ContactSupportState {}

class ContactSupportDetailsLoaded extends ContactSupportState {
  final OrderInfoSupport support;
  ContactSupportDetailsLoaded({required this.support});

}

class ContactSupportErrorState extends ContactSupportState {}

