import 'dart:async';

import 'package:admin_kdv/app/observer/app_bloc_observer.dart';
import 'package:admin_kdv/injector/injector.dart';
import 'package:admin_kdv/utility/helpers/logger_config.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

Future<void> bootstrap(Widget builder) async {
  Zone.current.fork().runGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAYabPpocxD4Nf19LLR3dwv2_TFy5vD2PQ",
        authDomain: "admin-kdv.firebaseapp.com",
        projectId: "admin-kdv",
        storageBucket: "admin-kdv.appspot.com",
        messagingSenderId: "32989748306",
        appId: "1:32989748306:android:71b4b8657640c77252538b",
      ),
    );
    Bloc.observer = AppBlocObserver();

    await configureDependencies();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
    GoRouter.optionURLReflectsImperativeAPIs = true;

    runApp(builder);

    FlutterError.onError = (details) {
      debugError('${details.exceptionAsString()}\n${details.stack}');
    };
  });
}
