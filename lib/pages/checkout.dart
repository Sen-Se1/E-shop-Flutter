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
        color: Colors.white,
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
      Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black45.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: _firstNameController,
          obscureText: true,
          decoration: textInputDecoration.copyWith(
            hintText: "First Name and Last Name",
            suffixIcon: const Icon(Icons.person,
                color: Colors.black12),
          ),
          validator: (value) {
            if (value!.isNotEmpty) {
              return null;
            } else {
              return "Please enter your first name and last name";
            }
          },

        ),
      ),
    ),
    Padding(
    padding: const EdgeInsets.symmetric(
    horizontal: 20, vertical: 10),
    child: Container(
    padding: const EdgeInsets.symmetric(
    horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
    BoxShadow(
    color: Colors.black45.withOpacity(0.3),
    spreadRadius: 3,
    blurRadius: 3,
    offset: const Offset(0, 2),
    ),
    ],
    ),
    child: TextFormField(
    controller: _cardNumberController,
    obscureText: true,
    decoration: textInputDecoration.copyWith(
    hintText: "Card Number",
    suffixIcon: const Icon(Icons.credit_card,
    color: Colors.black12),
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
    ),
    ),
    Padding(
    padding: const EdgeInsets.symmetric(
    horizontal: 20, vertical: 10),
    child: Container(
    padding: const EdgeInsets.symmetric(
    horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
    BoxShadow(
    color: Colors.black45.withOpacity(0.3),
    spreadRadius: 3,
    blurRadius: 3,
    offset: const Offset(0, 2),
    ),
    ],
    ),
    child: TextFormField(
    controller: _expiryDateController,
    obscureText: true,
    decoration: textInputDecoration.copyWith(
    hintText: "Expiry Date",
    suffixIcon: const Icon(Icons.date_range,
    color: Colors.black12),
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
    ),
    ),
    Padding(
    padding: const EdgeInsets.symmetric(
    horizontal: 20, vertical: 10),
    child: Container(
    padding: const EdgeInsets.symmetric(
    horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
    BoxShadow(
    color: Colors.black45.withOpacity(0.3),
    spreadRadius: 3,
    blurRadius: 3,
    offset: const Offset(0, 2),
    ),
    ],
    ),
    child: TextFormField(
    controller: _cvvController,
    obscureText: true,
    decoration: textInputDecoration.copyWith(
    hintText: "CVV",
    suffixIcon: const Icon(Icons.lock,
    color: Colors.black12),
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
    ),
    ),] else if (_selectedPaymentMethod == 'PayPal') ...[
    Padding(
    padding: const EdgeInsets.symmetric(
    horizontal: 20, vertical: 10),
    child: Container(
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    ),
    child: Container(
    padding: const EdgeInsets.symmetric(
    horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
    BoxShadow(
    color: Colors.black45.withOpacity(0.3),
    spreadRadius: 3,
    blurRadius: 3,
    offset: const Offset(0, 2),
    ),
    ],
    ),
    child: TextFormField(
    decoration: textInputDecoration.copyWith(
    hintText: " Paypal Email...",
    suffixIcon: const Icon(Icons.email_outlined,
    color: Colors.black12),
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
    ),
    ),
    ),


    Padding(
    padding: const EdgeInsets.symmetric(
    horizontal: 20, vertical: 10),
    child: Container(
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    ),
    child: Container(
    padding: const EdgeInsets.symmetric(
    horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
    BoxShadow(
    color: Colors.black45.withOpacity(0.3),
    spreadRadius: 3,
    blurRadius: 3,
    offset: const Offset(0, 2),
    ),
    ],
    ),
    child: TextFormField(
    decoration: textInputDecoration.copyWith(
    hintText: "Paypal Password...",
    suffixIcon: const Icon(Icons.password_outlined,
    color: Colors.black12),
    ),
    obscureText: true,
    validator: (value) {
    if (value!.isEmpty) {
    return 'Please enter your PayPal password';
    }
    return null;
    },
    ),
    ),
    ),
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
