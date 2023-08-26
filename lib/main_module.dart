import 'package:aroma_journey/bloc/auth/auth_bloc.dart';
import 'package:aroma_journey/modules/home/home_module.dart';
import 'package:aroma_journey/modules/onboarding/onboarding_module.dart';
import 'package:aroma_journey/modules/splash/splash_page.dart';
import 'package:aroma_journey/services/auth_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(AuthBloc.new);
    i.addSingleton(AuthService.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const SplashPage());
    r.module('/onboarding', module: OnboardingModule());
    r.module('/home', module: HomeModule());
  }
}
