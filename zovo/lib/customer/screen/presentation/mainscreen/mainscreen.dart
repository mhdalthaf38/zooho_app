import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/customer/screen/presentation/mainscreen/homescreen/home.dart';
import 'package:zovo/customer/screen/presentation/mainscreen/preorderpage/Preorderpage.dart';
import 'package:zovo/customer/screen/presentation/mainscreen/homescreen/profilepage/profile.dart';
import 'package:zovo/customer/screen/widgets/popupwidget.dart';
import 'package:zovo/theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Fetching screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      body: [
        HomeScreen(),
        MyOrdersScreen(),

        // Add other screens if needed
      ][_currentIndex],

      // Conditionally render the FloatingActionButton
     floatingActionButton: 
     Padding(
        padding: EdgeInsets.all(screenWidth * 0.025),
        child: SizedBox(
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: AppColors.primaryOrange,
            onPressed: () {
              showPopup(context); // Call the function to show the popup
            },
            child: Image.asset(
              'assets/images/add.png',
              width: screenWidth * 0.05,
              color: AppColors.secondaryCream,
            ),
          ),
        ),
      ),
   


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Conditionally render the BottomAppBar
      bottomNavigationBar: _currentIndex == 0
          ? BottomAppBar(
            height: screenHeight * 0.07,
              color: AppColors.primaryOrange,
              shape: const CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/home.png',
                          width: screenWidth * 0.06,
                          height: screenHeight * 0.04,
                          color: AppColors.secondaryCream,
                        ),
                      ],
                    ),
                  ),
                  Container(alignment: AlignmentDirectional.bottomCenter),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/user.png',
                          width: screenWidth * 0.06,
                          height: screenHeight * 0.04,
                          color: AppColors.secondaryCream,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : null, // Hide BottomAppBar if not on HomeScreen
    );
  }
}
