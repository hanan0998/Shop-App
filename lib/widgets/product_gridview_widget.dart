import 'package:flutter/material.dart';
import './product_item_widget.dart';
// import '../models/product.dart';
import 'package:provider/provider.dart';
import '../models/providers/product_provider.dart';

class ProductGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // addinng listner which is provider by provider package
    final products = Provider.of<ProductProvider>(context, listen: true).item;
    // final products = productData.item;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        create: (context) => products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
