import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/ondc/ondc_order_cancel_bloc/ondc_order_cancel_bloc.dart';
import 'package:santhe/models/ondc/order_cancel_reasons_model.dart';
import '../../../../manager/font_manager.dart';
import '../../../../widgets/custom_widgets/customScaffold.dart';
import '../../../../widgets/custom_widgets/custom_button.dart';
import '../../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../../widgets/custom_widgets/home_icon_button.dart';
import '../../../../widgets/ondc_return_widgets/return_reasons_listTile.dart';

class ONDCFullOrderCancelScreen extends StatelessWidget {
  const ONDCFullOrderCancelScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return CustomScaffold(
      trailingButton: homeIconButton(),
      body:
      BlocBuilder<ONDCOrderCancelBloc, ONDCOrderCancelState>(
        builder: (context, state) {

      if(state is ReasonsLoadedFullOrderCancelState){
        return body(
            orderNumber: state.orderNumber,
            reasons: state.reasons,
            onTap: (){},
            isActive: false);

        }else if (state is ReasonsLoadedSingleOrderCancelState){
        return body(
            orderNumber: state.orderNumber,
            reasons: state.reasons,
            onTap: (){},
            isActive: false);

      }else if (state is SelectedCodeState){
        return body(
            orderNumber: state.orderNumber,
            reasons: state.reasons,
            onTap: (){
              BlocProvider.of<ONDCOrderCancelBloc>(context).add(CancelFullOrderRequestEvent());
            },
            isActive: true);

      }else if(state is OrderCancelErrorState) {
        return Center(child: Text(state.message));
      }else{
        return const Center(child: CircularProgressIndicator());
      }
        }
      ),
    );
  }
  Widget body({
    required String orderNumber,
    required List<ReasonsModel> reasons,
    required bool isActive,
    required Function() onTap }){

    return
      Column(
      children: [
        const CustomTitleWithBackButton(
          title: "Cancel Order",
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
          child:
          ReturnReasonsListTile(
            reasons: reasons,
          ),
        ),
        CustomButton(
          onTap: () {

            if(isActive){
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
