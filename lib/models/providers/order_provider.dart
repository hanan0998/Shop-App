import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final url = Uri.https(
        'flutter-devlopment-default-rtdb.firebaseio.com', '/orders.json');
    // storing the response from the firebase so that we get the id
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timeStamp));

    notifyListeners();
  }

  // method to fetchandset orders data from firebase
  Future<void> fetchAndSetData() async {
    final url = Uri.parse(
        'https://flutter-devlopment-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);
    // print(json.decode(response.body));
    List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price'],
                  ))
              .toList() as List<CartItem>,
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
