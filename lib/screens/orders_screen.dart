import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer_widget.dart';
import '../models/providers/order_provider.dart' show Orders;
import '../widgets/order_item_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetData();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Order screen built!");
    // commented this because we face an infinite loop
    // in the futurebuilder widget fetchAndSetData call it notifylisteners and the listener rebuilt again and infinit loop occure
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              // here is the stuff to handle the error
              return Center(
                child: Text("An error Occure"),
              );
            } else {
              return Consumer<Orders>(
                  builder: (context, value, child) => ListView.builder(
                        itemCount: value.orders.length,
                        itemBuilder: (context, index) =>
                            OrderItemWidget(value.orders[index]),
                      ));
            }
          }
        },
      ),
      drawer: MyDrawerWidget(),
    );
  }
}
