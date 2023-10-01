import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/routing.dart';

class MyApp extends ConsumerWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  final _routeInformationParser = AppRouteInformationParser();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerDelegate = ref.watch(routerDelegateProvider);
    return MaterialApp.router(
      routerDelegate: routerDelegate,
      routeInformationParser: _routeInformationParser,
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: ThemeData(
        visualDensity: const VisualDensity(),
        // TODO: Figure out swatch
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.black, // background (button) color
            onPrimary: Colors.white, // foreground (text) color
          ),
        ),
        tabBarTheme: const TabBarTheme(
          // TODO: Figure out properties
          labelColor: Colors.white,
        ),
      ),
    );
  }
}
