import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });
  // for the toggling between the true and false
  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    // to tell all the listerns about the update
    notifyListeners();
  }
}
