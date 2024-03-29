import 'package:aroma_journey/modules/auth/auth_module.dart';
import 'package:aroma_journey/modules/auth/auth_service.dart';
import 'package:aroma_journey/modules/auth/bloc/auth_bloc.dart';
import 'package:aroma_journey/modules/home/home_module.dart';
import 'package:aroma_journey/modules/product/product_module.dart';
import 'package:aroma_journey/modules/product/product_service.dart';
import 'package:aroma_journey/modules/quizz/quizz_module.dart';
import 'package:aroma_journey/modules/quizz/quizz_service.dart';
import 'package:aroma_journey/modules/splash/splash_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(AuthService.new);
    i.addSingleton(ProductService.new);
    i.addSingleton(QuizzService.new);
    i.addSingleton(AuthBloc.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const SplashPage());
    r.module('/auth', module: AuthModule());
    r.module('/home', module: HomeModule());
    r.module('/product', module: ProductModule());
    r.module('/quizz', module: QuizzModule());
  }
}
