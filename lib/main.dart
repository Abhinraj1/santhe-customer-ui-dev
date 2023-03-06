import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as gets;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as dev;
import 'package:resize/resize.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_theme.dart';
import 'package:santhe/core/blocs/address/address_bloc.dart';
import 'package:santhe/core/blocs/checkout/checkout_bloc.dart';
import 'package:santhe/core/blocs/ondc/ondc_bloc.dart';
import 'package:santhe/core/blocs/ondc_cart/cart_bloc.dart';
import 'package:santhe/core/cubits/customer_contact_cubit/customer_contact_cubit.dart';
import 'package:santhe/core/getapp.dart';
import 'package:santhe/core/repositories/address_repository.dart';
import 'package:santhe/core/repositories/ondc_cart_repository.dart';
import 'package:santhe/core/repositories/ondc_checkout_repository.dart';
import 'package:santhe/core/repositories/ondc_repository.dart';
import 'package:santhe/models/ondc/shop_model.dart';
import 'package:santhe/pages/ondc/ondc_checkout_screen/new/ondc_checkout_screen_mobile.dart';
import 'package:santhe/pages/ondc/ondc_customer_order_history_screen/ondc_order_history_mobile.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/ondc_order_details_screen_mobile.dart';
import 'package:santhe/pages/ondc/ondc_return_screens/ondc_return_acknowledgement%20_screen/ondc_return_acknowledgement%20_screen_mobile.dart';
import 'package:santhe/pages/splash_to_home.dart';
import 'package:santhe/widgets/ondc_widgets/ondc_shop_widget.dart';
import 'core/blocs/ondc/ondc_order_cancel_bloc/ondc_order_cancel_bloc.dart';
import 'core/blocs/ondc/ondc_single_order_details_bloc/ondc_single_order_details_bloc.dart';
import 'core/cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_cubit.dart';
import 'core/repositories/ondc_order_cancel_repository.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeGetIt();
  await Firebase.initializeApp();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
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

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    const MyApp(),
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: AppColors().brandDark,
  ));

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Resize(
      builder: () => MultiRepositoryProvider(
        providers: [
          RepositoryProvider<OndcRepository>(
            create: (context) => OndcRepository(),
          ),
          RepositoryProvider<OndcCartRepository>(
            create: (context) => OndcCartRepository(),
          ),
          RepositoryProvider<OndcCheckoutRepository>(
            create: (context) => OndcCheckoutRepository(),
          ),
          RepositoryProvider<AddressRepository>(
            create: (context) => AddressRepository(),
          ),
          RepositoryProvider<ONDCOrderCancelRepository>(
            create: (context) => ONDCOrderCancelRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<OndcBloc>(
              create: (context) =>
                  OndcBloc(ondcRepository: context.read<OndcRepository>()),
            ),
            BlocProvider<CartBloc>(
              create: (context) => CartBloc(
                ondcCartRepository: context.read<OndcCartRepository>(),
              ),
            ),
            BlocProvider<CheckoutBloc>(
              create: (context) => CheckoutBloc(
                ondcCheckoutRepository: context.read<OndcCheckoutRepository>(),
              ),
            ),
            BlocProvider<AddressBloc>(
              create: (context) => AddressBloc(
                addressRepository: context.read<AddressRepository>(),
              ),
            ),
            BlocProvider<CustomerContactCubit>(
                create: (context) => CustomerContactCubit()),
            BlocProvider<OrderDetailsCubit>(
                create: (context) => OrderDetailsCubit()),
            BlocProvider<ONDCOrderCancelBloc>(
                create: (context) => ONDCOrderCancelBloc(
                    orderCancelRepository:
                        context.read<ONDCOrderCancelRepository>())),
            BlocProvider<SingleOrderDetailsBloc>(
              create: (context) => SingleOrderDetailsBloc(
                  ondcRepository: context.read<OndcRepository>()),
            )
          ],
          child: gets.GetMaterialApp(
            defaultTransition: gets.Transition.rightToLeft,
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
            home: const SplashToHome(),
          ),
        ),
      ),
      allowtextScaling: false,
      size: const Size(390, 844),
    );
  }
}


///use this order id 89088251-33a2-4e2b-9602-e83f5fb57f7d