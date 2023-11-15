import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/pages/animated_loading_Screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/custom_widgets/customScaffold.dart';

class PaymentWebviewScreen extends StatelessWidget {
  final String url;
  const PaymentWebviewScreen({Key? key, required this.url});

  @override
  Widget build(BuildContext context) {
    WebViewController  controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // Get.to(()=>const AnimatedLoadingScreen());
            return NavigationDecision.navigate;
          }
        ),
      )
      ..loadRequest(Uri.parse(url));
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}






// import 'dart:io';
// import 'dart:math';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:santhe/core/app_colors.dart';
// import 'package:santhe/core/app_helpers.dart';
// import 'package:santhe/core/app_url.dart';
// import 'package:santhe/manager/font_manager.dart';
// import 'package:santhe/pages/animated_loading_Screen.dart';
// import 'package:santhe/payment_implementation/src/models/payment_request_model.dart';
// import 'package:santhe/widgets/custom_widgets/custom_button.dart';
// import '../controllers/getx/profile_controller.dart';
// import '../core/blocs/hyperlocal/hyperlocal_checkout/hyperlocal_checkout_bloc.dart';
// import '../payment_implementation/src/models/payment_instruments/pay_page.dart';
// import '../payment_implementation/src/models/payment_instruments/upi_intent.dart';
// import '../payment_implementation/src/models/payment_status_response.dart';
// import '../payment_implementation/src/models/upi_app_info.dart';
// import '../payment_implementation/src/src.dart';
// import '../widgets/custom_widgets/customScaffold.dart';
// import 'hyperlocal/hyperlocal_paymentsucess/hyperlocal_paymentsucess_view.dart';
//
//
//
//
// class UpiScreen extends StatefulWidget {
//   final String orderId;
//   final double amount;
//
//   const UpiScreen({Key? key,required this.orderId, required this.amount}) : super(key: key);
//
//   @override
//   State<UpiScreen> createState() => _UpiScreenState();
// }
//
// class _UpiScreenState extends State<UpiScreen> {
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }
//   String callBackUrl = "https://ondcstaging.santhe.in/santhe/hyperlocal/payment/phonepe/callback";
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     // We also handle the message potentially returning null.
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//   }
//
//   PhonePePg pePg = PhonePePg(
//     isUAT: AppUrl().isDev,
//     saltKey: AppUrl().phonePeSaltKeys,
//     saltIndex: "1",
//   );
//
//   PaymentRequest _paymentRequest({String? merchantCallBackScheme}) {
//     String generateRandomString(int len) {
//       const chars =
//           'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
//       Random rnd = Random();
//       var s = String.fromCharCodes(Iterable.generate(
//           len, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
//       return s;
//     }
//
//     PaymentRequest paymentRequest = PaymentRequest(
//       amount: widget.amount,
//       callbackUrl: callBackUrl,
//       deviceContext: DeviceContext.getDefaultDeviceContext(
//           merchantCallBackScheme: merchantCallBackScheme),
//       merchantId: AppUrl().phonePeMerchantId,
//       merchantTransactionId: widget.orderId,//generateRandomString(10).toUpperCase(),
//       merchantUserId: generateRandomString(8).toUpperCase(),
//       mobileNumber: AppHelpers().getPhoneNumber,
//     );
//     return paymentRequest;
//   }
//
//   PaymentRequest upipaymentRequest(UpiAppInfo e,
//       {String? merchantCallBackScheme}) =>
//       _paymentRequest(merchantCallBackScheme: merchantCallBackScheme).copyWith(
//           paymentInstrument: UpiIntentPaymentInstrument(
//             targetApp: Platform.isAndroid ? e.packageName! : e.iOSAppName!,
//           ));
//
//   PaymentRequest paypageRequestModel({String? merchantCallBackScheme}) =>
//       _paymentRequest(merchantCallBackScheme: merchantCallBackScheme).copyWith(
//         //  redirectUrl: "https://github.com/",
//          // redirectMode: 'GET',
//           callbackUrl: callBackUrl,
//           paymentInstrument: PayPagePaymentInstrument());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//           appBar: AppBar(
//             title: const Text('UPI PAYMENT'),
//             backgroundColor: AppColors().brandDark,
//             centerTitle: true,
//           ),
//           body: FutureBuilder<List?>(
//             future: PhonePePg.getUpiApps(iOSUpiApps: [
//               UpiAppInfo(
//                 appName: "PhonePe",
//                 packageName: "ppe",
//                 appIcon: Uint8List(0),
//                 iOSAppName: "PHONEPE",
//                 iOSAppScheme: 'ppe',
//               ),
//               UpiAppInfo(
//                 appName: "Google Pay",
//                 packageName: "gpay",
//                 appIcon: Uint8List(0),
//                 iOSAppName: "GPAY",
//                 iOSAppScheme: 'gpay',
//               ),
//               UpiAppInfo(
//                 appName: "Paytm",
//                 packageName: "paytmmp",
//                 appIcon: Uint8List(0),
//                 iOSAppName: "PAYTM",
//                 iOSAppScheme: 'paytmmp',
//               ),
//               UpiAppInfo(
//                   appName: "PhonePe Simulator",
//                   packageName: "ppemerchantsdkv1",
//                   appIcon: Uint8List(0),
//                   iOSAppScheme: 'ppemerchantsdkv1',
//                   iOSAppName: "PHONEPE"),
//               UpiAppInfo(
//                 appName: "PhonePe Simulator",
//                 packageName: "ppemerchantsdkv2",
//                 appIcon: Uint8List(0),
//                 iOSAppScheme: 'ppemerchantsdkv2',
//                 iOSAppName: "PHONEPE",
//               ),
//               UpiAppInfo(
//                 appName: "PhonePe Simulator",
//                 packageName: "ppemerchantsdkv3",
//                 iOSAppScheme: 'ppemerchantsdkv3',
//                 appIcon: Uint8List(0),
//                 iOSAppName: "PHONEPE",
//               ),
//             ]),
//             builder: (context, snapshot) {
//               if (snapshot.hasData && snapshot.data != null) {
//                 return ListView(children: [
//                   ...snapshot.data!
//                       .map(
//                         (e) => Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           child: SizedBox(
//                             height: 40,
//                             child: ListTile(
//                       onTap: () async {
//                         print("paclage name========================== ${e.packageName}");
//                         context.read<HyperlocalCheckoutBloc>().add(
//                           PostPaymentCheckoutEvent(
//                             orderId: widget.orderId.toString(),
//                             targetApp: e.packageName.toString(),
//
//                           )
//                         );
//
//                             // pePg
//                             //     .startUpiTransaction(
//                             //     paymentRequest: upipaymentRequest(e))
//                             //     .then((response) {
//                             //
//                             //   print("ERROR MESSAGE ===================================="
//                             //       "++++++++++++++++= ${response.toString()}");
//                             //
//                             //   if (response.status == UpiPaymentStatus.success) {
//                             //
//                             //     context.read<HyperlocalCheckoutBloc>().add(
//                             //       VerifyPaymentEventHyperlocal(
//                             //         orderId: widget.orderId.toString(),
//                             //       ),
//                             //     );
//                             //     // Get.to(
//                             //     //         () => const AnimatedLoadingScreen());
//                             //
//                             //   } else if (response.status ==
//                             //       UpiPaymentStatus.pending) {
//                             //     ScaffoldMessenger.of(context).showSnackBar(
//                             //         const SnackBar(
//                             //             content: Text("Transaction Pending")));
//                             //   } else {
//                             //     ScaffoldMessenger.of(context).showSnackBar(
//                             //         const SnackBar(
//                             //             content: Text("Transaction Failed")));
//                             //   }
//                             // }).catchError((e) {
//                             //   print("ERROR MESSAGE === CATCH================================="
//                             //       "++++++++++++++++= ${e.response.toString()}");
//                             //   ScaffoldMessenger.of(context).showSnackBar(
//                             //       const SnackBar(
//                             //           content: Text("Transaction Failed")));
//                             // });
//                       },
//
//                       leading: Image.memory(
//                             e.appIcon,
//                             errorBuilder: (context, error, stackTrace) {
//                               return const Icon(Icons.error);
//                             },
//                       ),
//
//                       title: Text(e.appName,style: FontStyleManager().s14fw600Grey),
//                      // subtitle: Text(e.packageName ?? e.iOSAppName!),
//                     ),
//                           ),
//                         ),
//                   )
//                       .toList(),
//                  // ElevatedButton(
//                  //   onPressed: (){},
//                  //     child: Text("Card/Net Banking"),),
//                   CustomButton(
//                     horizontalPadding: 15,
//                       invert: true,
//                       onTap: (){
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => pePg.startPayPageTransaction(
//                                   onPaymentComplete:
//                                       (paymentResponse, paymentError) {
//                                     Navigator.pop(context);
//                                     if (paymentResponse != null &&
//                                         paymentResponse.code ==
//                                             PaymentStatus.success) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(const SnackBar(
//                                           content: Text(
//                                               "Transaction Successful")));
//                                     } else {
//
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(const SnackBar(
//                                           content: Text(
//                                               "Transaction Failed")));
//                                     }
//                                   },
//                                   paymentRequest: paypageRequestModel(),
//                                 )));
//                       },
//                       width: double.infinity,
//                       buttonTitle: "Other Payment Options"),
//                 ]);
//               }
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             },
//           ),
//     );
//   }
// }
