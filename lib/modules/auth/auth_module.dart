import 'package:aroma_journey/modules/auth/pages/auth_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const AuthPage());
  }
}
