import 'package:e_comerce/helper/helper_function.dart';
import 'package:e_comerce/pages/auth/login.dart';
import 'package:e_comerce/service/auth_service.dart';
import 'package:e_comerce/widgets/product.dart';
import 'package:e_comerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:e_comerce/pages/cart/cart_page.dart';
import 'package:e_comerce/shared/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _categories = [
    'All',
    'PC',
    'Phone',
    'Tablet',
    'Accessory',
    'Other'
  ];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String userId = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserIdFromSF().then((value) {
      setState(() {
        userId = value!;
      });
    });
  }

  void _onSearchQueryChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('DP Shop', style: TextStyle(color: Colors.white)),
        backgroundColor: Constants().primaryColor,
        elevation: 0,
        leading: null,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              nextScreen(context, const CartPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await AuthService().signOut(context);
                            nextScreenRemove(context, const LoginPage());
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      backgroundColor: Constants().bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSearchBar(_searchQuery, _onSearchQueryChanged),
            const SizedBox(height: 16),
            buildCategorySection(_categories, _selectedCategory, _onCategorySelected),
            const SizedBox(height: 16),
            buildProductList(context, _searchQuery, _selectedCategory, userId),
          ],
        ),
      ),
    );
  }
}
