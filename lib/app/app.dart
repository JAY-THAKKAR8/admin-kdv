// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:admin_kdv/app/routes/go_router.dart';
import 'package:admin_kdv/cubit/refresh_cubit.dart';
import 'package:admin_kdv/injector/injector.dart';
import 'package:admin_kdv/theme/app_theme.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int width = html.window.innerWidth!;
  int height = html.window.innerHeight!;
  @override
  void initState() {
    super.initState();
    html.window.onResize.listen((event) {
      setState(() {
        width = html.window.innerWidth!;
        height = html.window.innerHeight!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      child: MaterialApp.router(
        scrollBehavior: CustomScrollBehavior(),
        title: 'Kdv App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routeInformationParser: goRouter.routeInformationParser,
        routeInformationProvider: goRouter.routeInformationProvider,
        routerDelegate: goRouter.routerDelegate,
        locale: const Locale.fromSubtags(languageCode: 'en'),
        builder: BotToastInit(),
      ),
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<RefreshCubit>(),
        ),
      ],
      child: child,
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
