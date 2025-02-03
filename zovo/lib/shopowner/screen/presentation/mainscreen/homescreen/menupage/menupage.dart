import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/customer/view/widgets/shimmerverticalloadingwidget.dart';
import 'package:zovo/shopowner/screen/widgets/CustomHomeBar.dart';
import 'package:zovo/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Menupage extends StatelessWidget {
  const Menupage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    return Scaffold(
      backgroundColor: AppColors.secondaryCream,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('menu_items')
            .doc(user?.email)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return verticalshimmer();
          }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No offers added',style:  GoogleFonts.poppins(
                      color: AppColors.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),));
          }
          final items = snapshot.data?.docs ?? [];
          
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              
              final item = items[index].data() as Map<String, dynamic>;
              return CustomOFFERCard(
                subcollectionName: 'offers_today',
                  itemId: items[index].id,
                id: items[index].id,
                collectionName: 'menu_items',
                email: email!,
                imageUrl: item['imageUrl'] ,
                title: item['name'] ?? 'American crispy chicken burger',
                filename: item['imagefilename'],
              
         
              
                available: item['Available'] ? 'Available' : 'Unavailable',                rate: item['price'].toString());
            },
          );
        },
      ),
    );
  }
}