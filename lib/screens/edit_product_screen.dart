import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/providers/product.dart';
import '../models/providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-screen';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionfocusNode = FocusNode();
  // using textediting controllor because we have to show image before submition
  final _imageUrlControllor = TextEditingController();
  // adding image url focus node so that it will show preview of image when focus is transfter on the other text field
  final _imageUrlFocusNode = FocusNode();
  // adding global key to interact with form widget
  final _form = GlobalKey<FormState>();
  var init = true;
  var isLoading = false;
  var initvalues = {
    'title': '',
    'description': '',
    'price': '',
  };

  var _editedProduct = Product(
      id: null,
      title: 'title',
      description: 'description',
      imageUrl: 'imageUrl',
      price: 0.0);

  @override
  void didChangeDependencies() {
    if (init) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        _editedProduct =
            context.read<ProductProvider>().findById(productId as String);
        // print(_editedProduct.id);
        initvalues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
        };
        _imageUrlControllor.text = _editedProduct.imageUrl;
      }
    }
    init = false;

    super.didChangeDependencies();
  }

  // for adding listener
  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  // adding function to point through listener
  void updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlControllor.text.startsWith('http://') &&
              !_imageUrlControllor.text.startsWith('https://')) ||
          (!_imageUrlControllor.text.endsWith('.png') &&
              !_imageUrlControllor.text.endsWith('.jpg') &&
              !_imageUrlControllor.text.endsWith('.jpeg') &&
              !_imageUrlControllor.text.endsWith('=CAU'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionfocusNode.dispose();
    _imageUrlControllor.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

// as the .addProduct is async function you also convert _saveForm into async
  void _saveForm() async {
    // .validate return a boolean value
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    // to save every field of the form using onsaved parameter
    _form.currentState!.save();
    setState(() {
      isLoading = true;
    });
    if (_editedProduct.id != null) {
      // print(_editedProduct.id);
      print("update Product is called!");
      context
          .read<ProductProvider>()
          .updateProduct(_editedProduct.id!, _editedProduct);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        // here you use the await because the addProduct return the future, we have to wait to the future
        await context.read<ProductProvider>().addProduct(_editedProduct);
      } catch (error) {
        // as the showDialog returns a future we use 'await' to
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("An error occured!"),
            content: Text('Something went wrong'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Okay"))
            ],
          ),
        );
        // the finally block always execute whether the try  or catch block will execute properlly or not
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }

    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
              // alignment: Alignment.centerRight ,
              onPressed: _saveForm,
              icon: Icon(
                Icons.send_and_archive_outlined,
                size: 30,
              ))
        ],
      ),
      // using ternary operator to check the the product is send to server or note
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: initvalues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          // to transfer focus to the next fieold
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          }
                          return 'Provide the Title';
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: newValue!,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: initvalues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        // to take focus on the next text field
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionfocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please, enter a valid number!';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please, enter number greater than zero';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: double.parse(newValue!),
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: initvalues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionfocusNode,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: newValue!,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please, enter the description';
                          }
                          if (value.length < 10) {
                            return 'Should be atleast 10 characters!';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin:
                                EdgeInsets.only(top: 15, bottom: 10, right: 20),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlControllor.text.isEmpty
                                ? Center(
                                    child: const Text(
                                      "Enter URL",
                                      // textAlign: TextAlign.center,
                                    ),
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlControllor.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              // initialValue: initvalues['imageUrl'],
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlControllor,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please, enter image url';
                                }
                                if (!value.startsWith('http://') &&
                                    !value.startsWith('https://')) {
                                  return 'Please, enter valid URL';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg') &&
                                    !value.endsWith('=CAU')) {
                                  return 'Please, enter a valid image URL1';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                    isFavorite: _editedProduct.isFavorite,
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    imageUrl: newValue!,
                                    price: _editedProduct.price);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
