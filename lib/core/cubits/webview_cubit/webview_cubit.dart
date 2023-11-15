import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'webview_state.dart';

class WebviewCubit extends Cubit<WebviewState> {
  WebviewCubit() : super(WebviewInitial());



  webviewLoaded(){
    emit(WebviewLoadedState());
  }
}
