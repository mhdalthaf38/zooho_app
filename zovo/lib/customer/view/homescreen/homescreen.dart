import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zovo/customer/view/alloffers/Userhompage.dart';
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
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit from the app'),
            content: Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ?? false;
      },
      child: Scaffold(
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
      ),
    );
  }
}

