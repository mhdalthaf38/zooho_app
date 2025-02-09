import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:zovo/customer/view/alloffers/bloc/userhome_bloc.dart';
import 'package:zovo/customer/view/alloffers/mapforuser.dart';

import 'package:zovo/customer/view/homescreen/bloc/userlocation_bloc.dart';
import 'package:zovo/customer/view/widgets/addresslocation.dart';
import 'package:zovo/customer/view/widgets/alldetailswidget.dart';
import 'package:zovo/customer/view/widgets/horizontalshimmer.dart';
import 'package:zovo/customer/view/widgets/offercard.dart';
import 'package:zovo/customer/view/widgets/shimmerverticalloadingwidget.dart';
import 'package:zovo/customer/view/widgets/todayoffercard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zovo/customer/view/widgets/verticalCard.dart';
import 'package:zovo/shopowner/screen/presentation/sign_in/welcomescreen.dart';
import 'package:zovo/theme.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  String searchText = "";
LatLng? userposition;

@override
void initState() {
  super.initState();

  BlocProvider.of<UserlocationBloc>(context).stream.listen((state) {
    if (state is UserlocationLoaded) {
      setState(() {
        userposition = state.userposition;
      });
    }
  });
}



  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: AppColors.secondaryCream,
        body: CustomScrollView(
          slivers: [
            // 🔹 SliverAppBar with Search Bar
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              expandedHeight: screenHeight * 0.14,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.secondaryCream,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, offset: Offset(0, 2))
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search Offers...",
                        prefixIcon:
                            Icon(Icons.search, color: AppColors.primaryText),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: EdgeInsets.only(top: 40, left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Home location & "Renew One" button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              userMapscreen()));
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.location_pin,
                                        color: Colors.white),
                                    SizedBox(width: 8),
                                    Column(
                                      children: [
                                        Text(
                                          "Location",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.arrow_drop_down,
                                        color: Colors.white),
                                  ],
                                ),
                              ),
                              BlocBuilder<UserlocationBloc, UserlocationState>(
                                builder: (context, state) {
                                 
                                  if (state is UserlocationLoaded) {
                                  
                                    return Text(
                                      "${state.locationName} , ${state.city} , ${state.state}",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                  return Text(
                                      "unknown location",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                },
                              ),
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                FirebaseAuth.instance.signOut().then((value) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => WelcomeScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                });
                              },
                              child: Icon(
                                Icons.person,
                                color: AppColors.secondaryCream,
                              ))
                        ],
                      ),

                      // 🔹 Search Bar
                    ],
                  ),
                ),
              ),
            ),

            // Body Content (Today Offers)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: screenHeight * 0.15,
                        autoPlay: true,
                        enlargeCenterPage: false,
                      ),
                      items: [
                        "assets/images/banner.png",
                        "assets/images/banner.png",
                      ].map((imagePath) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Title Row
                  BlocBuilder<UserhomeBloc, UserhomeState>(
                    builder: (context, state) {
                      if (state is today_offersLength) {
                        return state.itemlength == 0
                            ? SizedBox()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 5, bottom: 10),
                                    child: Text(
                                      'GRAB YOUR TODAY OFFERS',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                    thickness: 1,
                                    endIndent: 12,
                                  ))
                                ],
                              );
                      }
                      return SizedBox();
                    },
                  ),

                  // Offers Grid
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('offers_today')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text(
                          'No Today offers Added',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ));
                      }
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Horizontalshimmer();
                      }

                      var availableItems = snapshot.data!.docs.where((doc) {
                        Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;
                        DateTime createdAt =
                            (data['created_at'] as Timestamp).toDate();
                        bool isTodayOffer = data['Offertype'] == 'today_offers';
                        bool within24Hours =
                            DateTime.now().difference(createdAt).inHours <= 24;
                        bool Available = data['Available'] == true;
                        bool matchesSearch = data['item_name']
                                .toLowerCase()
                                .contains(searchText) ||
                            data['description']
                                .toLowerCase()
                                .contains(searchText)||data['shopname'].toLowerCase().contains(searchText);
                        return isTodayOffer &&
                            within24Hours &&
                            matchesSearch &&
                            Available;
                      }).toList();
                      BlocProvider.of<UserhomeBloc>(context).add(
                          todayofferslistlength(
                              itemlength: availableItems.length));
                              
                      return availableItems.length == 0
                          ? SizedBox()
                          : SizedBox(
                              height: screenHeight *
                                  0.31, // Adjust the height based on content
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                scrollDirection: Axis
                                    .horizontal, // 🔹 Enables horizontal scrolling
                                itemCount: availableItems.length ,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data =
                                      availableItems[index % 2  ].data()
                                          as Map<String, dynamic>;

                                  return FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('shops')
                                        .doc(data['email'])
                                        .get(),
                                    builder: (context, shopSnapshot) {
                                      if (shopSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Horizontalshimmer();
                                      }

                                      String shopemail =
                                          shopSnapshot.data?.get('email') ?? '';
                                      String shoplocation =
                                          shopSnapshot.data?.get('location') ??
                                              '';
                                      String shopName =
                                          shopSnapshot.data?.get('shopName') ??
                                              '';
                                      String shopImages = shopSnapshot.data
                                              ?.get('shopImages') ??
                                          [];
                                      final shoplatitude =
                                          shopSnapshot.data?.get('latitude');
                                      final shoplongitude =
                                          shopSnapshot.data?.get('longitude');

                                      final discountPercentage =
                                          ((data['item_price'] -
                                                      data['discount_price']) /
                                                  data['item_price'] *
                                                  100)
                                              .toStringAsFixed(0);
                                      final time =
                                          data['created_at'] ?? Timestamp.now();
                                      final datenow = DateTime.now();
                                      final hours = datenow
                                          .difference(time.toDate())
                                          .inHours;

                                      if (hours < 24) {
                                        var remainingtime = 24 - hours;

                                        return GestureDetector(
                                          onTap: () {
                                            showProductDetails(
                                              context,
                                              userposition!,
                                              shoplongitude,
                                              shoplatitude,
                                              shopemail,
                                              data['item_image'],
                                              data['item_name'],
                                              data['description'],
                                              shopName,
                                              shoplocation,
                                              '₹${data['discount_price']}',
                                              shopImages.isNotEmpty
                                                  ? shopImages
                                                  : '',
                                            );
                                          },
                                          child: Container(
                                            width:
                                                180, // 🔹 Adjust width of each card
                                            margin: EdgeInsets.only(
                                                right:
                                                    10), // 🔹 Spacing between items
                                            child: todayoffercard(
                                              VegOrNonVeg:
                                                  data['VegOrNonVeg'] ==
                                                          'Non-Veg'
                                                      ? false
                                                      : true,
                                              discountoffer: discountPercentage,
                                              imageUrl: data['item_image'],
                                              cuisines: data['item_name'],
                                              priceInfo:
                                                  '₹${data['discount_price']}',
                                              rating: '4.5',
                                              deliveryTime: '30 min',
                                              restaurantName: shopName,
                                              remainingtime:
                                                  remainingtime.toString(),
                                            ),
                                          ),
                                        );
                                      }
                                      return SizedBox.shrink();
                                    },
                                  );
                                },
                              ),
                            );
                    },
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 5, bottom: 5),
                        child: Text(
                          'RESTURENT',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1,
                        endIndent: 12,
                      ))
                    ],
                  ),
  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('shops')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text(
                          'No Resturents',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ));
                      }
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Horizontalshimmer();
                      }

                      var availableItems = snapshot.data!.docs.where((doc) {
                        Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;
                       
                        bool Available = data['shopstatus'] == true;
                        bool matchesSearch = data['shopName']
                                .toLowerCase()
                                .contains(searchText)
                           ;
                        return
                            matchesSearch &&
                            Available;
                      }).toList();
                     
                      return availableItems.length == 0
                          ? SizedBox()
                          : SizedBox(
                              height: screenHeight *
                                  0.31, // Adjust the height based on content
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                scrollDirection: Axis
                                    .horizontal, // 🔹 Enables horizontal scrolling
                                itemCount: availableItems.length,
                                itemBuilder: (context, index) {
                               

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Verticalcard(image: availableItems[index]['shopImages'],shopname:availableItems[index]['shopName'] ,location: availableItems[index]['location'],discription:  availableItems[index]['shopDescription'],),
                                  );
                                },
                              ),
                            );
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 5, bottom: 5),
                        child: Text(
                          'GRAB THE OFFERS BEFORE ITS END',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1,
                        endIndent: 12,
                      ))
                    ],
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('offers_today')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text(
                          'No  offers Added',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ));
                      }
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      var availableItems = snapshot.data!.docs.where((doc) {
                        Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;

                        bool isTodayOffer = data['Offertype'] == 'offers';
                        bool isAvailable = data['Available'] == true;

                        bool matchesSearch = data['item_name']
                                .toLowerCase()
                                .contains(searchText) ||
                            data['description']
                                .toLowerCase()
                                .contains(searchText);
                        return isTodayOffer && matchesSearch && isAvailable;
                      }).toList();

                      return availableItems.length == 0
                          ? Center(
                              child: Text(
                              'Sorry no offers Available',
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryText,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              physics:
                                  BouncingScrollPhysics(), // Allows smooth scrolling
                              shrinkWrap: true,
                              itemCount: availableItems.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    availableItems[index].data()
                                        as Map<String, dynamic>;

                                return FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('shops')
                                      .doc(data['email'])
                                      .get(),
                                  builder: (context, shopSnapshot) {
                                    if (shopSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return verticalshimmer();
                                    }

                                    String shoplocation =
                                        shopSnapshot.data?.get('location') ??
                                            '';
                                    String shopName =
                                        shopSnapshot.data?.get('shopName') ??
                                            '';
                                    String shopemail =
                                        shopSnapshot.data?.get('email') ?? '';
                                    String shopImages =
                                        shopSnapshot.data?.get('shopImages') ??
                                            [];
                                    final shoplatitude =
                                        shopSnapshot.data?.get('latitude');
                                    final shoplongitude =
                                        shopSnapshot.data?.get('longitude');
                                    final endtime =
                                        (data['end_date'] as Timestamp)
                                            .toDate();
                                    final datenow = DateTime.now();
                                    final discountPercentage =
                                        ((data['item_price'] -
                                                    data['discount_price']) /
                                                data['item_price'] *
                                                100)
                                            .toStringAsFixed(0);

                                    if (datenow.isBefore(endtime)) {
                                      String remainingtime =
                                          "${endtime.day}-${endtime.month}-${endtime.year}";

                                      return GestureDetector(
                                        onTap: () {
                                          showProductDetails(
                                            context,
                                            userposition!,
                                            shoplongitude,
                                            shoplatitude,
                                            shopemail,
                                            data['item_image'],
                                            data['item_name'],
                                            data['description'],
                                            shopName,
                                            shoplocation,
                                            '₹${data['discount_price']}',
                                            shopImages.isNotEmpty
                                                ? shopImages
                                                : '',
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  10), // Adds space between items
                                          child: Offercard(
                                            description: data['description'],
                                            location: shoplocation,
                                            offerprice: discountPercentage,
                                            available: data['Available'] == true
                                                ? 'Available'
                                                : 'Not Available',
                                            remainingtime: remainingtime,
                                            imageUrl: data['item_image'],
                                            itemname: data['item_name'],
                                            price: data['discount_price']
                                                .toString(),
                                            shopName: shopName,
                                          ),
                                        ),
                                      );
                                    }
                                    return SizedBox
                                        .shrink(); // Hide expired offers
                                  },
                                );
                              },
                            );
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
