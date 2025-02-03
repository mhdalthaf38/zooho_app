import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/collectingshopimages.dart';
import 'package:zovo/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomOFFERCard extends StatelessWidget {
  final String? filename;
  final String imageUrl;
  final String title;
  final String rate;
  final String available;
  final String? remainingtime;

  final String? offer;
  final String email;
  final String collectionName;
  final String id;
  final String itemId;
  final String subcollectionName;
  const CustomOFFERCard({
    super.key,
    required this.id,
    this.filename,
    required this.collectionName,
    required this.imageUrl,
    required this.title,
    required this.available,
     this.remainingtime,
  
    required this.rate,
    required this.email,
    required this.itemId,
    required this.subcollectionName,
    this.offer,
  });

  Future<void> checkAndUpdateAvailability( ) async {
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
          } else if (collectionName == 'offers' &&
              data['start_date'] != null &&
              data['end_date'] != null) {
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
  }



Future<void> deleteImageFromSupabase(String fileUrl) async {
  final supabase = Supabase.instance.client;
  final bucketName = 'shop menu items images'; // Your bucket name

  // Extract file path from URL
  String filePath = extractFilePath(fileUrl);

  if (filePath.isNotEmpty) {
    final response = await supabase.storage.from(bucketName).remove([filePath]);

    print(response);
  } else {
    print('Invalid file URL');
  }
}

// Function to extract file path from the URL
String extractFilePath(String url) {
  try {
    Uri uri = Uri.parse(url);
    List<String> parts = uri.path.split('/public/');
    return parts.length > 1 ? parts[1].replaceAll('//', '/') : '';
  } catch (e) {
    print('Error extracting file path: $e');
    return '';
  }
}

// Usage:
void main() {
  String fileUrl = "https://uyoyxxlsihxfcdlfddae.supabase.co/storage/v1/object/public/shop%20menu%20items%20images//1738584277559";
  deleteImageFromSupabase(fileUrl);
}


  Future<void> deleteItem(BuildContext context) async {


     try {
      if (collectionName == 'today_offers' ) {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(email)
            .collection('items')
            .doc(id)
           .delete();
        await FirebaseFirestore.instance
            .collection(subcollectionName)
            .doc('$email$itemId')
            .delete();
      } else if (collectionName == 'offers' ) {
      

      
          await FirebaseFirestore.instance
              .collection(collectionName)
              .doc(email)
              .collection('items')
              .doc('$id')
             .delete();
          await FirebaseFirestore.instance
              .collection(subcollectionName)
              .doc('${email}offers${itemId}')
              .delete();
        
      } else {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(email)
            .collection('items')
            .doc(id)
            .delete();
              await FirebaseFirestore.instance
            .collection('offers')
            .doc(email)
            .collection('items')
            .doc(id)
            .delete();
             await FirebaseFirestore.instance
            .collection('today_offers')
            .doc(email)
            .collection('items')
            .doc(id)
            .delete();
              await FirebaseFirestore.instance
              .collection(subcollectionName)
              .doc('${email}offers${itemId}')
              .delete();
                await FirebaseFirestore.instance
            .collection(subcollectionName)
            .doc('$email$itemId')
            .delete();
            deleteImageFromSupabase(imageUrl);
            await supabase.storage.from('shop menu items images').remove(['shop menu items images//$filename']);
      }
    } catch (e) {
      print('Error deleting item: $e');
    }
   
  }

 Future<void> updateAvailability(bool isAvailable) async {
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
  Future<void> updatetoAvailable(bool isAvailable, BuildContext context) async {
    try {
      if (collectionName == 'today_offers') {
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
            .doc('$email$itemId')
            .update({
          'Available': isAvailable,
          'created_at': Timestamp.now(),
        });
        print('anythinsdadsadad');
      } else if (collectionName == 'offers') {
      

        if (isAvailable ==  true) {
            DateTimeRange? dateRange = await showDateRangePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        );
          await FirebaseFirestore.instance
              .collection(collectionName)
              .doc(email)
              .collection('items')
              .doc('$id')
              .update({
            'Available': isAvailable,
            'start_date': Timestamp.fromDate(dateRange!.start),
            'end_date': Timestamp.fromDate(dateRange.end),
          });
          await FirebaseFirestore.instance
              .collection(subcollectionName)
              .doc('${email}offers${itemId}')
              .update({
            'Available': isAvailable,
            'start_date': Timestamp.fromDate(dateRange.start),
            'end_date': Timestamp.fromDate(dateRange.end),
          });
        }else{
            await FirebaseFirestore.instance
              .collection(collectionName)
              .doc(email)
              .collection('items')
              .doc('$id')
              .update({
            'Available': isAvailable,
           
          });
          await FirebaseFirestore.instance
              .collection(subcollectionName)
              .doc('${email}offers${itemId}')
              .update({
            'Available': isAvailable,
          
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
      if (collectionName == 'today_offers' ) {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(email)
            .collection('items')
            .doc(id)
             .update({'price': priceController.text});
        await FirebaseFirestore.instance
            .collection(subcollectionName)
            .doc('$email$itemId')
         .update({'discount_price': priceController.text});
      } else if (collectionName == 'offers') {
      
      
          await FirebaseFirestore.instance
              .collection(collectionName)
              .doc(email)
              .collection('items')
              .doc('$id')
             .update({'price': priceController.text});
          await FirebaseFirestore.instance
              .collection(subcollectionName)
              .doc('${email}offers${itemId}')
              .update({'discount_price': priceController.text});
        
      } else {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(email)
            .collection('items')
            .doc(id)
           .update({'price': priceController.text});
      }
      Navigator.of(context).pop();
    } catch (e) {
      print('Error updating availability: $e');
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
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
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
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: imageSize * 0.12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.01),
                        ),
                        Text(
                          'AT ₹$rate',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: imageSize * 0.14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.01),
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
                          updatetoAvailable(true, context);
                        } else if (value == 'Not Available') {
                          updatetoAvailable(false,context);
                        } else if (value == 'Delete') {
                          deleteItem(context);
                        } else if (value == 'Edit') {
                          editPrice(context);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'Available',
                          child: Text(
                            'Available',
                            style: GoogleFonts.poppins(
                                color: AppColors.accentGreen,
                                fontSize: fontSize * 1,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Not Available',
                          child: Text(
                            'Not Available',
                            style: GoogleFonts.poppins(
                                color: AppColors.accentRed,
                                fontSize: fontSize * 1,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Edit',
                          child: Text(
                            'Edit Price',
                            style: GoogleFonts.poppins(
                                color: AppColors.primaryOrange,
                                fontSize: fontSize * 1,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text(
                            'Delete',
                            style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontSize: fontSize * 1,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  available,
                  style: GoogleFonts.poppins(
                    color: available == 'Available'
                        ? AppColors.accentGreen
                        : AppColors.accentRed,
                    fontWeight: FontWeight.bold,
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
                remainingtime == null? SizedBox.shrink() : 
                remainingtime == "Expired"
                    ? Text(
                        '$remainingtime',
                        style: GoogleFonts.poppins(
                            color: AppColors.secondaryText,
                            fontSize: fontSize * 0.8,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        'Ends in $remainingtime',
                        style: GoogleFonts.poppins(
                            color: AppColors.secondaryText,
                            fontSize: fontSize * 0.8,
                            fontWeight: FontWeight.bold),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


