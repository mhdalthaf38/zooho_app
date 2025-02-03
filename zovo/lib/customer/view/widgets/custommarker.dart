import 'package:flutter/material.dart';

class CustomMarkerWidget extends StatelessWidget {
  final String shopName;
  final String imageUrl;

  const CustomMarkerWidget({Key? key, required this.shopName, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 4, spreadRadius: 1),
            ],
          ),
          child: ClipOval(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.network(
                imageUrl,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.store, size: 40, color: Colors.grey);
                },
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            shopName,
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
