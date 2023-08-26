import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Aroma Journey',
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: const ScrollbarThemeData(),
      ),
      routerConfig: Modular.routerConfig,
    );
  }
}
