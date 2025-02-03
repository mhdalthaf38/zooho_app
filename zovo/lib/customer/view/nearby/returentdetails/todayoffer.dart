import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/customer/view/nearby/returentdetails/bloc/resturent_bloc.dart';

import 'package:zovo/customer/view/widgets/offercard.dart';
import 'package:zovo/shopowner/screen/widgets/CustomHomeBar.dart';
import 'package:zovo/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class todayOffer extends StatelessWidget {
  String? email;

   todayOffer({super.key,required this.email});

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      backgroundColor: AppColors.secondaryCream,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
           .collection('today_offers')
            .doc(email)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
              
             if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Today offers Added',style:  GoogleFonts.poppins(
                      color: AppColors.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),));
          }
          
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
                final idforavailable = snapshot.data!.docs[index].id; 
              final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
           
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('menu_items')
                    .doc(email)
                    .collection('items')
                    .doc(data['item_id'])
                    .snapshots(),
                builder: (context, itemSnapshot) {
                  if (itemSnapshot.hasError) {
                    return SizedBox.shrink();
                  }
                  if (itemSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!itemSnapshot.hasData || !itemSnapshot.data!.exists) {
                    return SizedBox.shrink();
                  }

                  final itemData = itemSnapshot.data!.data() as Map<String, dynamic>;
                  final realprice = double.parse(itemData['price'].toString());
                  final discountprice = double.parse(data['price'].toString());
                  final discountPercentage = ((realprice - discountprice) / realprice * 100).toStringAsFixed(0);
                  final menuavailable = itemData['Available'];
                  final available = menuavailable ? data['Available'] : menuavailable;   
                  final time = data['created_at']?? Timestamp.now();
                  final datenow = DateTime.now();
                  final hours = datenow.difference(time.toDate()).inHours;
                  if (hours < 24) {
                  var remainingtime = 24 - hours;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Offercard(available: available ? 'Available':'Not Available', remainingtime: '${remainingtime.toString()} Hours ', imageUrl: itemData['imageUrl'], itemname: itemData['name'], price: discountprice.toString(), shopName: '', offerprice: '$discountPercentage', location: '', description: itemData['description']),
                  );
                  //  return CustomOFFERCard(
                  //   itemId: data['item_id'],
                  //   id: idforavailable ,
                  //   collectionName: 'today_offers',
                  //   subcollectionName: 'offers_today',
                  //   email: email!,
                  //   imageUrl: itemData['imageUrl'],
                  //   title: itemData['name'],
                 
                  //   offer: '$discountPercentage%OFF',
                  //   remainingtime: '${remainingtime.toString()} Hours ',
                  //   available: available ? 'Available' : 'Unavailable',
                  //   rate: discountprice.toString()
                  // );
                  }
                  return SizedBox.shrink();
                }
              );
            }
          );
        }
    ));
  }
}
