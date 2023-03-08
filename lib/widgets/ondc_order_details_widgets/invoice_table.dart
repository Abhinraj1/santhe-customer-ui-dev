import 'package:flutter/material.dart';

import '../../../../manager/font_manager.dart';
import '../../models/ondc/single_order_model.dart';


class InvoiceTable extends StatelessWidget {

  final List<CartItemPrices> prices;
  final String totalPrice;



  const InvoiceTable({Key? key,
    required this.prices, required this.totalPrice
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String getSubTotal(){
      int subtotal = 0;
      for(var i in prices){
        if(i.type == "item"){
         int price  = int.parse(i.price.toString());
         subtotal = subtotal+price.toInt();
         return subtotal.toString();
        }
      }
      return subtotal.toString();
    }
    final String subTotal = getSubTotal();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 20),
      child: SizedBox(
        child: Column(
          children: [
            customRow(
              title: "Subtotal",
              data: "₹$subTotal"
            ),
            SizedBox(
              height: prices.length*15,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                 itemCount: prices.length,
                  itemBuilder: (context,index){
                   if(prices[index].type != "item"){
                     return customRow(title: prices[index].title.toString(),
                         data: "₹${prices[index].price.toString()}");
                   }else{
                     return const SizedBox();
                   }
                  }),
            ),
            customRow(
                title: "Total:",
                data: "₹$totalPrice",
              isTotalPrice: true

            ),
          ],
        ),
      )

    );
  }

Widget customRow({required String title, required String data, bool? isTotalPrice}){

    return
      SizedBox(
      height: 25,
      child: Row(
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: [

        Text(title,style: isTotalPrice ?? false ?
            FontStyleManager().s18fw700Black :
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

