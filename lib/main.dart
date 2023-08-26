import 'package:aroma_journey/main_module.dart';
import 'package:aroma_journey/main_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  return runApp(ModularApp(
    module: MainModule(),
    child: const MainWidget(),
  ));
}
