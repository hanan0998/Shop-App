import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

// mixin the class by using 'with' keyword with ChangeNotifier
// because the provider package use it  behind the scene
class ProductProvider with ChangeNotifier {
  List<Product> _item = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // bool showFavoritesOnly = false;
  List<Product> get item {
    // if (showFavoritesOnly) {
    //   return _item.where((element) => element.isFavorite).toList();
    // } else {
    return [..._item];
    // }
  }

  List<Product> get favorItem {
    return _item.where((element) => element.isFavorite).toList();
  }

  // void showFavoriteOnly() {
  //   showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _item.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) {
    final url = Uri.https(
        'flutter-devlopment-default-rtdb.firebaseio.com', '/product.json');
    return http
        .post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'isFavorite': product.isFavorite
            }))
        .then((response) {
      // thi.response it the instance of response and should be decoded to get the map which contain id
      print(json.decode(response.body));
      // adding logic to add item in list is in the then method because to get the id from the firebase
      final item = Product(
          // giving the id generated by firebase
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _item.add(item);

      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
    // print(url);
  }

  // method to update the product
  void updateProduct(String id, Product product) {
    // storing the url which firebase give us

    final prodindex = _item.indexWhere((element) => element.id == id);
    if (prodindex >= 0) {
      _item[prodindex] = product;
      notifyListeners();
    } else {
      print('...');
    }
  }

  // method to delete the product
  void deleteProduct(String id) {
    _item.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  // Future<http.Response> createAlbum(Product product) {
  //   return http.post(
  //     Uri.parse('https://flutter-devlopment-default-rtdb.firebaseio.com/'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'title': product.title,
  //     }),
  //   );
  // }
}
