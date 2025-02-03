import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/customer/view/widgets/menucard.dart';
import 'package:zovo/theme.dart';

class Menuitems extends StatefulWidget {
  final String email;
  const Menuitems({super.key, required this.email});

  @override
  State<Menuitems> createState() => _MenuitemsState();
}

class _MenuitemsState extends State<Menuitems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryCream,
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('menu_items')
                .doc(widget.email)
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
            return Center(child: Text('No menu items added',style:  GoogleFonts.poppins(
                      color: AppColors.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),));
          }
          
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    final data =snapshot.data!.docs[index];
                    if (data['Available']== true) 
                       return ListTile(
                      title:Menucard( imageUrl:data['imageUrl'] , itemname: data['name'], price: data['price'].toString(),  description: data['description'])
                    );
                    return SizedBox.shrink();
                   
                  });
            }));
  }
}
