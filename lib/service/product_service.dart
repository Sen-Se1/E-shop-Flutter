import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comerce/models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createProduct(Product product, File? image) async {
    String? imageUrl;

    if (image != null) {
      imageUrl = await _uploadImage(image);
    }

    final docRef = await _firestore.collection('products').add(product.toMap());
    final uid = docRef.id;
    final updatedProduct = product.copyWith(uid: uid, imageUrl: imageUrl);
    await docRef.set(updatedProduct.toMap());
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = _storage.ref().child('product_images/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Stream<QuerySnapshot> getProductStream() {
    final query = FirebaseFirestore.instance.collection('products');

    // Apply category filter
    Query filteredQuery = query;

    return filteredQuery.snapshots();
  }

  Future<void> updateFavoriteStatus(String userId, String productId, bool isFavorite) async {
    final userDocRef = _firestore.collection('users').doc(userId);
    final userDoc = await userDocRef.get();
print(userId);
    if (userDoc.exists) {
      List<String> favoriteItems = List<String>.from(userDoc['favoriteItems']);

      if (isFavorite) {
        favoriteItems.add(productId);
      } else {
        favoriteItems.remove(productId);
      }

      await userDocRef.update({'favoriteItems': favoriteItems});
    }
  }

  Future<List<String>> getFavoriteItems(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return List<String>.from(userDoc.data()?['favoriteItems'] ?? []);
    }
    return [];
  }
}
