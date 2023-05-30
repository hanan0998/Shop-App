import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/providers/product_provider.dart';
import '../widgets/user_product_item_widget.dart';
import '../widgets/app_drawer_widget.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';
  const UserProductScreen({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetData();
  }

  @override
  Widget build(BuildContext context) {
    final productData = context.watch<ProductProvider>();
    return Scaffold(
      // drawer: MyDrawerWidget(),
      appBar: AppBar(
        title: const Text("Your Products"),
        // automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      drawer: MyDrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        displacement: 30,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: productData.item.length,
            itemBuilder: (context, index) => Column(
              children: [
                UserProductItemWidget(
                    id: productData.item[index].id!,
                    title: productData.item[index].title,
                    imageUrl: productData.item[index].imageUrl),
                Divider(thickness: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
