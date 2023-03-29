import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../widgets/custom_widgets/customScaffold.dart';
import '../../../widgets/custom_widgets/home_icon_button.dart';



class ONDCWebviewScreenMobile extends StatefulWidget {
  final String title;
  final String url;
  const ONDCWebviewScreenMobile({Key? key,
    required this.title, required this.url}) : super(key: key);

  @override
  State<ONDCWebviewScreenMobile> createState() => _ONDCWebviewScreenMobileState();
}

class _ONDCWebviewScreenMobileState extends State<ONDCWebviewScreenMobile> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 100;
    return CustomScaffold(
      trailingButton: homeIconButton(),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}
