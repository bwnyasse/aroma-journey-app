abstract class CoffeeState {}

class CoffeeInitState extends CoffeeState {}

class CoffeeLoadingState extends CoffeeState {}

class CoffeeSuccessState extends CoffeeState {
  final Map<String, String> response;

  CoffeeSuccessState({required this.response});
}

class CoffeeErrorState extends CoffeeState {}

class CoffeeContentState extends CoffeeState {
  final String content;

  CoffeeContentState({required this.content});
}
