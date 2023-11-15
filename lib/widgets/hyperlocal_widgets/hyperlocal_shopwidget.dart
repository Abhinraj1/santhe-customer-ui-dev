// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/loggers.dart';

import 'package:santhe/models/hyperlocal_models/hyperlocal_shopmodel.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_shopdetails/hyperlocal_shopdetails_view.dart';
import 'package:santhe/widgets/ondc_widgets/shop_images_intro.dart';

import '../../utils/get_screen_dimensions.dart';


class HyperLocalShopWidget extends StatefulWidget {
  final HyperLocalShopModel hyperLocalShopModel;
  final String? searchItem;
  const HyperLocalShopWidget({
    Key? key,
    required this.hyperLocalShopModel, this.searchItem,
  }) : super(key: key);

  @override
  State<HyperLocalShopWidget> createState() => _HyperLocalShopWidgetState();
}

class _HyperLocalShopWidgetState extends State<HyperLocalShopWidget>
    with LogMixin {
  List<String> images = [];
  List<ShopImageIntro> networkImages = [];
  dynamic distanceD = 0;
  bool isLoading = true; // Add a loading flag

  Future<List<String>> fetchImagePaths() async {
    List<String> isolateImages = [];
    if (widget.hyperLocalShopModel.images.length != null) {
      for (var i = 0; i < widget.hyperLocalShopModel.images.length; i++) {
        final string = widget.hyperLocalShopModel.images[i]['display_image'];
        if (string.toString().contains('null')) {
          isolateImages.add('assets/placeHolder.jpeg');
        } else {
          isolateImages.add(string);
        }
      }
    }
    return isolateImages;
  }

  // Inside the _HyperLocalShopWidgetState class...
  Future<void> isolate() async {
    final Completer<void> completer = Completer<void>();

    try {
      final imagePaths = await fetchImagePaths(); // Fetch image paths asynchronously
      setState(() {
        images = imagePaths;
        isLoading = false; // Set the loading flag to false
      });
      completer.complete();
    } catch (e) {
      print('Isolate error: $e');
      completer.completeError(e);
    }

    return completer.future;
  }


  getDistance() {
    if (widget.hyperLocalShopModel.distance != null) {
      dynamic d = widget.hyperLocalShopModel.distance;
      String? distance = d.toStringAsFixed(1);
      setState(() {
        distanceD = double.parse(distance!);
      });
    } else {
      setState(() {
        distanceD = 0.0;
      });
    }
  }

  @override
  void initState() {
    getDistance();
    isolate(); // Trigger isolate execution in initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    errorLog('Images of hyper local ${widget.hyperLocalShopModel.images}');
    return GestureDetector(
      onTap: () => Get.to(
              () => HyperlocalShopdetailsView(
                  hyperLocalShopModel: widget.hyperLocalShopModel,
              searchItem: widget.searchItem,)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: 195,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(1, 3),
                spreadRadius: 1,
                blurRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: getScreenDimensions(context: context, horizontalPadding: 60).width,
                      child: Text(
                        widget.hyperLocalShopModel.name.toString(),
                        maxLines: 2,
                        style: TextStyle(
                            color: AppColors().brandDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ],
              ),
              widget.hyperLocalShopModel.images.isEmpty
                  ? Text(
                "${widget.hyperLocalShopModel.name}",
                maxLines: 2,
                style: TextStyle(
                    color: AppColors().brandDark,
                    fontWeight: FontWeight.bold),
              )
                  : SizedBox(
                    width: getScreenDimensions(context: context, horizontalPadding: 34).width,
                    height: 90,
                    child: Center(
                      child: isLoading
                      ? const CircularProgressIndicator() // Show loading indicator while waiting for data
                      : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context,index){
                        return ShopImageIntro(image: images[index],);
                      }),
                    ),
                  ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  height: 35,
                  width: getScreenDimensions(context: context, horizontalPadding: 34).width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$distanceD kms',
                        style: TextStyle(
                          color: AppColors().grey80,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${widget.hyperLocalShopModel.itemCount} items',
                          style: TextStyle(
                              color: AppColors().brandDark, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}




// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:async';
// import 'dart:isolate';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:santhe/core/app_colors.dart';
// import 'package:santhe/core/loggers.dart';
//
// import 'package:santhe/models/hyperlocal_models/hyperlocal_shopmodel.dart';
// import 'package:santhe/pages/hyperlocal/hyperlocal_shopdetails/hyperlocal_shopdetails_view.dart';
// import 'package:santhe/widgets/ondc_widgets/shop_images_intro.dart';
//
// import '../../utils/get_screen_dimensions.dart';
//
// class HyperLocalShopWidget extends StatefulWidget {
//   final HyperLocalShopModel hyperLocalShopModel;
//   const HyperLocalShopWidget({
//     Key? key,
//     required this.hyperLocalShopModel,
//   }) : super(key: key);
//
//   @override
//   State<HyperLocalShopWidget> createState() => _HyperLocalShopWidgetState();
// }
//
// class _HyperLocalShopWidgetState extends State<HyperLocalShopWidget>
//     with LogMixin {
//   List<String> images = [];
//   List<ShopImageIntro> networkImages = [];
//   dynamic distanceD = 0;
//
// //   getImagesOfShops(List<dynamic> data) {
// //     List<String> isolateImages = [];
// //     List<ShopImageIntro> isolateNetworkImages = [];
// //     if (widget.hyperLocalShopModel.images.length != null) {
// //       for (var i = 0; i < widget.hyperLocalShopModel.images.length; i++) {
// //         final string = widget.hyperLocalShopModel.images[i]['display_image'];
// //         if (string.toString().contains('null')) {
// //           isolateImages.add('assets/cart.png');
// //         } else {
// //           isolateImages.add(string);
// //         }
// //       }
// //       for (var element in isolateImages) {
// //         isolateNetworkImages.add(
// //           ShopImageIntro(image: element),
// //         );
// //       }
// //     }
// //     images = isolateImages;
// //     networkImages = isolateNetworkImages;
// //     setState(() {});
// // // SendPort _sender = data[0];
// // // Isolate.exit(_sender,[isolateImages,isolateNetworkImages]);
// //   }
//
//
//   getDistance() {
//     if (widget.hyperLocalShopModel.distance != null) {
//       dynamic d = widget.hyperLocalShopModel.distance;
//       String? distance = d.toStringAsFixed(1);
//       setState(() {
//         distanceD = double.parse(distance!);
//       });
//     } else {
//       setState(() {
//         distanceD = 0.0;
//       });
//     }
//
//   }
//
//
// // Inside the _HyperLocalShopWidgetState class...
//
//   Future<void> isolate() async {
//     final completer = Completer<void>();
//     final receivePort = ReceivePort();
//
//     try {
//       await Isolate.spawn(getAndProcessImages, {'completer': completer, 'sendPort': receivePort.sendPort});
//     } catch (e) {
//       print('Isolate error: $e');
//       receivePort.close();
//     }
//
//     receivePort.listen((data) {
//       if (data != null && data is List<String>) {
//         // Close the receive port
//         receivePort.close();
//
//         // Process the image paths received from the isolate
//         setState(() {
//           images = data;
//         });
//
//         // Complete the completer
//         completer.complete();
//       }
//     });
//
//     // Wait for the isolate to complete
//     await completer.future;
//   }
//
// // Modify getAndProcessImages to fetch and process image paths
//   void getAndProcessImages(Map<String, dynamic> data) {
//     final Completer<void> completer = data['completer'];
//     final SendPort sendPort = data['sendPort'];
//
//     // Simulate image processing by fetching and processing image paths
//     List<String> isolateImages = [];
//     if (widget.hyperLocalShopModel.images.length != null) {
//       for (var i = 0; i < widget.hyperLocalShopModel.images.length; i++) {
//         final string = widget.hyperLocalShopModel.images[i]['display_image'];
//         if (string.toString().contains('null')) {
//           isolateImages.add('assets/cart.png');
//         } else {
//           isolateImages.add(string);
//         }
//       }
//     }
//
//     // Sending the image paths back to the main thread
//     sendPort.send(isolateImages);
//
//     // Complete the completer
//     completer.complete();
//   }
//
//
//
//   // isolate() async{
//   //   ReceivePort _receive = ReceivePort();
//   //
//   //   try{
//   //     await Isolate.spawn(getImagesOfShops,[_receive.sendPort]);
//   //   }on Object{
//   //
//   //     _receive.close();
//   //   }
//   //
//   //   final output = await _receive.first;
//   //
//   //   print("FROM ISOLATEEEEE OUTOPUT ============================================================"
//   //       "================================== ${output[0].toString()}");
//   // }
//
//
//   @override
//   void initState() {
//      //getImagesOfShops([]);
//      getDistance();
//     isolate();
//     super.initState();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     errorLog('Images of hyper local ${widget.hyperLocalShopModel.images}');
//     return GestureDetector(
//       onTap: () => Get.to(()=>
//         HyperlocalShopdetailsView(
//             hyperLocalShopModel: widget.hyperLocalShopModel),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Container(
//           height: 195,
//           width: MediaQuery.of(context).size.width * 0.9,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.grey,
//                 offset: Offset(1, 3),
//                 spreadRadius: 1,
//                 blurRadius: 2,
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SizedBox(
//                       width: getScreenDimensions(
//                           context: context,horizontalPadding: 60).width,
//                       child: Text(
//                         widget.hyperLocalShopModel.name.toString(),
//                         maxLines: 2,
//                         style: TextStyle(
//                             color: AppColors().brandDark,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                             overflow: TextOverflow.ellipsis),
//                       ),
//                     ),
//                   ),
//                   // Text('${widget.shopModel.address}'),
//                   // Text('${widget.shopModel.ondc_store_id}')
//                 ],
//               ),
//               widget.hyperLocalShopModel.images.isEmpty
//                   ? Text(
//                     "${widget.hyperLocalShopModel.name}",
//                     maxLines: 2,
//                     style: TextStyle(
//                         color: AppColors().brandDark,
//                         fontWeight: FontWeight.bold),
//                   )
//                   : SizedBox(
//                 width: getScreenDimensions(
//                     context: context,horizontalPadding: 34).width,
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: FutureBuilder<void>(
//                             future: isolate(),
//                           builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
//                             if (snapshot.connectionState == ConnectionState.done) {
//                               return Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: networkImages,
//                               );
//                             } else {
//                               return const CircularProgressIndicator(); // Show loading indicator while waiting for data
//                             }
//
//                           }
//                         ),
//                       ),
//                     ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: SizedBox(
//                   height: 35,
//                   width: getScreenDimensions(
//                       context: context,horizontalPadding: 34).width,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         '$distanceD kms',
//                         style: TextStyle(
//                           color: AppColors().grey80,
//                         ),
//                       ),
//
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           '${widget.hyperLocalShopModel.itemCount} items',
//                           style: TextStyle(
//                               color: AppColors().brandDark, fontSize: 16),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
