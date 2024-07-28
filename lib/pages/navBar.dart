import 'package:e_comerce/pages/customerService.dart';
import 'package:e_comerce/pages/home.dart';
import 'package:e_comerce/pages/profile.dart';
import 'package:e_comerce/shared/constants.dart';
import 'package:flutter/material.dart';

class NavbarPage extends StatefulWidget {
  const NavbarPage({super.key});

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const ProfilePage(),
    const HomePage(),
    const Customerservice()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Constants().primaryColor,
      unselectedItemColor: Colors.white,
      selectedItemColor: Constants().TextColor,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.support_agent),
          label: 'Customer Service',
        ),
      ],
    );
  }
}
