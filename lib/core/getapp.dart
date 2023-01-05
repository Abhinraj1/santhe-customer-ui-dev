import 'package:get_it/get_it.dart';
import 'package:santhe/core/repositories/ondc_repository.dart';
import 'dart:developer' as dev;

GetIt get app => GetIt.instance;
void initializeGetIt() {
  dev.log("Initiailizing get it", name: "getapp.dart");
  app.registerLazySingleton(
    () => OndcRepository(),
  );
}
