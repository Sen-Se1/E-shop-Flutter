import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comerce/models/cart_model.dart';
import 'package:e_comerce/pages/navBar.dart';
import 'package:e_comerce/shared/constants.dart';
import 'package:e_comerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> order;

  const CheckoutPage({super.key, required this.order});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _paypalEmailController = TextEditingController();
  final _paypalPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();

  String _selectedPaymentMethod = 'Credit Card';

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _paypalEmailController.dispose();
    _paypalPasswordController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  void _submitOrder() async{
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('orders').add(widget.order);
      Provider.of<CartModel>(context, listen: false).clearCart();
      showSnackbar(context, Colors.green, 'Order placed successfully!');
      nextScreen(context, const NavbarPage());
      _cardNumberController.clear();
      _expiryDateController.clear();
      _cvvController.clear();
      _paypalEmailController.clear();
      _paypalPasswordController.clear();
      _firstNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryColor,
        centerTitle: true,
        title: const Text('Checkout Page'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            nextScreen(context, const NavbarPage());
          },
        ),
      ),
      body: Container(
        color: Constants().bgColor,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text('Payment Method', style: TextStyle(fontSize: 18)),
              RadioListTile(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/Credit Card.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text('Credit Card'),
                  ],
                ),
                value: 'Credit Card',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value.toString();
                  });
                },
              ),
              RadioListTile(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/paypal.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text('PayPal'),
                  ],
                ),
                value: 'PayPal',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value.toString();
                  });
                },
              ),
              if (_selectedPaymentMethod == 'Credit Card') ...[
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name and Last Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return null;
                    } else {
                      return "Please enter your first name and last name";
                    }
                  },
                ),
                TextFormField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your card number';
                    }
                    if (value.length != 16) {
                      return 'Card number must be 16 digits';
                    }
                    if (!RegExp(r'^\d{16}$').hasMatch(value)) {
                      return 'Card number must be all digits';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _expiryDateController,
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date',
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter expiry date';
                    }

                    final regex = RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$');
                    if (!regex.hasMatch(value)) {
                      return 'Invalid date format. Use MM/YY';
                    }

                    final parts = value.split('/');
                    final month = int.parse(parts[0]);
                    final year = int.parse(parts[1]) + 2000;

                    final now = DateTime.now();
                    final expiryDate = DateTime(year, month);

                    if (expiryDate.isBefore(DateTime(now.year, now.month))) {
                      return 'Expiry date cannot be in the past';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: _cvvController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter CVV';
                    }
                    if (value.length != 3) {
                      return 'CVV must be 3 digits';
                    }

                    if (!RegExp(r'^\d{3}$').hasMatch(value)) {
                      return 'CVV must be all digits';
                    }

                    return null;
                  },
                ),
              ] else if (_selectedPaymentMethod == 'PayPal') ...[
                TextFormField(
                  controller: _paypalEmailController,
                  decoration: const InputDecoration(
                    labelText: 'PayPal Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)
                        ? null
                        : "Please enter a valid email";
                  },
                ),
                TextFormField(
                  controller: _paypalPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'PayPal Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your PayPal password';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants().primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadowColor: Colors.black45.withOpacity(0.9),
                  elevation: 5,
                ),
                child: const Text(
                  'Submit Order',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
