import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'scroll_event.dart';
part 'scroll_state.dart';

class ScrollBloc extends Bloc<ScrollEvent, ScrollState> {
  ScrollBloc() : super(ScrollInitial()) {
    on<ScrollEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
