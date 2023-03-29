import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/models/ondc/order_cancel_reasons_model.dart';
import '../../../core/blocs/ondc/ondc_order_cancel_and_return_bloc/ondc_order_cancel_and_return_bloc.dart';
import '../../../core/cubits/upload_image_and_return_request_cubit/upload_image_and_return_request_cubit.dart';
import '../../../manager/font_manager.dart';
import '../../../widgets/custom_widgets/customScaffold.dart';
import '../../../widgets/custom_widgets/custom_button.dart';
import '../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../widgets/custom_widgets/home_icon_button.dart';
import '../../../widgets/ondc_return_widgets/return_reasons_listTile.dart';
import '../api_error/api_error_view.dart';
import '../ondc_return_screens/ondc_return_upload_photo_screen/ondc_return_upload_photo_screen_mobile.dart';


class ONDCReasonsScreenMobile extends StatelessWidget {
  const ONDCReasonsScreenMobile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      trailingButton: homeIconButton(),
      body: BlocConsumer<ONDCOrderCancelAndReturnReasonsBloc,
          ONDCOrderCancelAndReturnState>(
        listener: (context, state) {
          if(state is OrderCancelErrorState){
            Get.to(
                  () => const ApiErrorView(),
            );
          }
          // TODO: implement listener
        },
        builder: (context, state) {

                if (state is ReasonsLoadedFullOrderCancelState) {
                  return body(
                      title: "Cancel Order",
                      orderNumber: state.orderNumber,
                      reasons: state.reasons,
                      onTap: () {},
                      isActive: false);
                } else if (state is ReasonsLoadedPartialOrderCancelState) {
                  return body(
                      title: "Cancel Order",
                      orderNumber: state.orderNumber,
                      reasons: state.reasons,
                      onTap: () {},
                      isActive: false,
                  isPartialCancel: true);

                } else if (state is SelectedCodeState) {
                  return body(
                      title: "Cancel Order",
                      orderNumber: state.orderNumber,
                      reasons: state.reasons,
                      onTap: () {
                        BlocProvider.of<ONDCOrderCancelAndReturnReasonsBloc>(
                            context)
                            .add(CancelFullOrderRequestEvent());
                      },
                      isActive: true);
                } else if (state is OrderCancelErrorState) {
                  return Center(child: Text(state.message));

                } else if (state is ReasonsLoadedForReturnState) {
                  return body(
                      title: "Return Request",
                      orderNumber: state.orderNumber,
                      reasons: state.reasons,
                      onTap: () {},
                      isActive: false,
                      isReturn: true
                  );
                }
                else if (state is SelectedCodeForReturnState) {
                  return body(
                      title: "Return Request",
                      orderNumber: state.orderNumber,
                      reasons: state.reasons,
                      onTap: () {

                        ///for Return && Navigate to upload image Screen
                        Get.to(() => const ONDCOrderUploadPhotoScreenMobile());
                      },
                      isActive: true,
                      isReturn: true

                  );
                } else if (state is SelectedCodeForPartialOrderCancelState) {
                  return body(
                      title: "Cancel Order",
                      orderNumber: state.orderNumber,
                      reasons: state.reasons,
                      onTap: () {
                        BlocProvider.of<ONDCOrderCancelAndReturnReasonsBloc>(
                            context)
                            .add(PartialCancelOrderRequestEvent());
                      },
                      isActive: true,
                      isPartialCancel: true,
                  );
                }else {

                  return const Center(child: CircularProgressIndicator());
                }

        },
      ),
    );
  }

  Widget body({required String orderNumber,
    required String title,
    required List<ReasonsModel> reasons,
    required bool isActive,
    required Function() onTap,
    bool? isReturn,
  bool? isPartialCancel}) {
    return Column(
      children: [
        CustomTitleWithBackButton(
          title: title,
        ),
        Text(
          "Order ID  : $orderNumber",
          style: FontStyleManager().s16fw700,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "All items in your order will be cancelled."
                  " Please select a reason for cancelling your order",
              style: FontStyleManager().s16fw500,
            ),
          ),
        ),
        SizedBox(
          height: 210,
          child: ReturnReasonsListTile(
            reasons: reasons,
            isReturn: isReturn ?? false,
            isPartialCancel: isPartialCancel ?? false,
          ),
        ),
        CustomButton(
          onTap: () {
            if (isActive) {
              onTap();
            }
          },
          buttonTitle: "NEXT",
          isActive: isActive,
          width: 200,
        )
      ],
    );
  }
}
