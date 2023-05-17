import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../models/providers/product_provider.dart';
import '../models/providers/cart_provider.dart';
import '../models/providers/product.dart';
import '../screens/product_detail_screen.dart';

// import '../screens/product_overview_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<Product>(context, listen: false);
    // print('Product Rebuilt!');
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: productItem.id);
          },
          child: Image.network(
            productItem.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            productItem.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (context, value, child) => IconButton(
              icon: Icon(productItem.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border_outlined),
              color: Colors.deepOrange,
              onPressed: () {
                productItem.toggleFavoriteStatus();
              },
            ),
            child: Text("hi! I will not rebuild!"),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              cart.addItem(
                  productItem.id, productItem.price, productItem.title);
            },
          ),
        ),
      ),
    );
  }
}
