abstract class ProductEvent {}

class ProductInitEvent extends ProductEvent {
  final String product;

  ProductInitEvent(this.product);
}
