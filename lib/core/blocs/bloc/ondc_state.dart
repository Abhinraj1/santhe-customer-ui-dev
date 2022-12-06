part of 'ondc_bloc.dart';

abstract class OndcState extends Equatable {
  const OndcState();
  
  @override
  List<Object> get props => [];
}

class OndcInitial extends OndcState {}
