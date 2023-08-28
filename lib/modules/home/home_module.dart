import 'package:aroma_journey/modules/home/pages/home_page.dart';
import 'package:aroma_journey/modules/shared/navbar_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/',
        child: (context) => const NavBarPage(initialPage: HomePage.routeKey));
  }
}
