import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/customer/screen/widgets/CustomHomeBar.dart';
import 'package:zovo/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodayoffersScreen extends StatelessWidget {
  const TodayoffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: AppColors.secondaryCream,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
           .collection('today_offers')
            .doc(user?.email)
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
              final email = user?.email;
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('menu_items')
                    .doc(user?.email)
                    .collection('items')
                    .doc(data['item_id'])
                    .snapshots(),
                builder: (context, itemSnapshot) {
                  if (itemSnapshot.hasError) {
                    return Center(child: Text('Error loading item details'));
                  }
                  if (itemSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!itemSnapshot.hasData || !itemSnapshot.data!.exists) {
                    return Center(child: Text('Item not found'));
                  }

                  final itemData = itemSnapshot.data!.data() as Map<String, dynamic>;
                  final realprice = itemData['price'];
                  final discountprice = data['discount_price'];
                  final discountPercentage = ((realprice - discountprice) / realprice * 100).toStringAsFixed(0);
                  final menuavailable = itemData['Available'];
                  final available = menuavailable ? data['Available'] : menuavailable;   

                  return CustomOFFERCard(
                    id: idforavailable ,
                    collectionName: 'today_offers',
                    email: email!,
                    imageUrl: itemData['imageUrl'],
                    title: itemData['name'],
                    distance: '6.2',
                    offer: '$discountPercentage%OFF',
                    cuisine: '',
                    available: available ? 'Available' : 'Unavailable',
                    rate: discountprice?.toString() ?? '0.0'
                  );
                }
              );
            }
          );
        }
    ));
  }}