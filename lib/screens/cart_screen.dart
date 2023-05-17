import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item_widget.dart';
import '../models/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: Theme.of(context).primaryTextTheme.titleMedium,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  // Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Order Now!",
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.item.length,
              itemBuilder: (context, index) {
                return CartItemWidget(
                    id: cart.item.values.toList()[index].id,
                    price: cart.item.values.toList()[index].price,
                    quantity: cart.item.values.toList()[index].quantity,
                    title: cart.item.values.toList()[index].title);
              },
            ),
          )
        ],
      ),
    );
  }
}
