import 'package:aroma_journey/modules/onboarding/onboarding_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.module('/', module: OnboardingModule());
  }
}
