import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../models/tutorial_link_model.dart';
import '../../repositories/hyperlocal_repository.dart';
part 'tutorial_state.dart';

class TutorialCubit extends Cubit<TutorialState> {
  final HyperLocalRepository repo;
  TutorialCubit({required this.repo}) : super(TutorialInitial());

  getLinks()async{
    try{
      emit(TutorialLoadingState());
      List<TutorialLinkModel> list = await repo.getTutorialLinks();
      emit(TutorialLoadedState(linkList: list));

    }catch(e){
      emit(TutorialErrorState(message: e.toString()));
    }
  }
}
