import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import '../../controllers/boxes_controller.dart';
import '../../widgets/faq_drop_text_widget.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: screenHeight * 5.5,
        leading: IconButton(
          splashRadius: 0.1,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 13.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'FAQ',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: Boxes.getFAQs().length,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        itemBuilder: (BuildContext context, int index) {
          return TextDropWidget(
              question: Boxes.getFAQs().get(index)?.quest ?? 'Error',
              answer: Boxes.getFAQs().get(index)?.answ ?? 'Error');
        },
      ),
    );
  }
}
