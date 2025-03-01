import 'package:flutter/material.dart';
import 'package:santhe/utils/check_refund_amount.dart';

import '../../../../manager/font_manager.dart';
import '../../models/ondc/single_order_model.dart';
import '../../utils/priceFormatter.dart';


class InvoiceTable extends StatelessWidget {

  final List<FinalCosting> prices;
  final String totalPrice;
  final String amountInCents;



  const InvoiceTable({Key? key,
    required this.prices, required this.totalPrice,
    required this.amountInCents
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
      child: SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
           itemCount: prices.length,
            itemBuilder: (context,index){

            if(index == prices.length-1)
            {
              return Column(
                children: [
                  customRow(
                      title: "Total:",
                      data: "₹$totalPrice",
                      isTotalPrice: true
                  ),
                 checkRefundAmount(
                     amountInCents: amountInCents,
                     totalAmount: totalPrice
                 ) != false ?
                 customRow(
                     isTotalPrice: true,
                     title: "Refunded Amount",
                      data: checkRefundAmount(
                          amountInCents: amountInCents,
                          totalAmount: totalPrice
                      )) :
                     SizedBox()
                ],
              );
            }else if(prices[index].lable.
            toString().contains("Tax")){
              if(prices[index].value.toString() != "0"){
                return customRow(title: prices[index].lable.toString(),
                    data: "₹${prices[index].value.
                    toString()}");
              }else{
                return const SizedBox();
              }
            }else{
              return customRow(title: prices[index].lable.toString(),
                  data: "₹${prices[index].value.
                  toString()}");
            } }),
      )

    );
  }

Widget customRow({
  required String title,
  required String data,
  bool? isTotalPrice}){

    return
      SizedBox(
      height: 25,
      child: Row(
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: [

        Text(priceFormatter(value:title),
          style: isTotalPrice ?? false ?
            FontStyleManager().s18fw700Orange :
            FontStyleManager().s14fw800Grey,),
                  Text(data,style: isTotalPrice ?? false ?
                        FontStyleManager().s20fw700Orange:
                        FontStyleManager().s16fw700Brown,
                      textAlign: TextAlign.right),

        ],
      ),
    );
}

}

