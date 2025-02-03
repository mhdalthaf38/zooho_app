import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class verticalshimmer extends StatelessWidget {
  const verticalshimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 160,
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(10),
         
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
                width: 150,
                
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
        ),
      ),
    );
  }
}