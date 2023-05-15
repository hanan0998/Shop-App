import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // ProductDetailScreen(this.title);
  static const routeName = '/product-detail-screen';

  @override
  Widget build(BuildContext context) {
    // extracting the arguments comming for the namedroute
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    // adding listener
    final productdata = Provider.of<ProductProvider>(context);
    final product = productdata.item.where(
      (element) => element.id == productId,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
    );
  }
}
