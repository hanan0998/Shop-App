import 'package:flutter/material.dart';

import '../widgets/product_gridview_widget.dart';
// import '../models/product.dart';
// import '../widgets/product_item_widget.dart';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showFavoriteOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOption value) {
                // print(value);
                setState(() {
                  if (value == FilterOption.Favorites) {
                    showFavoriteOnly = true;
                    // print(showFavoriteOnly);
                  } else {
                    showFavoriteOnly = false;
                  }
                });
              },
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Only Favorites"),
                      value: FilterOption.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text("Show All"),
                      value: FilterOption.All,
                    ),
                  ])
        ],
      ),
      body: ProductGridView(showFavoriteOnly),
    );
  }
}

// for the values of popupmenuitem
enum FilterOption {
  Favorites,
  All,
}
