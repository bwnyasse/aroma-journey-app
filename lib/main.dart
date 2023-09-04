import 'dart:async';

import 'package:aroma_journey/backend/firebase/firebase_options.dart';
import 'package:aroma_journey/main_module.dart';
import 'package:aroma_journey/main_widget.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logging/logging.dart';

final log = Logger('AmoraJourney');

void main() async {
  Logger.root.level = Level.ALL;
  runZonedGuarded(() {
    // This is the block of code that will be executed in a new zone with a custom error handler.
    _mainInZone();
  }, (error, stackTrace) {
    // This is the error handler that will be called if an error occurs in the block of code.
    log.severe('An error occurred: $error');
    log.severe('Stack trace: $stackTrace');
  });
}

void _mainInZone() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );
  return runApp(ModularApp(
    module: MainModule(),
    child: const MainWidget(),
  ));
}
