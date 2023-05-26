import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/providers/product_provider.dart';

import '../screens/edit_product_screen.dart';

class UserProductItemWidget extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItemWidget(
      {required this.id, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              )),
          IconButton(
              onPressed: () {
                context.read<ProductProvider>().deleteProduct(id);
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              )),
        ]),
      ),
    );
  }
}
