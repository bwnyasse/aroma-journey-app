abstract class CoffeeEvent {}

class CoffeeInitEvent extends CoffeeEvent {
  final String coffee;

  CoffeeInitEvent(this.coffee);
}
