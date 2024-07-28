// cart_model.dart
import 'package:flutter/material.dart';
import '../pages/cart/cart_item.dart';
import 'product_model.dart';


class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(Product product) {
    final existingItemIndex = _items.indexWhere((item) => item.product.name == product.name);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += 1;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.removeWhere((item) => item.product.name == product.name);
    notifyListeners();
  }

  void updateItemQuantity(Product product, int quantity) {
    final index = _items.indexWhere((item) => item.product.name == product.name);
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  double get totalPrice {
    return _items.fold(0, (total, item) => total + (item.product.price * item.quantity));
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
