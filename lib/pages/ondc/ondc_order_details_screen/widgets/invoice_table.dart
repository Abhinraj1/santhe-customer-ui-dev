import 'package:flutter/material.dart';

import '../../../../manager/font_manager.dart';


Widget invoiceTable(){
  String subTotal = "₹425",
  deliveryCharger = "₹30",
      taxesCGST = "₹8",
      taxesSGST = "₹12",
      total = "₹475";

  return
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 20),
      child: Table(
        children: [
          TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("Subtotal:",style: FontStyleManager().s14fw700Grey,),
                ),
                Text(subTotal,style: FontStyleManager().s16fw700Brown,textAlign: TextAlign.right),

              ]
          ),
          TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("Delivery Charges:",style: FontStyleManager().s14fw800Grey,),
                ),
                Text(deliveryCharger,style: FontStyleManager().s16fw700Brown,textAlign: TextAlign.right),

              ]
          ),
          TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("Taxes(CGST):",style: FontStyleManager().s14fw800Grey,),
                ),
                Text(taxesCGST,style: FontStyleManager().s16fw700Brown,textAlign: TextAlign.right),

              ]
          ),
          TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("Taxes(SGST):",style: FontStyleManager().s14fw800Grey,),
                ),
                Text(taxesSGST,
                    style: FontStyleManager().s16fw700Brown,
                    textAlign: TextAlign.right),

              ]
          ),
          TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("Total:  ",style: FontStyleManager().s18fw700Black,),
                ),
                Text(total,style: FontStyleManager().s16fw700Brown,textAlign: TextAlign.right),

              ]
          ),
        ],
      ),
    );}