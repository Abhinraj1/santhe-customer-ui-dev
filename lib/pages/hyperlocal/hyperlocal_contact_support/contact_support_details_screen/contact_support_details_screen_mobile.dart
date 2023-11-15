import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_orders_model.dart' as model;
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/custom_title_with_back_button.dart';
import 'package:santhe/widgets/custom_widgets/table_generator.dart';

import '../../../../core/cubits/hyperlocal_deals_cubit/hyperlocal_contact_support_cubit/contact_support_cubit.dart';
import '../../../../core/repositories/hyperlocal_checkoutrepository.dart';
import '../../../../manager/font_manager.dart';
import '../../../../widgets/custom_widgets/custom_button.dart';
import '../../../../widgets/custom_widgets/home_icon_button.dart';
import '../../../../widgets/ondc_contact_support_widgets/images_list_textButton.dart';



class HyperlocalContactSupportDetailsScreenMobile extends StatefulWidget {
  final String supportId;
  const HyperlocalContactSupportDetailsScreenMobile({Key? key,
    required this.supportId})
      : super(key: key);

  @override
  State<HyperlocalContactSupportDetailsScreenMobile> createState() => _HyperlocalContactSupportDetailsScreenMobileState();
}

class _HyperlocalContactSupportDetailsScreenMobileState extends State<HyperlocalContactSupportDetailsScreenMobile> {
 
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ContactSupportCubit>(context).
    loadSupportTicketDetails(supportId: widget.supportId);
  }
  @override
  Widget build(BuildContext context) {

   model.OrderInfo orderInfo =  RepositoryProvider.of<
        HyperLocalCheckoutRepository>(
        context).orderInfo;

   model.OrderInfoSupport support = orderInfo.data!.support as model.OrderInfoSupport ;


    return CustomScaffold(
        trailingButton: homeIconButton(toHyperLocalHome: true),
        body: BlocBuilder<ContactSupportCubit, ContactSupportState>(
  builder: (context, state) {
    if(state is ContactSupportDetailsLoaded){
      support = state.support;
      return ListView(
        children: [
          const CustomTitleWithBackButton(
            title: 'Support Ticket',
          ),
          TableGenerator(
            horizontalPadding: 10,
            tableRows: [
              TableModel(
                  title: "Order ID :",
                  data:
                  RepositoryProvider.of<
                      HyperLocalCheckoutRepository>(
                      context).userOrderId),
              // TableModel(title: "Ticket ID :", data: support.id ?? "N/A"),
              TableModel(title:support.longDescription != null
                  ? "Description :" : ""),
            ],
          ),
          support.longDescription != null
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              support.longDescription.toString(),
              style: FontStyleManager().s14fw600Grey,
            ),
          )
              : const SizedBox(),

          // support.resolutionRemarks!= null ?
          // Padding(
          //   padding:
          //   const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          //   child: Text(
          //     "Request update notes:",
          //     style: FontStyleManager().s14fw600Grey,
          //   ),
          // ) :
          // SizedBox(),
          // support.resolutionRemarks!= null ?
          // Padding(
          //   padding:
          //   const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          //   child: Text(
          //     support.resolutionRemarks.toString(),
          //     style: FontStyleManager().s14fw600Grey,
          //   ),
          // ) :
          // const SizedBox(),

          TableGenerator(
            horizontalPadding: 10,
            tableRows: [
              TableModel(
                  title: "Status :",
                  data: support.supportState.first.title ?? "N/A",
                  dataTextStyle: FontStyleManager().s14fw800Grey),
              TableModel(
                  title: "Resolution :",
                  data: support.resolution ?? "N/A",
                  dataTextStyle: FontStyleManager().s14fw800Grey),
              TableModel(
                  title: support.resolutionRemarks != null
                      ? "Resolution Remarks :"
                      : "")
            ],
          ),
          support.resolutionRemarks != null
              ? Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Text(
              support.resolutionRemarks.toString(),
              style: FontStyleManager().s14fw800Grey,
            ),
          )
              : const SizedBox(),


          CustomButton(
            verticalPadding: 20,
            onTap: () {
              Navigator.pop(context);
            },
            buttonTitle: "BACK",
            width: 180,
          ),
          // _showRequestUpdateButton(support: support) ?
          // CustomButton(
          //   verticalPadding: 10,
          //   isActive: false,
          //   onTapEvenIfActiveIsFalse: true,
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   buttonTitle: "REQUEST UPDATE",
          //   width: 180,
          // ) :
          //     const SizedBox(),

          support.supportState.first.title.toString().contains("Resolved") ?
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Text(
              "*This ticket will be closed after 24 hours",
              style: FontStyleManager().s14fw400ItalicGrey,
              textAlign: TextAlign.left,
            ),
          ) : const SizedBox(),

          const SizedBox(
            height: 30,
          )
        ],
      );

    }else{
      return const Center(child: CircularProgressIndicator(),);
    }
  },
));
  }

  bool _showRequestUpdateButton({required model.OrderInfoSupport support}){
    DateTime createdAt = DateTime.parse(support.createdAt.toString());
    DateTime today = DateTime.now();

    if(today.isAfter(createdAt.add(const Duration(days: 2))) &&
        support.status.toString() != "Resolved"){
      return true;

    }else{
      return false;
    }
  }
}
