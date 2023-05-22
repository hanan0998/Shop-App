import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/providers/order_provider.dart';
import './screens/cart_screen.dart';
import './models/providers/cart_provider.dart';
import './models/providers/product_provider.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/orders_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();
  @override
  Widget build(BuildContext context) {
    // setting up the provider here
    return MultiProvider(
      // using package version greater than 4 use create rather than builder
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Orders()),
      ],
      // value: ProductProvider(),
      child: MaterialApp(
        title: 'Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.purple,
          fontFamily: 'Lato',
          // canvasColor: Colors.pink,
          colorScheme: ColorScheme.light(
              secondary: Colors.deepOrange, error: Colors.red.shade700),
        ),
        home: ProductsOverviewScreen(),
        routes: {
          // '/mainScreen': (context) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrdersScreen.routeName: (context) => OrdersScreen(),
        },
      ),
    );
  }
}
