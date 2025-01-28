import 'package:flutter/material.dart';
import 'package:zovo/customer/view/homescreen/Userhompage.dart';
import 'package:zovo/customer/view/nearby/nearby_shop.dart';
import 'package:zovo/theme.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
     HomePage(),
     RestaurantListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.secondaryCream,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/home.png')),
            label: 'Offers'
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/nearby.png')),
            label: 'Nearby Shops',
          ),
        ],
      ),
    );
  }
}

