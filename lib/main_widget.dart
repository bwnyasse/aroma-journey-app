import 'package:aroma_journey/extra/flutter_flow/internationalization.dart';
import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();

  static _MainWidgetState of(BuildContext context) =>
      context.findAncestorStateOfType<_MainWidgetState>()!;
}

class _MainWidgetState extends State<MainWidget> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
      });

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: Asuka.builder,
      title: 'Aroma Journey',
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: const ScrollbarThemeData(),
      ),
      locale: _locale,
      supportedLocales: const [Locale('en', '')],
      themeMode: _themeMode,
      routerConfig: Modular.routerConfig,
    );
  }
}
