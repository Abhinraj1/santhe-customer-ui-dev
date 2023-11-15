import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/app_colors.dart';

class AnimatedLoadingScreen extends StatelessWidget {
  const AnimatedLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.network(
                      'https://assets9.lottiefiles.com/packages/lf20_dkz94xcg.json'),
                  const SizedBox(
                    height: 60,
                  ),
                  Text(
                    'Verifying payment',
                    style: TextStyle(
                      color: AppColors().brandDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      'Please wait while we verify your payment',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey, fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
  }
}
