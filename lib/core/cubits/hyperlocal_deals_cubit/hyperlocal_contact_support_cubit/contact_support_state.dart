part of 'contact_support_cubit.dart';

@immutable
abstract class ContactSupportState {}

class ContactSupportInitial extends ContactSupportState {}

class ContactSupportLoading extends ContactSupportState {}

class ContactSupportErrorState extends ContactSupportState {}

