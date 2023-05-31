import 'package:flutter/material.dart';
import '../models/providers/order_provider.dart';
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
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).primaryTextTheme.titleMedium,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  // Spacer(),
                  CartButton(cart: cart),
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
                    productId: cart.item.keys.toList()[index],
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

class CartButton extends StatefulWidget {
  const CartButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: isLoading
          ? CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              strokeWidth: 2,
            )
          : Text(
              "Order Now!",
            ),
      onPressed: (widget.cart.totalAmount <= 0 || isLoading == true)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.item.values.toList(), widget.cart.totalAmount);
              setState(() {
                isLoading = false;
              });
              widget.cart.clear();
            },
    );
  }
}
