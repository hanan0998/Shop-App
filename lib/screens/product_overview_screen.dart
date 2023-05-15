import 'package:flutter/material.dart';

import '../widgets/product_gridview_widget.dart';
// import '../models/product.dart';
// import '../widgets/product_item_widget.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: ProductGridView(),
    );
  }
}
