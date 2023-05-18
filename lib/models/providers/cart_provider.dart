import 'package:flutter/foundation.dart';

// simple class
class CartItem {
  final String title;
  final String id;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

// Provider class
class Cart with ChangeNotifier {
  Map<String, CartItem>? _items = {};
  Map<String, CartItem> get item {
    return {..._items!};
  }

  // getter for the total product in the _item
  int get productAmount {
    return _items!.length;
  }

  // getter for total amount
  double get totalAmount {
    var total = 0.0;
    _items!.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items!.containsKey(productId)) {
      _items!.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price));
    } else {
      _items!.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

// to remove the key and value from the map
  void removeItem(String productId) {
    _items!.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
