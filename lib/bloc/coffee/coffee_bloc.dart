import 'package:aroma_journey/services/coffee_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'coffee_event.dart';
import 'coffee_state.dart';

class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  CoffeeBloc() : super(CoffeeInitState()) {
    on<CoffeeInitEvent>(
        (event, emit) => _onCoffeeInitEvent(event.coffee, emit));
  }

  void _onCoffeeInitEvent(String coffee, Emitter<CoffeeState> emit) async {
    try {
      emit(CoffeeLoadingState());
      Map<String, String> response = await service.multiGeneration(coffee);
      emit(CoffeeSuccessState(response: response));
    } catch (_) {
      emit(CoffeeErrorState());
    }
  }

  CoffeeService get service => Modular.get<CoffeeService>();
}
