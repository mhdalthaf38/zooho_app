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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
    late TabController _tabController;
    @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
                'ZOOho',
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
        bottom:  PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBar(
            unselectedLabelStyle: GoogleFonts.poppins( fontWeight: FontWeight.bold, letterSpacing: 0.01),
            dividerColor: AppColors.secondaryCream,
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabController,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 16),
            indicator: BoxDecoration(
              color: AppColors.primaryOrange, // Light pink for the active tab
              borderRadius: BorderRadius.circular(20),
            ),
            unselectedLabelColor: AppColors.primaryText,
            labelColor: AppColors.secondaryCream,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 5),
            tabs: [
              FittedBox(child: Tab(text: "Today Offers",)),
              Tab(text: "Offers"),
              Tab(text: "Menu"),
            ],
          ),
        ),
      ),
      ),
      body: TabBarView(
       controller: _tabController,
      children: const [
        TodayoffersScreen(),
            Offerpage(),
            Menupage(),
      ],
      ),
    );
  }
}
