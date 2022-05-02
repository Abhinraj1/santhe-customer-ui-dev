// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:santhe/pages/home_page.dart';
//
// import 'package:santhe/widgets/sent_tab_widgets/merchant_item_card.dart';
//
// import '../../prototype_models/merchant_offer_model.dart';
// import '../../widgets/sent_tab_widgets/offer_card_widget.dart';
//
// class AcceptOfferPage extends StatelessWidget {
//   final MerchantOffer merchantOffer;
//   const AcceptOfferPage({required this.merchantOffer, Key? key})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width / 100;
//     double screenHeight = MediaQuery.of(context).size.height / 100;
//     return 123(
//       child: Scaffold(
//           appBar: AppBar(
//             toolbarHeight: screenHeight * 5.5,
//             leading: IconButton(
//               splashRadius: 0.1,
//               icon: Icon(
//                 Icons.arrow_back_ios_rounded,
//                 size: screenWidth * 4,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             title: Text(
//               'Accept Offer?',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 16),
//             ),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Center(
//                   child: Text(
//                     'Item & Price',
//                     style: TextStyle(
//                         color: Colors.orange,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18.0),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Items',
//                         style: TextStyle(
//                             color: Colors.grey,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15.0),
//                       ),
//                       Text(
//                         'Rs',
//                         style: TextStyle(
//                             color: Colors.orange,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(
//                   thickness: 2.0,
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     physics: BouncingScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: merchantOffer.mItems.length,
//                     itemBuilder: (context, index) {
//                       return MerchantItemCard(
//                           merchantItem: merchantOffer.mItems[index]);
//                     },
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     const Divider(
//                       thickness: 2.0,
//                       endIndent: 20,
//                       indent: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 50.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Total:',
//                             style: TextStyle(
//                                 color: Colors.grey,
//                                 fontWeight: FontWeight.w300,
//                                 fontSize: 30.0),
//                           ),
//                           Text(
//                             'Rs. ${merchantOffer.price.toStringAsFixed(0)}',
//                             style: TextStyle(
//                                 color: Colors.orange,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 30.0),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 10.0),
//                       child: SizedBox(
//                         width: screenWidth * 60,
//                         height: screenHeight * 6.5,
//                         child: MaterialButton(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16.0)),
//                           color: Colors.orange,
//                           onPressed: () {
//                             //todo send data to firebase, implement actual method
//                             print('btn triggered.');
//                             Get.offAll(() => const HomePage());
//                             Get.snackbar('Offer Accepted!',
//                                 'Thank you for choosing us.');
//                           },
//                           child: FittedBox(
//                             fit: BoxFit.scaleDown,
//                             child: Text(
//                               'Accept Offer',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: screenWidth * 5.5,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           )),
//     );
//   }
// }
