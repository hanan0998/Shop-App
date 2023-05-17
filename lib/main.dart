import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/providers/cart_provider.dart';
import './models/providers/product_provider.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';

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
      ],
      // value: ProductProvider(),
      child: MaterialApp(
        title: 'Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Lato',
          // canvasColor: Colors.pink,
          colorScheme: ColorScheme.light(secondary: Colors.deepOrange),
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
        },
      ),
    );
  }
}
