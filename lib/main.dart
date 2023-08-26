import 'package:aroma_journey/main_module.dart';
import 'package:aroma_journey/main_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(ModularApp(
    module: MainModule(),
    child: const MainWidget(),
  ));
}
