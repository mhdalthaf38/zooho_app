import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:zovo/customer/view/widgets/alldetailswidget.dart';
import 'package:zovo/customer/view/widgets/todayoffercard.dart';
import 'package:zovo/theme.dart';

class Alltodayoffers extends StatelessWidget {
  final userlocation;
  const Alltodayoffers({super.key,required this.userlocation});

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;

    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.secondaryCream),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Today Offers',style:GoogleFonts.poppins(color: AppColors.secondaryCream, fontSize: screenwidth * 0.06, fontWeight: FontWeight.bold) ,),
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      backgroundColor: AppColors.secondaryCream,
      body:   Padding(
        padding:  EdgeInsets.all(screenwidth * 0.04),
        child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('offers_today').snapshots(),                  
                    builder: (context, snapshot) {    
                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Today offers Added',style:  GoogleFonts.poppins(
                      color: AppColors.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),));
          }                
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
                               DateTime.now().difference(createdAt).inHours <= 24 && data['Offertype'] == 'today_offers';
                      }).toList();
        
                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 0,
                          childAspectRatio: 0.65,
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
                              String shoplocation = shopSnapshot.data?.get('location') ?? '';
                             final shoplatitude =
                                      shopSnapshot.data?.get('latitude');
                                       final shoplongitude =
                                      shopSnapshot.data?.get('longitude');
                                   String shopemail =
                                  shopSnapshot.data?.get('email') ?? '';
                                   List<dynamic> Shopimages =
                                  shopSnapshot.data?.get('shopImages') ?? '';
                              String shopName = '';
                              if (shopSnapshot.hasData && shopSnapshot.data!.exists) {
                                shopName = shopSnapshot.data!.get('shopName') ?? '';
                              }
                           final discountPercentage = ((data['item_price'] - data['discount_price']) / data['item_price'] * 100).toStringAsFixed(0);
                           final time = data['created_at']?? Timestamp.now();
                  final datenow = DateTime.now();
                  final hours = datenow.difference(time.toDate()).inHours;
                  if (hours < 24) {
                  var remainingtime = 24 - hours;
                              return GestureDetector(
                                onTap: (){
                                    showProductDetails(context ,userlocation ,shoplongitude, shoplatitude, shopemail,  data['item_image'],  data['item_name'],  data['description'],  shopName,  shoplocation, '₹${data['item_price']}', Shopimages[0]);
                                },
                                child: todayoffercard(
                                  imageUrl: data['item_image'],
                                  restaurantName: data['item_name'],
                                  priceInfo: '₹${data['item_price']}',
                                  rating: '4.5',
                                  deliveryTime: '30 min',
                                  cuisines: shopName,
                                  remainingtime:remainingtime.toString() , discountoffer: discountPercentage,
                                ),
                              );

                            }
                            return SizedBox.shrink();
                            },

                          );
                        },
                      );
                    },
                  ),
      ),    
    );
  }
}

