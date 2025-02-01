import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
              if(!snapshot.hasData)
              return Center(child: Text('Menu is Unavailable '),);
              if (snapshot.hasError) {
                return Center(child: Text('Check your network '),);
              }
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: menucard(
                        imageUrl: snapshot.data!.docs[index]['imageUrl'],
                        title: snapshot.data!.docs[index]['name'],
                        rate: snapshot.data!.docs[index]['price'],
                        cuisine: snapshot.data!.docs[index]['description'],
                      ),
                    );
                  });
            }));
  }
}
