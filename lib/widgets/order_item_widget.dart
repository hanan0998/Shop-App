import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shop/models/providers/order_provider.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderItem order;
  OrderItemWidget(@required this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle:
                Text(DateFormat('dd MM yyyy hh:mm').format(order.dateTime)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
