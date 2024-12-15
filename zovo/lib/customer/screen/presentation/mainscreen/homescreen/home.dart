import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/customer/screen/presentation/mainscreen/homescreen/menupage/menupage.dart';
import 'package:zovo/customer/screen/presentation/mainscreen/homescreen/profilepage/profile.dart';
import 'package:zovo/customer/screen/presentation/mainscreen/homescreen/todayofferscreen/todayoffers.dart';
import 'package:zovo/theme.dart';
import 'offerpage/offerpage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.primaryOrange,
        appBar: AppBar(
          backgroundColor: AppColors.secondaryCream,
          title: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical: screenHeight * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ZOho',
                  style: GoogleFonts.poppins(
                        color: AppColors.primaryOrange,
                       fontSize: screenWidth * 0.07, 
                         fontWeight: FontWeight.w900
                      )
                ),
                GestureDetector(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),));
                },
                  child: ImageIcon(AssetImage('assets/images/profile-user.png',),color:AppColors.primaryOrange ,size: screenWidth * 0.07,)),
               
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            unselectedLabelColor: AppColors.secondaryText,
            labelColor: AppColors.primaryText,
          indicatorColor: AppColors.accentRed,
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: screenHeight * 0.02,
                  right: screenWidth * 0.05,
                ),
                child: Text(
                  'Today Offers',
                  style:  GoogleFonts.poppins(
                  
                   fontSize: screenWidth * 0.04, 
                     fontWeight: FontWeight.w900
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: screenHeight * 0.02,
                  right: screenWidth * 0.05,
                ),
                child: Text(
                  'Offers',
                  style: GoogleFonts.poppins(
                  
                   fontSize: screenWidth * 0.04, 
                     fontWeight: FontWeight.w900
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: screenHeight * 0.02,
                  right: screenWidth * 0.05,
                ),
                child: Text(
                  'Menu',
                  style: GoogleFonts.poppins(
                  
                   fontSize: screenWidth * 0.04, 
                     fontWeight: FontWeight.w900
                  )
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TodayofferScreen(),
            Offerpage(),
            Menupage(),
          ],
        ),
      ),
    );
  }
}
