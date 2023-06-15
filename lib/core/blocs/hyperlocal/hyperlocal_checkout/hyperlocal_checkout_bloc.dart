import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/hyperlocal_checkoutrepository.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_paymentmodel.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_previewmodel.dart';

part 'hyperlocal_checkout_event.dart';
part 'hyperlocal_checkout_state.dart';

class HyperlocalCheckoutBloc
    extends Bloc<HyperlocalCheckoutEvent, HyperlocalCheckoutState>
    with LogMixin {
  final HyperLocalCheckoutRepository hyperLocalCheckoutRepository;
  HyperlocalCheckoutBloc({required this.hyperLocalCheckoutRepository})
      : super(HyperlocalCheckoutInitial()) {
    on<HyperlocalCheckoutEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetOrderInfoEvent>((event, emit) async {
      emit(GetOrderInfoLoadingState());
      try {
        final List<HyperLocalPreviewModel> previewModels =
            await hyperLocalCheckoutRepository.getOrderdetails(
                orderId: event.orderId);
        emit(
          GetOrderInfoSuccessState(hyperLocalPreviewModels: previewModels),
        );
      } on GetOrderInfoErrorState catch (e) {
        emit(
          GetOrderInfoErrorState(message: e.message),
        );
      }
    });
    on<GetOrderInfoPostEvent>((event, emit) async {
      emit(GetOrderInfoPostLoadingState());
      try {
        final String orderIdBloc = await hyperLocalCheckoutRepository
            .postOrderInfo(storeDescriptionId: event.storeDescription_id);
        warningLog('OrderId $orderIdBloc');
        emit(GetOrderInfoPostSuccessState(orderId: orderIdBloc));
      } on GetOrderInfoPostErrorState catch (e) {
        emit(GetOrderInfoErrorState(message: e.message));
      }
    });
    on<PostPaymentCheckoutEvent>((event, emit) async {
      emit(PostPaymentHyperlocalLoadingState());
      try {
        final HyperlocalPaymentInfoModel paymentInfoModel =
            await hyperLocalCheckoutRepository.postPaymentCheckout(
                orderIdRec: event.orderId);
        emit(PostPaymentHyperlocalSuccessState(
            hyperlocalPaymentInfo: paymentInfoModel));
      } on PostPaymentHyperlocalErrorState catch (e) {
        emit(PostPaymentHyperlocalErrorState(message: e.message));
      }
    });
    on<VerifyPaymentEventHyperlocal>((event, emit) async {
      emit(VerifyPaymentHyperlocalLoadingState());
      try {
        final String message = await hyperLocalCheckoutRepository.verifyPayment(
            razorPayOrderID: event.razorPayOrderId,
            razorPayPaymentId: event.razorPayPaymentId,
            razorPaySignature: event.razorPaySignature);
        emit(
          VerifyPaymentHyperlocalSuccessState(message: message),
        );
      } on VerifyPaymentHyperlocalErrorState catch (e) {
        emit(VerifyPaymentHyperlocalErrorState(message: e.message));
      }
    });
  }
}
