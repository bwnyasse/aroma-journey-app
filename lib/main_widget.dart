import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:asuka/asuka.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: Asuka.builder,
      title: 'Aroma Journey',
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: const ScrollbarThemeData(),
      ),
      routerConfig: Modular.routerConfig,
    );
  }
}
