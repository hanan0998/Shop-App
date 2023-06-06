import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shop/models/providers/product.dart';
import 'package:shop/screens/product_overview_screen.dart';

import './models/providers/order_provider.dart';
import './screens/cart_screen.dart';
import './models/providers/cart_provider.dart';
import './models/providers/product_provider.dart';
import './screens/product_detail_screen.dart';
// import './screens/product_overview_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './models/providers/auth_provider.dart';

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
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          create: (context) => ProductProvider(),
          update: (context, Auth, data) => data!
            ..update(Auth.token as String, data == null ? [] : data.item),
        ),
        ChangeNotifierProvider(create: (context) => Orders()),
        ChangeNotifierProvider(create: (context) => Cart()),
      ],
      // value: ProductProvider(),
      child: Consumer<Auth>(
        builder: (context, Auth, child) => MaterialApp(
          title: 'Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              // accentColor: myColor,
              // useMaterial3: true,
              textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.white)),
              primaryColor: Colors.purple,
              fontFamily: 'Lato',
              // canvasColor: Colors.pink,
              colorScheme: ColorScheme.light(
                secondary: Colors.deepOrange,
                error: Colors.red.shade700,
              ),
              primaryTextTheme: TextTheme(labelLarge: TextStyle(color: null))),
          routes: {
            // '/mainScreen': (context) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            AuthScreen.routeName: (context) => AuthScreen()
          },
          initialRoute: AuthScreen.routeName,
          home: Auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
        ),
      ),
    );
  }
}
