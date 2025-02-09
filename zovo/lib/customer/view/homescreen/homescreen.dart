import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:zovo/customer/view/alloffers/todayOffers/Userhompage.dart';
import 'package:zovo/customer/view/homescreen/bloc/userlocation_bloc.dart';
import 'package:zovo/customer/view/nearby/allresturent.dart';
import 'package:zovo/customer/view/widgets/addresslocation.dart';
import 'package:zovo/theme.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
  
   fetchLocationDetails();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

void fetchLocationDetails() async {
  LocationDetails? locationDetails = await getUserLocationAndAddress();
  
  if (locationDetails != null) {
   
    print("Latitude: ${locationDetails.latitude}");
    print("Longitude: ${locationDetails.longitude}");
    print("Place Name: ${locationDetails.placeName}");
    print("City: ${locationDetails.locality}");
    print("State: ${locationDetails.state}");
    print("Country: ${locationDetails.country}");
    await BlocProvider.of<UserlocationBloc>(context)..add(locationt(city:locationDetails.locality , locationName: locationDetails.placeName, latitude: locationDetails.latitude, longitude: locationDetails.longitude, state: locationDetails.state));
  } else {
    print("Failed to fetch location details.");
  }
}

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
            ) ??
            false;
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(), // Prevents swipe gestures
          children: [
            HomePage(),
            TestNearby(),
          ],
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.secondaryCream,
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primaryOrange,
          unselectedItemColor: AppColors.primaryText,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300), // Smooth animation
              curve: Curves.easeInOut,
            );
          },
          items: const [
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/images/home.png')),
                label: 'Offers'),
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
