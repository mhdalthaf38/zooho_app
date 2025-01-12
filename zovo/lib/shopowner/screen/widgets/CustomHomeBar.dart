import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomOFFERCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String rate;
  final String available;
  final String cuisine;
  final String distance;
  final String? offer;
  final String email;
  final String collectionName;
  final String id;
final String itemId;
final String subcollectionName;
  const CustomOFFERCard({
    super.key,
    required this.id,
    required this.collectionName,
    required this.imageUrl,
    required this.title,
    required this.available,
    required this.cuisine,
    required this.distance,
    required this.rate,

    required this.email,
    required this.itemId,
    required this.subcollectionName,
    this.offer,
  });

  Future<void> checkAndUpdateAvailability() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(email)
          .collection('items')
          .doc(id)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          if (collectionName == 'today_offers' && data['created_at'] != null) {
            final createdAt = (data['created_at'] as Timestamp).toDate();
            final now = DateTime.now();
            final difference = now.difference(createdAt);

            if (difference.inHours >= 24) {
              await updateAvailability(false);
            }
          } else if (collectionName == 'offers' && data['start_date'] != null && data['end_date'] != null) {
            final startDate = (data['start_date'] as Timestamp).toDate();
            final endDate = (data['end_date'] as Timestamp).toDate();
            final now = DateTime.now();

            if (now.isAfter(endDate) || now.isBefore(startDate)) {
              await updateAvailability(false);
            }
          }
        }
      }
    } catch (e) {
      print('Error checking availability: $e');
    }
   }  Future<void> updateAvailability(bool isAvailable) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(email)
          .collection('items')
          .doc(id)
          .update({'Available': isAvailable});
           await FirebaseFirestore.instance
          .collection(subcollectionName)
          .doc('$email$itemId')
          .update({'Available': isAvailable});
    } catch (e) {
      print('Error updating availability: $e');
    }
  }

  Future<void> deleteItem() async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(email)
          .collection('items')
          .doc(id)
          .delete();
           await FirebaseFirestore.instance
          .collection(subcollectionName)
          .doc('$email$itemId').delete();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

Future<void> updatetoAvailable(bool isAvailable, BuildContext context) async {
    try {
      if (collectionName == 'today_offers' && isAvailable) {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(email)
            .collection('items')
            .doc(id)
            .update({
          'Available': isAvailable,
          'created_at': Timestamp.now(),
        });
         await FirebaseFirestore.instance
          .collection(subcollectionName)
          .doc('$email$itemId').update({
          'Available': isAvailable,
          'created_at': Timestamp.now(),
        });
      } else if (collectionName == 'offers' && isAvailable) {
        DateTimeRange? dateRange = await showDateRangePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        );
        
        if (dateRange != null) {
          await FirebaseFirestore.instance
              .collection(collectionName)
              .doc(email)
              .collection('items')
              .doc(id)
              .update({
            'Available': isAvailable,
            'start_date': Timestamp.fromDate(dateRange.start),
            'end_date': Timestamp.fromDate(dateRange.end),
          });
           await FirebaseFirestore.instance
          .collection(subcollectionName)
          .doc('$email$itemId').update({
            'Available': isAvailable,
            'start_date': Timestamp.fromDate(dateRange.start),
            'end_date': Timestamp.fromDate(dateRange.end),
          });
        }
      } else {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(email)
            .collection('items')
            .doc(id)
            .update({'Available': isAvailable});
            
      }
    } catch (e) {
      print('Error updating availability: $e');
    }
  }

  Future<void> editPrice(BuildContext context) async {
    TextEditingController priceController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Price', style: GoogleFonts.poppins()),
        content: TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: "Enter new price"),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Update'),
            onPressed: () async {
              if (priceController.text.isNotEmpty) {
                try {
                  await FirebaseFirestore.instance
                      .collection(collectionName)
                      .doc(email)
                      .collection('items')
                      .doc(id)
                      .update({'price': priceController.text});
                       await FirebaseFirestore.instance
          .collection(subcollectionName)
          .doc('$email$itemId').update({'discount_price': priceController.text});
                  Navigator.pop(context);
                } catch (e) {
                  print('Error updating price: $e');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    checkAndUpdateAvailability();
    
    // Screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamic sizing based on screen width
    final imageSize = screenWidth * 0.34;
    final fontSize = screenWidth * 0.04;

    return Container(
      width: screenWidth * 0.9,
      color: AppColors.secondaryCream,
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              image: DecorationImage(
                image: NetworkImage(imageUrl),                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ITEMS',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: imageSize * 0.12, fontWeight: FontWeight.w900, letterSpacing: 0.01),
                        ),
                        Text(
                          'AT ₹$rate',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: imageSize * 0.14, fontWeight: FontWeight.w900, letterSpacing: 0.01),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryText,
                          fontSize: fontSize * 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    PopupMenuButton<String>(
                      color: AppColors.secondaryCream,
                      icon: Icon(
                        Icons.more_vert,
                        color: AppColors.primaryText,
                        size: fontSize * 1.5,
                      ),
                      onSelected: (value) {
                        if (value == 'Available') {
                          updatetoAvailable(true,context);
                        } else if (value == 'Not Available') {
                          updateAvailability(false);
                        } else if (value == 'Delete') {
                          deleteItem();
                        } else if (value == 'Edit') {
                          editPrice(context);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'Available',
                          child: Text('Available',style: GoogleFonts.poppins(color: AppColors.accentGreen, fontSize: fontSize * 1, fontWeight: FontWeight.bold),),
                        ),
                        PopupMenuItem<String>(
                          value: 'Not Available',
                          child: Text('Not Available',style: GoogleFonts.poppins(color: AppColors.accentRed, fontSize: fontSize * 1, fontWeight: FontWeight.bold),),
                        ),
                        PopupMenuItem<String>(
                          value: 'Edit',
                          child: Text('Edit Price',style: GoogleFonts.poppins(color: AppColors.primaryOrange, fontSize: fontSize * 1, fontWeight: FontWeight.bold),),
                        ),
                        PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text('Delete',style: GoogleFonts.poppins(color: Colors.red, fontSize: fontSize * 1, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ],
                ),
               
                Text(
                  available,
                  style: GoogleFonts.poppins(
                    color: available == 'Available' ? AppColors.accentGreen : AppColors.accentRed,fontWeight: FontWeight.bold,
                    fontSize: fontSize * 1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  offer != null ? '$offer / ₹$rate' : '₹$rate',
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryOrange,
                    fontSize: fontSize * 0.8,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                 Text('Ends in $cuisine Hr',style: GoogleFonts.poppins(color: AppColors.secondaryText, fontSize: fontSize * 0.8, fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        ],
      ),
    );
  }}