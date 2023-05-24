import 'package:flutter/material.dart';

import '../models/providers/product.dart';

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

  var _editedProduct = Product(
      id: '',
      title: 'title',
      description: 'description',
      imageUrl: 'imageUrl',
      price: 0.0);

  // for adding listener
  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  // adding function to point through listener
  void updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
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

// adding method to save the form
  void _saveForm() {
    // .validate return a boolean value
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
    print(_editedProduct.id);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
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
                        price: _editedProduct.price);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  // to take focus on the next text field
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionfocusNode);
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
                        price: double.parse(newValue!));
                  },
                ),
                TextFormField(
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
                        price: _editedProduct.price);
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
                      margin: EdgeInsets.only(top: 15, bottom: 10, right: 20),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
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
                        decoration: InputDecoration(labelText: 'Image Url'),
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
                          if (value.startsWith('http://') &&
                              value.startsWith('https://')) {
                            return 'Please, enter valid URL';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
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
