import 'package:flutter/material.dart';

class VegNonVegIcon extends StatelessWidget {
  final bool isVeg; // true = Veg, false = Non-Veg

  const VegNonVegIcon({Key? key, required this.isVeg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
          border: Border.all(color: isVeg ? Colors.green : Colors.red), 
        borderRadius: BorderRadius.circular(2),
        shape: BoxShape.rectangle, // Square shape
      // Black border
        color:Colors.white, // Green for Veg, Red for Non-Veg
      ),
      child: Center(
        child: Icon(
          Icons.circle,
          size: 10,
         color: isVeg ? Colors.green : Colors.red, // Small white dot inside
        ),
      ),
    );
  }
}
