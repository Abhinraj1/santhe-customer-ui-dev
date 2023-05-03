import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';

import '../../core/app_colors.dart';
import '../../manager/font_manager.dart';
import '../../models/ondc/single_order_model.dart';
import '../../pages/ondc/ondc_contact_support/select_product_screen.dart';


class AddItems extends StatelessWidget {
  final SingleOrderModel store;
  const AddItems({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text("Select Item",
                  style: FontStyleManager().s16fw600Orange),
            )),
        InkWell(
          onTap: (){

            print("STORE CART ID,S length ====================================="
            "${store.quotes!.first.cartItemPrices!.length}");
            Get.to(()=>SelectProductScreen(store: store,));


          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: AppColors().grey60,
                    width: 1
                ),
                color: AppColors().white100
            ),
            margin: const EdgeInsets.symmetric(
                horizontal: 20,vertical: 10),
          child: selectedCartItemPriceId.isNotEmpty ?
          Text("You Selected ${selectedCartItemPriceId.length} Products",
          style: FontStyleManager().s16fw700,):
            null,),
        ),
      ],
    );
  }
}



// ///ToDo: Remove Below
// class AddItemScreen extends StatelessWidget {
//   final SingleOrderModel store;
//
//   const AddItemScreen({Key? key, required this.store}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Hero(
//       tag: "selectItem",
//       child: CustomScaffold(
//           body: ListView.builder(
//           itemBuilder: (context,index){
//             CartItemPrices item = store.quotes!.first.cartItemPrices![index];
//               return
//                 GestureDetector(
//                 onTap: ()  {
//
//                 },
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: width * 0.444,
//                       height: height * 0.28089,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15.0),
//                         color: Colors.white,
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.grey,
//                             offset: Offset(1, 3),
//                             spreadRadius: 1,
//                             blurRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           item.symbol == null
//                               ? SizedBox(
//                             height: height * 0.1264,
//                             width: 90,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(15.0),
//                               child: Image.asset(
//                                 'assets/cart.png',
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           )
//                               : ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: SizedBox(
//                               height: height * 0.1264,
//                               width: width * 0.25,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: CachedNetworkImage(
//                                   imageUrl: item.symbol,
//                                   fit: BoxFit.contain,
//                                   errorWidget: (context, url, error) =>
//                                       Image.asset(
//                                     'assets/cart.png',
//                                     fit: BoxFit.fill,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 8.0, top: 2),
//                               child: Container(
//                                 height: height * 0.042134,
//                                 color: Colors.white,
//                                 child: AutoSizeText(
//                                   item.title.toString(),
//                                   textAlign: TextAlign.center,
//                                   maxLines: 2,
//                                   style: const TextStyle(
//                                       color: Colors.black,
//                                       overflow: TextOverflow.ellipsis,
//                                       fontSize: 11),
//                                   minFontSize: 8,
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                                Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   'Rs ${item.price.toString()}',
//                                   style: TextStyle(
//                                       color: AppColors().brandDark,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//
//                   ],
//                 ),
//               );
//       }
//       )
//       ),
//     );
//   }
// }
