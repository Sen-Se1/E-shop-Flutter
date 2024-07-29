import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comerce/models/cart_model.dart';
import 'package:e_comerce/pages/checkout.dart';
import 'package:e_comerce/pages/navBar.dart';
import 'package:e_comerce/shared/constants.dart';
import 'package:e_comerce/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartModel>(context);

    void placeOrder() async {

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        showSnackbar(context, Colors.red, 'Please log in to place an order');
        return null;
      }

      final userEmail = user.email;
      final orderItems = cart.items
          .map((item) => {
        'productName': item.product.name,
        'productPrice': item.product.price,
        'quantity': item.quantity,
        'totalPrice': item.product.price * item.quantity,
      }).toList();

      if (orderItems.isEmpty) {
        showSnackbar(context, Colors.red, 'Please add items before making payment');
        return null;
      }

      final order = {
        'userEmail': userEmail,
        'orderItems': orderItems,
        'totalPrice': cart.totalPrice,
        'orderDate': Timestamp.now(),
      };

      nextScreen(context, CheckoutPage(order: order));

    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Your Cart',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            nextScreen(context, const NavbarPage());
          },
        ),
        backgroundColor: Constants().primaryColor,
      ),
      backgroundColor: Constants().bgColor,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = cart.items[index];
                return ListTile(
                  leading: cartItem.product.imageUrl != null &&
                          cartItem.product.imageUrl!.isNotEmpty
                      ? Image.network(cartItem.product.imageUrl!)
                      : Container(
                          height: 50,
                          width: 50,
                          color: Colors.grey[200],
                          child: Center(
                              child: Text('No Image',
                                  style: TextStyle(color: Colors.grey[600]))),
                        ),
                  title: Text(cartItem.product.name),
                  subtitle: Text(
                      'Qty: ${cartItem.quantity} - \$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: Constants().primaryColor,
                        ),
                        onPressed: () {
                          if (cartItem.quantity > 1) {
                            cart.updateItemQuantity(
                                cartItem.product, cartItem.quantity - 1);
                          } else {
                            cart.removeItem(cartItem.product);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Constants().primaryColor,
                        ),
                        onPressed: () {
                          cart.updateItemQuantity(
                              cartItem.product, cartItem.quantity + 1);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.remove_shopping_cart,
                          color: Constants().primaryColor,
                        ),
                        onPressed: () {
                          cart.removeItem(cartItem.product);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants().primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  onPressed: placeOrder,
                  child: Text('Proceed to Checkout',
                      style: TextStyle(color: Constants().bgColor)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
