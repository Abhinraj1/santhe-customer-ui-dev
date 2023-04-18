import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import '../../../../core/blocs/ondc/ondc_order_cancel_and_return_bloc/ondc_order_cancel_and_return_bloc.dart';
import '../../../../core/cubits/upload_image_and_return_request_cubit/upload_image_and_return_request_cubit.dart';
import '../../../../core/cubits/upload_image_and_return_request_cubit/upload_image_and_return_request_state.dart';
import '../../../../core/cubits/upload_image_and_return_request_cubit/upload_image_and_return_request_state.dart';
import '../../../../manager/font_manager.dart';
import '../../../../widgets/custom_widgets/custom_button.dart';
import '../../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../../widgets/custom_widgets/home_icon_button.dart';
import '../../../../widgets/ondc_return_widgets/image_grid.dart';
import '../../../../widgets/ondc_widgets/error_container_widget.dart';
import '../../api_error/api_error_view.dart';

class ONDCOrderUploadPhotoScreenMobile extends StatelessWidget {

  const ONDCOrderUploadPhotoScreenMobile({Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String orderId = "0123456",
    //     productName = "Nescafe classic coffee jar",
    //     productDetails = "250gm , 1  units";

    return CustomScaffold(
        trailingButton: homeIconButton(),
        body:
        BlocConsumer<ONDCOrderCancelAndReturnReasonsBloc,
            ONDCOrderCancelAndReturnState>(

          listener: (context, state) {
            // TODO: implement listener

            if (state is OrderCancelErrorState) {

              print("ERROR### =${state.message}");
              Get.to(
                    () => const ApiErrorView(),
              );
            }

          },
          builder: (context, state) {
                  if (state is SelectedCodeForReturnState) {
                    String productName = state.returnProduct.title.toString(),
                        orderNumber = state.orderNumber.toString(),
                        quantity = "${state.returnProduct.quantity
                            .toString()} units";

                    return SingleChildScrollView(
                      child: Column(
                        children: [

                          const CustomTitleWithBackButton(
                            title: "Return Request",
                          ),
                          Text(
                            "Order ID  : $orderNumber",
                            style: FontStyleManager().s16fw700,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 40),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "You wish to return the following item: ",
                                style: FontStyleManager().s16fw500,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 40),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                productName,
                                style: FontStyleManager().s16fw700Brown,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                quantity,
                                style: FontStyleManager().s14fw500Brown,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text(
                              "Upload Pictures",
                              style: FontStyleManager().s16fw700,
                            ),
                          ),

                          const ImageGrid(),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Please upload at least one picture "
                                    "of the product showing any defects or damage",
                                style: FontStyleManager().s16fw500,
                              ),
                            ),
                          ),

                          BlocBuilder<
                              UploadImageAndReturnRequestCubit,
                              UploadImageAndReturnRequestState>(
                              builder: (context, state) {
                                if (state is ShowImages) {
                                  return CustomButton(
                                      buttonTitle: "RETURN ITEM",
                                      onTap: () {
                                        BlocProvider.of<
                                            UploadImageAndReturnRequestCubit>
                                          (context).uploadImages(context);
                                      },
                                      isActive: true,
                                      width: 160,
                                      verticalPadding: 20);
                                } else if(state is ImagesLimitReached) {
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const ErrorContainerWidget(
                                          message: "Please Select Maximum Of 4 Images"),

                                      CustomButton(
                                          buttonTitle: "RETURN ITEM",
                                          onTap: () {

                                          },
                                          isActive: false,
                                          width: 160,
                                          verticalPadding: 20),
                                    ],
                                  );
                                } else if(state is HideAddImagesButton){
                                  return CustomButton(
                                      buttonTitle: "RETURN ITEM",
                                      onTap: () {
                                        BlocProvider.of<
                                            UploadImageAndReturnRequestCubit>
                                          (context).uploadImages(context);
                                      },
                                      isActive: true,
                                      width: 160,
                                      verticalPadding: 20);

                                }else {
                                  return CustomButton(
                                      buttonTitle: "RETURN ITEM",
                                      onTap: () {},
                                      isActive: false,
                                      width: 160,
                                      verticalPadding: 20);
                                }
                              }
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }

          },
        ));
  }
}
