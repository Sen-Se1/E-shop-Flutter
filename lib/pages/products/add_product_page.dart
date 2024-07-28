
import 'package:e_comerce/shared/constants.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../home.dart';
import '../../models/product_model.dart';
import '../../service/product_service.dart';
import '../../widgets/widgets.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File? _image;
  final ProductService _productService = ProductService();
  String? _selectedCategory;

  final List<String> _categories = ['PC', 'Phone', 'Tablet', 'Accessory'];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _createProduct() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final category = _selectedCategory;
      final price = double.parse(_priceController.text);

      final product = Product(
        uid: 'uid',
        name: name,
        description: description,
        category: category!,
        price: price,
      );

      await _productService.createProduct(product, _image);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product', style: TextStyle(color: Colors.white)),
        backgroundColor: Constants().primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 80),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Product Name',
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a product name' : null,
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Product Description',
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a product description' : null,
                  ),
                  SizedBox(height: 12),
                  _buildDropdownField(
                    value: _selectedCategory,
                    items: _categories,
                    label: 'Product Category',
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty ? 'Please select a product category' : null,
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    controller: _priceController,
                    label: 'Product Price',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter a product price';
                      if (double.tryParse(value) == null) return 'Please enter a valid price';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _image == null
                      ? TextButton(
                    onPressed: _pickImage,
                    child: Text(
                      'Pick Product Image',
                      style: TextStyle(color: Constants().primaryColor),
                    ),
                  )
                      : Image.file(_image!),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants().primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: () {
                      _createProduct();

                      nextScreen(context,const HomePage());
                    },
                    child: Text('Add Product', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Constants().primaryColor),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Constants().primaryColor),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Constants().primaryColor),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String label,
    required Function(String?) onChanged,
    String? Function(String?)? validator,

  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Constants().primaryColor),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Constants().primaryColor),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Constants().primaryColor),
        ),
      ),
      items: items.map((String category) {
        return  DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      dropdownColor: Constants().primaryColor,

    );
  }
}
