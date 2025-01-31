import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/homescreen/menupage/menupage.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/homescreen/profilepage/profile.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/homescreen/todayofferscreen/todayoffers.dart';
import 'package:zovo/theme.dart';
import 'offerpage/offerpage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool istoggled = false;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final email = FirebaseAuth.instance.currentUser?.email;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('shops')
            .doc(email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final shopData = snapshot.data!.data() as Map<String, dynamic>;
          bool isShopOpen = shopData['shopstatus'];
          if (shopData['shopstatus'] == null) {
            isShopOpen = false;
          }
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        );
                      },
                      child: Stack(
                     
                        children: [
                          Text('ZOOho',
                              style: GoogleFonts.poppins(
                                  color: AppColors.primaryOrange,
                                  fontSize: screenWidth * 0.07,
                                  fontWeight: FontWeight.w900)),
                                    Positioned(
                                      top: 23,
                                      left: 35,
                                      child: Text('Premium',
                                                                    style: GoogleFonts.poppins(
                                                                        color: const Color.fromARGB(255, 177, 143, 5),
                                                                        fontSize: screenWidth * 0.035,
                                                                        fontWeight: FontWeight.w600,
                                                                        fontStyle: FontStyle.italic)),
                                    ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.secondaryCream,
                            title: Text(
                              'Shop is Open or Closed?',
                              style: GoogleFonts.poppins(
                                  color: AppColors.primaryOrange,
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.w900),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('shops')
                                        .doc(email)
                                        .update({'shopstatus': true});
                                    Navigator.pop(context);
                                  } catch (e) {
                                    SnackBar(
                                        content: Text(
                                            'check your internet connection'));
                                  }
                                },
                                child: Text('Open',
                                    style: GoogleFonts.poppins(
                                        color: AppColors.accentGreen,
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w900)),
                              ),
                              TextButton(
                                onPressed: () async {
                                 try {
                                    await FirebaseFirestore.instance
                                      .collection('shops')
                                      .doc(email)
                                      .update({'shopstatus': false});
                                  Navigator.pop(context);
                                 } catch (e) {
                                   SnackBar(content: Text('check your internet connection'));
                                 }
                                },
                                child: Text('Closed',
                                    style: GoogleFonts.poppins(
                                        color: AppColors.accentRed,
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w900)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          isShopOpen == true
                              ? Container(
                                  height: screenHeight * 0.04,
                                  width: screenWidth * 0.5,
                                  decoration: BoxDecoration(
                                      color: AppColors.accentGreen,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Text('Shop is Open',
                                        style: GoogleFonts.poppins(
                                            color: AppColors.secondaryCream,
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.w900)),
                                  ),
                                )
                              : Container(
                                  height: screenHeight * 0.04,
                                  width: screenWidth * 0.5,
                                  decoration: BoxDecoration(
                                      color: AppColors.accentRed,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Text('Shop is closed',
                                        style: GoogleFonts.poppins(
                                            color: AppColors.secondaryCream,
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.w900)),
                                  ),
                                ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              automaticallyImplyLeading: false,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(70),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBar(
                    unselectedLabelStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, letterSpacing: 0.01),
                    dividerColor: AppColors.secondaryCream,
                    indicatorSize: TabBarIndicatorSize.tab,
                    controller: _tabController,
                    labelStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    indicator: BoxDecoration(
                      color: AppColors
                          .primaryOrange, // Light pink for the active tab
                      borderRadius: BorderRadius.circular(20),
                    ),
                    unselectedLabelColor: AppColors.primaryText,
                    labelColor: AppColors.secondaryCream,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 5),
                    tabs: [
                      FittedBox(
                          child: Tab(
                        text: "Today Offers",
                      )),
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
        });
  }
}
