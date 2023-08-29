import 'package:aroma_journey/modules/product/pages/product_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProductModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/:productRef',
        child: (context) => ProductPage(productRef: r.args.data));
  }
}
