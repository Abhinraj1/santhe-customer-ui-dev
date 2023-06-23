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
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_cancelReturn/hyperlocal_cancel_return_bloc.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_cart/hyperlocal_cart_bloc.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_checkout/hyperlocal_checkout_bloc.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_orderhistory/hyperlocal_orderhistory_bloc.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_shop/hyperlocal_shop_bloc.dart';
import 'package:santhe/core/blocs/ondc/ondc_bloc.dart';
import 'package:santhe/core/blocs/ondc_cart/cart_bloc.dart';
import 'package:santhe/core/cubits/customer_contact_cubit/customer_contact_cubit.dart';
import 'package:santhe/core/getapp.dart';
import 'package:santhe/core/repositories/address_repository.dart';
import 'package:santhe/core/repositories/hyperlocal_cancel_return_repo.dart';
import 'package:santhe/core/repositories/hyperlocal_cartrepo.dart';
import 'package:santhe/core/repositories/hyperlocal_checkoutrepository.dart';
import 'package:santhe/core/repositories/hyperlocal_orderhistoryrepo.dart';
import 'package:santhe/core/repositories/hyperlocal_repository.dart';
import 'package:santhe/core/repositories/ondc_cart_repository.dart';
import 'package:santhe/core/repositories/ondc_checkout_repository.dart';
import 'package:santhe/core/repositories/ondc_repository.dart';
import 'package:santhe/pages/splash_to_home.dart';
import 'core/blocs/ondc/ondc_order_cancel_and_return_bloc/ondc_order_cancel_and_return_bloc.dart';
import 'core/blocs/ondc/ondc_order_history_bloc/ondc_order_history_bloc.dart';
import 'core/cubits/hyperlocal_deals_cubit/hyperlocal_contact_support_cubit/contact_support_cubit.dart';
import 'core/cubits/hyperlocal_image_return_request_cubit/hyperlocal_image_return_request_cubit.dart';
import 'core/cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_cubit.dart';
import 'core/cubits/upload_image_and_return_request_cubit/upload_image_and_return_request_cubit.dart';
import 'core/cubits/webview_cubit/webview_cubit.dart';
import 'core/repositories/hyperlocal_contact_support.dart';
import 'core/repositories/ondc_order_cancel_and_return_repository.dart';
import 'firebase/firebase_messaging.dart';

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
  await FCM().firebaseMessageInit();

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
          RepositoryProvider<ONDCOrderCancelAndReturnRepository>(
            create: (context) => ONDCOrderCancelAndReturnRepository(),
          ),
          RepositoryProvider<HyperLocalRepository>(
            create: (context) => HyperLocalRepository(),
          ),
          RepositoryProvider<HyperLocalCartRepository>(
            create: (context) => HyperLocalCartRepository(),
          ),
          RepositoryProvider<HyperLocalCheckoutRepository>(
            create: (context) => HyperLocalCheckoutRepository(),
          ),
          RepositoryProvider<HyperLocalOrderHistoryRepository>(
            create: (context) => HyperLocalOrderHistoryRepository(),
          ),
          RepositoryProvider<HyperlocalCancelReturnRepository>(
            create: (context) => HyperlocalCancelReturnRepository(),
          ),
          RepositoryProvider<HyperlocalContactSupportRepository>(
            create: (context) => HyperlocalContactSupportRepository(),
          )
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
            BlocProvider<WebviewCubit>(create: (context) => WebviewCubit()),
            BlocProvider<UploadImageAndReturnRequestCubit>(
                create: (context) => UploadImageAndReturnRequestCubit(
                      repository:
                          context.read<ONDCOrderCancelAndReturnRepository>(),
                    )),
            BlocProvider<OrderDetailsScreenCubit>(
                create: (context) => OrderDetailsScreenCubit(
                    ondcRepository: context.read<OndcRepository>())),
            BlocProvider<OrderDetailsButtonCubit>(
                create: (context) => OrderDetailsButtonCubit()),
            BlocProvider<ContactSupportCubit>(
                create: (context) => ContactSupportCubit(
                  repo:  context.read<
                      HyperlocalContactSupportRepository>()
                )),
            BlocProvider<ONDCOrderCancelAndReturnReasonsBloc>(
                create: (context) => ONDCOrderCancelAndReturnReasonsBloc(
                    orderCancelRepository:
                        context.read<ONDCOrderCancelAndReturnRepository>())),
            BlocProvider<OrderHistoryBloc>(
              create: (context) => OrderHistoryBloc(
                  ondcRepository: context.read<OndcRepository>()),
            ),
            BlocProvider<HyperlocalShopBloc>(
              create: (context) => HyperlocalShopBloc(
                hyperLocalRepository: context.read<HyperLocalRepository>(),
              ),
            ),
            BlocProvider<HyperlocalCartBloc>(
              create: (context) => HyperlocalCartBloc(
                  hyperLocalCartRepository:
                      context.read<HyperLocalCartRepository>()),
            ),
            BlocProvider<HyperlocalCheckoutBloc>(
              create: (context) => HyperlocalCheckoutBloc(
                hyperLocalCheckoutRepository:
                    context.read<HyperLocalCheckoutRepository>(),
              ),
            ),
            BlocProvider<HyperlocalOrderhistoryBloc>(
              create: (context) => HyperlocalOrderhistoryBloc(
                hyperLocalOrderHistoryRepository:
                    context.read<HyperLocalOrderHistoryRepository>(),
              ),
            ),
            BlocProvider<HyperlocalCancelReturnBloc>(
              create: (context) => HyperlocalCancelReturnBloc(
                hyperlocalCancelReturnRepository:
                    context.read<HyperlocalCancelReturnRepository>(),
              ),
            ),
            BlocProvider<HyperlocalImageReturnRequestCubit>(
              create: (context) => HyperlocalImageReturnRequestCubit(
                repository: context.read<HyperlocalCancelReturnRepository>(),
              ),
            ),
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

            ///  ONDCContactSupportView(orderModel: SingleOrderModel(),)
            ///  ONDCContactSupportTicketScreenMobile()
            // ONDCWebviewScreenMobile(
            //   title: "TESTIGN",
            //   url: "https://google.com"
            //  /// "https://santhe.in/contact-santhe-support/",
            //
            // )
          ),
        ),
      ),
      allowtextScaling: false,
      size: const Size(390, 844),
    );
  }
}


///use this order id 89088251-33a2-4e2b-9602-e83f5fb57f7d