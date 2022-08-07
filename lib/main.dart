import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_theme.dart';
import 'package:santhe/pages/splash_to_home.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runZonedGuarded<Future<void>>(
    () async {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      runApp(const MyApp());
    },
    (error, stack) =>
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Resize(
      builder: () => GetMaterialApp(
          defaultTransition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 500),
          debugShowCheckedModeBanner: false,
          title: kAppName,
          theme: AppTheme().themeData.copyWith(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors().brandDark,
                  primary: AppColors().brandDark,
                ),
                textSelectionTheme: const TextSelectionThemeData(
                  selectionHandleColor: Colors.transparent,
                ),
              ),
          home: const SplashToHome()),
      allowtextScaling: false,
      size: const Size(390, 844),
    );
  }
}
