import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ondc_event.dart';
part 'ondc_state.dart';

class OndcBloc extends Bloc<OndcEvent, OndcState> {
  OndcBloc() : super(OndcInitial()) {
    on<OndcEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
