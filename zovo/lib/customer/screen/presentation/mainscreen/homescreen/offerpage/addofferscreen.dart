import 'package:flutter/material.dart';

class AddOfferscreen extends StatelessWidget {
  const AddOfferscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(decoration: InputDecoration(labelText:'title' ),),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(decoration: InputDecoration(labelText:'time' ),),
      ),Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(decoration: InputDecoration(labelText:'time' ),),
      ),Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(decoration: InputDecoration(labelText:'distance' ),),
      ),Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(decoration: InputDecoration(labelText:'rating' ),),
      ),Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(decoration: InputDecoration(labelText:'offer' ),),
      ),
      ElevatedButton(onPressed: (){}, child: Text('submit'))
      ],),
      
    );
  }
}