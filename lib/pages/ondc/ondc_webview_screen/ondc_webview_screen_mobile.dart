import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resize/resize.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/cubits/webview_cubit/webview_cubit.dart';
import '../../../widgets/custom_widgets/customScaffold.dart';
import '../../../widgets/custom_widgets/home_icon_button.dart';


class ONDCWebviewScreenMobile extends StatefulWidget {
  final String title;
  final String url;

  const ONDCWebviewScreenMobile({Key? key,
    required this.title, required this.url}) : super(key: key);

  @override
  State<ONDCWebviewScreenMobile> createState() =>
      _ONDCWebviewScreenMobileState();
}

class _ONDCWebviewScreenMobileState extends State<ONDCWebviewScreenMobile> {


  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            BlocProvider.of<WebviewCubit>(context).webviewLoaded();
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    double screenHeight = MediaQuery
        .of(context)
        .size
        .height / 100;

    return BlocBuilder<WebviewCubit, WebviewState>(
      builder: (context, state) {
        if(state is WebviewLoadedState){
          return CustomScaffold(
            trailingButton: homeIconButton(),
            body: WebViewWidget(
              controller: controller,
            ),
          );
        }else{
          return  CustomScaffold(
              trailingButton: homeIconButton(),
              body: const Center(child: CircularProgressIndicator()));
        }

      },
    );
  }
}
