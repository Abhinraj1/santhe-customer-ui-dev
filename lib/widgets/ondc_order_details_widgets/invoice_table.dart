import 'package:flutter/material.dart';

import '../../../../manager/font_manager.dart';
import '../../models/ondc/single_order_model.dart';


class InvoiceTable extends StatelessWidget {

  final List<FinalCosting> prices;
  final String totalPrice;



  const InvoiceTable({Key? key,
    required this.prices, required this.totalPrice
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
      child: SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
           itemCount: prices.length,
            itemBuilder: (context,index){

            if(index == prices.length-1){
              return customRow(
                  title: "Total:",
                  data: "₹$totalPrice",
                  isTotalPrice: true
              );
            }else {
              return customRow(title: prices[index].lable.toString(),
                  data: "₹${prices[index].value.
                  toString().characters.take(5)}");
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

        Text(title,style: isTotalPrice ?? false ?
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

