import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/shopowner/screen/presentation/sign_in/welcomescreen.dart';
import 'package:zovo/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF71C165),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
              },
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.secondaryCream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  
                  
                  ],
                ),
                SizedBox(height: 20),
           
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 2, end: 8),
                  duration: Duration(seconds: 1),
                  builder: (context, double value, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondaryCream,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: value,
                            spreadRadius: value / 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: AppColors.primaryText),
                          SizedBox(width: 10),
                          Text(
                            'Search',
                            style: GoogleFonts.poppins(color: AppColors.primaryText, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 2, end: 8),
                  duration: Duration(seconds: 1),
                  builder: (context, double value, child) {
                    return Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xFF71C165),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: value,
                            spreadRadius: value / 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/banner.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),                
                    );
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'View All',
                      style: GoogleFonts.poppins(color: AppColors.secondaryCream, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryTile(icon: Icons.restaurant, label: 'Food'),
                    CategoryTile(icon: Icons.coffee, label: 'Coffee'),
                    CategoryTile(icon: Icons.local_pizza, label: 'Fruits'),
                    CategoryTile(icon: Icons.local_pizza, label: 'Fruits'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today offers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'View All',
                      style: TextStyle(
                        color: AppColors.secondaryCream,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('offers_today').snapshots(),                  
                  builder: (context, snapshot) {                    
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        height: 200,
                      );
                    }

                    snapshot.data!.docs.forEach((doc) async {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      DateTime createdAt = (data['created_at'] as Timestamp).toDate();
                      if (DateTime.now().difference(createdAt).inHours > 24) {
                        await FirebaseFirestore.instance
                            .collection('offers_today')
                            .doc(doc.id)
                            .update({'Available': false});
                      }
                    });

                    var availableItems = snapshot.data!.docs.where((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      DateTime createdAt = (data['created_at'] as Timestamp).toDate();
                      return data['Available'] == true && 
                             DateTime.now().difference(createdAt).inHours <= 24;
                    }).toList();

                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemCount: availableItems.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = availableItems[index].data() as Map<String, dynamic>;
                        final realprice = double.parse(data['item_price'].toString());
                        final discount = double.parse(data['discount_price'].toString());
                        final discountPercentage = ((realprice - discount) / realprice * 100).toStringAsFixed(0);
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('shops').doc(data['email']).get(),
                          builder: (context, shopSnapshot) {
                            if (shopSnapshot.connectionState == ConnectionState.waiting) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              );
                            }
                            String shopName = '';
                            if (shopSnapshot.hasData && shopSnapshot.data!.exists) {
                              shopName = shopSnapshot.data!.get('shopName') ?? '';
                            }
                            return ProductTile(
                              email: data['email'],
                              imageUrl: data['item_image'],
                              productName: data['item_name'],
                              price: data['discount_price'],
                              discount: discountPercentage,
                              shopName: shopName,
                            );
                          },
                        );
                      },
                    );
                  },
                ),              ],
            ),
          ),
        ),
      ),
    );
  }
}
class CategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryTile({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.secondaryCream,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(16),
          child: Icon(icon, size: 28),
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

class ProductTile extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final double price;
  final String discount;
  final String email;
  final String shopName;

  const ProductTile({
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.discount,
    required this.email,
    required this.shopName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${price.toString()}  ${discount}% OFF',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    shopName,
                    style: TextStyle(
                      color: AppColors.primaryText,
                    ),
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