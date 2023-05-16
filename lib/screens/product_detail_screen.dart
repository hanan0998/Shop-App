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
    final product = Provider.of<ProductProvider>(context, listen: false)
        .findById(productId);
    // it is good to make this logic in the provider file

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
