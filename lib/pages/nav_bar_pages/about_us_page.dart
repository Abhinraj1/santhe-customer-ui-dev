import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        toolbarHeight: screenHeight * 5.5,
        leading: IconButton(
          splashRadius: 0.1,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 13.sp,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'About Us',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                WebView(
                  initialUrl: 'https://santhe.in/aboutus/app',
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
          )
        ],
      ),
    );
  }
}
