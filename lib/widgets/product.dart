import 'package:e_comerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:e_comerce/models/product_model.dart';
import 'package:e_comerce/pages/products/product_detail_page.dart';
import 'package:e_comerce/service/product_service.dart';
import 'package:e_comerce/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comerce/models/cart_model.dart';

Widget buildSearchBar(String searchQuery, Function(String) onChanged) {
  return TextField(
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: 'Search here...',
      prefixIcon: const Icon(Icons.search),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}

Widget buildCategorySection(List<String> categories, String selectedCategory, Function(String) onCategorySelected) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            return _buildCategoryChip(
                category, selectedCategory, onCategorySelected);
          }).toList(),
        ),
      ),
    ],
  );
}

Widget _buildCategoryChip(String label, String selectedCategory, Function(String) onCategorySelected) {
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: ChoiceChip(
      label: Text(label),
      selected: selectedCategory == label,
      onSelected: (bool selected) {
        onCategorySelected(selected ? label : selectedCategory);
      },
    ),
  );
}

Widget buildProductList(BuildContext context, String searchQuery, String selectedCategory, String userId) {
  ProductService productService = ProductService();
  return Expanded(
    child: StreamBuilder<QuerySnapshot>(
      stream: productService.getProductStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.requireData;

        // Filter products locally based on search query and selected category
        final filteredProducts = data.docs.where((doc) {
          final product = Product.fromFirestore(doc);
          // print(product.uid);
          final query = searchQuery.toLowerCase();
          final matchesSearchQuery =
              product.name.toLowerCase().contains(query) ||
                  product.description.toLowerCase().contains(query);
          final matchesCategory = selectedCategory == 'All' ||
              product.category.toLowerCase() == selectedCategory.toLowerCase();
          return matchesSearchQuery && matchesCategory;
        }).toList();

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.65,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = Product.fromFirestore(filteredProducts[index]);
            return _buildProductCard(context, product, userId);
          },
        );
      },
    ),
  );
}

Widget _buildProductCard(BuildContext context, Product product, String userId) {
  final productService = ProductService();

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {

      Future<void> checkIfFavorite() async {
        List<String> favoriteItems =
            await productService.getFavoriteItems(userId);
        setState(() {
          product.isFavorite = favoriteItems.contains(product.uid);
        });
      }

      // Initialize the state
      setState(() {
        checkIfFavorite();
        return;
      });

      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                nextScreen(context, ProductDetailPage(product: product));
              },
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8.0)),
                child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? Image.network(
                        product.imageUrl!,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 130,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Center(
                            child: Text('No Image',
                                style: TextStyle(color: Colors.grey[600]))),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      nextScreen(context, ProductDetailPage(product: product));
                    },
                    child: Text(
                      product.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description.split('\n').first,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Constants().primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    color: Constants().primaryColor,
                    onPressed: () async {
                      setState(() {
                        product.isFavorite = !product.isFavorite;
                      });
                      await productService.updateFavoriteStatus(
                        userId,
                        product.uid,
                        product.isFavorite,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    color: Constants().primaryColor,
                    onPressed: () {
                      // Add the product to the cart
                      Provider.of<CartModel>(context, listen: false)
                          .addItem(product);

                      // Show a SnackBar message
                      showSnackbar(context, Colors.green,
                          '${product.name} added to cart!');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
