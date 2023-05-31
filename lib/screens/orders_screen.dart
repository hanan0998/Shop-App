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
  var _isloading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        _isloading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetData();
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (context, index) =>
                  OrderItemWidget(orderData.orders[index]),
            ),
      drawer: MyDrawerWidget(),
    );
  }
}
