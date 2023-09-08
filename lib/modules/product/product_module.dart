import 'package:aroma_journey/modules/product/bloc/product_bloc.dart';
import 'package:aroma_journey/modules/product/pages/product_invention_page.dart';
import 'package:aroma_journey/modules/product/pages/product_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProductModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/:productRef',
        child: (context) => BlocProvider(
              create: (context) => ProductBloc(),
              child: ProductPage(productRecord: r.args.data),
            ));
    r.child(
      '/invention/:productInvention',
      child: (context) =>
          ProductInventionPage(productInventionModel: r.args.data),
    );
  }
}
