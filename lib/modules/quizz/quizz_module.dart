import 'package:aroma_journey/modules/quizz/pages/quizz_pages.dart';
import 'package:aroma_journey/modules/shared/navbar_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class QuizzModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/',
        child: (context) => const NavBarPage(initialPage: QuizzPage.routeKey));
  }
}
