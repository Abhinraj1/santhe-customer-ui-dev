part of 'tutorial_cubit.dart';

@immutable
abstract class TutorialState {}

class TutorialInitial extends TutorialState {}

class TutorialLoadingState extends TutorialState {}

class TutorialLoadedState extends TutorialState {
 final List<TutorialLinkModel> linkList;
 TutorialLoadedState({required this.linkList});
}

class TutorialErrorState extends TutorialState {
 final String message;
  TutorialErrorState({required this.message});
}

