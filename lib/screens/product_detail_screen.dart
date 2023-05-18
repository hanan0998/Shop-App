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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Card(
                margin: EdgeInsets.all(20),
                elevation: 5,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${product.price}',
              style: TextStyle(color: Colors.grey, fontSize: 30),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                product.description,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
