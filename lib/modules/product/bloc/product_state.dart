abstract class ProductState {}

class ProductInitState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductSuccessState extends ProductState {
  final Map<String, String> response;

  ProductSuccessState({required this.response});
}

class ProductErrorState extends ProductState {}

class ProductContentState extends ProductState {
  final String content;

  ProductContentState({required this.content});
}
