import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer_widget.dart';
import '../models/providers/order_provider.dart' show Orders;
import '../widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (context, index) =>
            OrderItemWidget(orderData.orders[index]),
      ),
      drawer: MyDrawerWidget(),
    );
  }
}
