
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zovo/customer/view/alloffers/todayOffers/alltodayoffers.dart';
import 'package:zovo/customer/view/widgets/offercard.dart';
import 'package:zovo/customer/view/widgets/todayoffercard.dart';

import 'package:zovo/theme.dart';



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.secondaryCream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
         
            expandedHeight:
                screenHeight * 0.36, // Expands up to 36% of screen height
            // Disappears when scrolling up
            pinned: true, // Stays pinned when collapsed
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40), // Space for status bar
                    Padding(
                      padding:  EdgeInsets.only(left: screenwidth * 0.04 ,right: screenwidth * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.home,
                                      color: AppColors.secondaryCream),
                                  SizedBox(width: 8),
                                  Text(
                                    'Ayathil',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.secondaryCream,
                                      fontSize: screenwidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Near Meditrina Hospital',
                                style: GoogleFonts.poppins(
                                  color: AppColors.secondaryCream,
                                  fontSize: screenwidth * 0.03,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(screenwidth * 0.04),
                            child: Icon(Icons.favorite_border,
                                color: AppColors.secondaryCream),
                          ),
                        ],
                      ),
                    ),
                    // Search Box
                    Padding(
                      padding:  EdgeInsets.only(left: screenwidth * 0.04 ,right: screenwidth * 0.04),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondaryCream,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: AppColors.primaryText),
                            SizedBox(width: 10),
                            Text(
                              'Search',
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryText,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Animated Banner
                    Center(
                      child: Container(
                        height: screenHeight * 0.19,
                        decoration: BoxDecoration(
                          color: Color(0xFF71C165),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(1, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/banner.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
          ),

          // Body Content (Today Offers)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today Offers',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Alltodayoffers()));
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(color: AppColors.primaryText),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Offers Grid
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('offers_today')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      var availableItems = snapshot.data!.docs.where((doc) {
                        Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;
                        DateTime createdAt =
                            (data['created_at'] as Timestamp).toDate();
                        return data['Available'] == true &&
                            DateTime.now().difference(createdAt).inHours <= 24 && data['Offertype'] == 'today_offers';
                      }).toList();

                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 0,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: availableItems.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = availableItems[index]
                              .data() as Map<String, dynamic>;
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('shops')
                                .doc(data['email'])
                                .get(),
                            builder: (context, shopSnapshot) {
                              if (shopSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              String shopName =
                                  shopSnapshot.data?.get('shopName') ?? '';
                                      final discountPercentage = ((data['item_price'] - data['discount_price']) / data['item_price'] * 100).toStringAsFixed(0);
                                      final time = data['created_at']?? Timestamp.now();
                  final datenow = DateTime.now();
                  final hours = datenow.difference(time.toDate()).inHours;
                  if (hours < 24) {
                  var remainingtime = 24 - hours;
                              return todayoffercard(
                                discountoffer:discountPercentage,
                                imageUrl: data['item_image'],
                                restaurantName: data['item_name'],
                                priceInfo: '₹${data['item_price']}',
                                rating: '4.5',
                                deliveryTime: '30 min',
                                cuisines: shopName,
                                remainingtime: remainingtime.toString(),
                              );
                            }
                              return SizedBox.shrink();
                            },
                          );
                        },
                      );
                    },
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grab the Offers Before its end',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                     
                    ],
                  ),
                 StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('offers_today')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      var availableItems = snapshot.data!.docs.where((doc) {
                        Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;
                        DateTime createdAt =
                            (data['created_at'] as Timestamp).toDate();
                        return data['Available'] == true &&
                            DateTime.now().difference(createdAt).inHours <= 24 && data['Offertype'] == 'offers';
                      }).toList();

                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 0,
                          childAspectRatio: 1.9,
                        ),
                        itemCount: availableItems.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = availableItems[index]
                              .data() as Map<String, dynamic>;
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('shops')
                                .doc(data['email'])
                                .get(),
                            builder: (context, shopSnapshot) {
                              if (shopSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              String shoplocation = shopSnapshot.data?.get('location') ?? '';
                              String shopName =
                                  shopSnapshot.data?.get('shopName') ?? '';
                                   final endtime =(data['end_date'] as Timestamp).toDate();
                  final datenow = DateTime.now();
                  final discountPercentage = ((data['item_price'] - data['discount_price']) / data['item_price'] * 100).toStringAsFixed(0);
                  if (datenow.isBefore(endtime)) {
                      String remainingtime ="${endtime.day}-${endtime.month}-${endtime.year}";

                                return Offercard(description: data['description'],
                                  location: shoplocation,
                                  offerprice:discountPercentage,
                                  available: data['Available'] == true ? 'Available':'Not AVailable', remainingtime: remainingtime, imageUrl: data['item_image'], itemname: data['item_name'], price: data['discount_price'].toString(), shopName: shopName);
                  }
                              return SizedBox.shrink();
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}