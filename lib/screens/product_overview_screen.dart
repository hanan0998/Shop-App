import 'package:provider/provider.dart';
// import 'dart:html';

import 'package:flutter/material.dart';
import '../models/providers/cart_provider.dart';
import '../models/providers/product_provider.dart';
import './cart_screen.dart';
import '../widgets/app_drawer_widget.dart';

import '../widgets/badge.dart';
import '../widgets/product_gridview_widget.dart';
// import '../models/product.dart';
// import '../widgets/product_item_widget.dart';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showFavoriteOnly = false;
  var _initState = true;
  var isLoading = false;

  @override
  void initState() {
    // you cannot use context.watch inside the initstate
    // context.watch<ProductProvider>().fetchAndSetData();
    // Future.delayed(Duration.zero).then((value) {
    //   context.watch<ProductProvider>().fetchAndSetData();
    // });

    super.initState();
  }

// we cannot use async and await in the override methods so we use then
  @override
  void didChangeDependencies() {
    if (_initState) {
      setState(() {
        isLoading = true;
      });
      context.watch<ProductProvider>().fetchAndSetData().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
    _initState = false;
    super.didChangeDependencies();
  }

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
            ],
          ),
          Consumer<Cart>(
            builder: (context, cart, ch) => MyBadge(
              value: cart.productAmount.toString(),
              child: ch!,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
        ],
      ),
      drawer: MyDrawerWidget(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGridView(showFavoriteOnly),
    );
  }
}

// for the values of popupmenuitem
enum FilterOption {
  Favorites,
  All,
}
