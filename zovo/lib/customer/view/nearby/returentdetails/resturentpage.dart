import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/customer/view/nearby/returentdetails/bloc/resturent_bloc.dart';
import 'package:zovo/customer/view/nearby/returentdetails/menuitems.dart';
import 'package:zovo/customer/view/nearby/returentdetails/offer.dart';
import 'package:zovo/customer/view/nearby/returentdetails/todayoffer.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/homescreen/menupage/menupage.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/homescreen/profilepage/profile.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/homescreen/todayofferscreen/todayoffers.dart';
import 'package:zovo/shopowner/screen/presentation/sign_in/welcomescreen.dart';

import 'package:zovo/theme.dart';

class Resturentpage extends StatefulWidget {
  final String email;
  const Resturentpage({
    super.key, required this.email,
  });

  @override
  State<Resturentpage> createState() => _ResturentpageState();
}

class _ResturentpageState extends State<Resturentpage>
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
  
    return BlocConsumer<ResturentBloc, ResturentState>(
      listener: (context, state) {
      if (state is shopdataloading) {
         Center(child: CircularProgressIndicator(),);
      }
      if (state is gettingerror) {
        Center(child: Text('Check your network'),);
      }
      },
      builder: (context, state) {
       if(state is shopdataloaded)
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
                  Text( state.shopdata['shopName'],
                      style: GoogleFonts.poppins(
                          color: AppColors.primaryOrange,
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.w900)),
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
            children: [
              todayOffer(email:state.shopdata['email'] ,),
               Offers(email:state.shopdata['email'] ,),
               Menuitems(
                email: state.shopdata['email'],
              ),
            ],
          ),
        );
        return SizedBox.shrink();
      },
    );
  }
}
