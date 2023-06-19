import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/hyperlocal_cancel_return_repo.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_cancel.dart';

part 'hyperlocal_cancel_return_event.dart';
part 'hyperlocal_cancel_return_state.dart';

class HyperlocalCancelReturnBloc
    extends Bloc<HyperlocalCancelReturnEvent, HyperlocalCancelReturnState>
    with LogMixin {
  final HyperlocalCancelReturnRepository hyperlocalCancelReturnRepository;
  HyperlocalCancelReturnBloc({required this.hyperlocalCancelReturnRepository})
      : super(HyperlocalCancelReturnInitial()) {
    on<HyperlocalCancelReturnEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ResetHyperlocalCancelReasonEvent>(
      (event, emit) => emit(
        HyperlocalCancelReturnInitial(),
      ),
    );
    on<GetHyperlocalCancelReasonsEvent>((event, emit) async {
      emit(GetHyperlocalCancelReasonsLoadingState());
      try {
        List<HyperlocalCancelModel> cancelModels = [];
        cancelModels = await hyperlocalCancelReturnRepository.getCancelReason();
        emit(GetHyperlocalCancelReasonsState(cancelReasons: cancelModels));
      } on GetHyperlocalCancelReasonsErrorState catch (e) {
        emit(GetHyperlocalCancelReasonsErrorState(message: e.message));
      }
    });
    on<GetHyperlocalReturnReasonsEvent>((event, emit) async {
      emit(GetHyperlocalReturnReasonsLoadingState());
      try {
        List<HyperlocalCancelModel> returnModels = [];
        returnModels =
            await hyperlocalCancelReturnRepository.getReturnReasons();
        emit(
            GetHyperlocalReturnReasonsSuccessState(returnModels: returnModels));
      } on GetHyperlocalReturnReasonsErrorState catch (e) {
        emit(GetHyperlocalReturnReasonsErrorState(message: e.message));
      }
    });
    on<PostHyperlocalCancelReasonsEvent>((event, emit) async {
      emit(PostHyperlocalCancelReasonLoadingState());
      try {
        await hyperlocalCancelReturnRepository.postcancelReason(
            reason: event.reason, orderId: event.orderID);
        emit(PostHyperlocalCancelReasonSuccessState(cancelled: true));
      } on PostHyperlocalCancelReasonErrorState catch (e) {
        emit(GetHyperlocalCancelReasonsErrorState(message: e.message));
      }
    });
  }
}
