import 'package:flutter/material.dart';
import 'package:zovo/customer/screen/widgets/CustomHomeBar.dart';
import 'package:zovo/theme.dart';



class Menupage extends StatelessWidget {
  const Menupage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryCream,
    
      body: ListView.builder(itemCount: 4,
        itemBuilder: (context, index) {
        return CustomOFFERCard(imageUrl: 'assets/images/burgerkingimg.jpg', title: 'American crispy chicken burger', distance: '6.2', offer: '25%OFF', cuisine: '',available:'Available', rate: '179',);
      }),
    );
  }
}