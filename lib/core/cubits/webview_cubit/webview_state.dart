part of 'webview_cubit.dart';

@immutable
abstract class WebviewState {}

class WebviewInitial extends WebviewState {}

class WebviewLoadingState extends WebviewState {}

class WebviewLoadedState extends WebviewState {}