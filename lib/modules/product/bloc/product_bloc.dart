import 'package:aroma_journey/modules/product/product_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitState()) {
    on<ProductInitEvent>(
        (event, emit) => _onProductInitEvent(event.product, emit));
  }

  void _onProductInitEvent(String coffee, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoadingState());
      Map<String, String> response = await service.multiGeneration(coffee);
      emit(ProductSuccessState(response: response));
    } catch (_) {
      emit(ProductErrorState());
    }
  }

  ProductService get service => Modular.get<ProductService>();
}
