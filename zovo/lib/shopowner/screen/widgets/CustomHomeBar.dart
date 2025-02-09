import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/collectingshopimages.dart';
import 'package:zovo/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
class CustomOFFERCard extends StatefulWidget {
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

static Future<Uint8List> convertToJpeg(File file) async {
    Uint8List imageBytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);

    if (image == null) {
      print("Error: Could not decode image.");
      return imageBytes; // Return original if decoding fails
    }

    // ✅ Convert to JPEG format
    return Uint8List.fromList(img.encodeJpg(image, quality: 90)); 
  } 

  @override
  State<CustomOFFERCard> createState() => _CustomOFFERCardState();
}

class _CustomOFFERCardState extends State<CustomOFFERCard> {
  Future<void> checkAndUpdateAvailability( ) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection(widget.collectionName)
          .doc(widget.email)
          .collection('items')
          .doc(widget.id)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          if (widget.collectionName == 'today_offers' && data['created_at'] != null) {
            final createdAt = (data['created_at'] as Timestamp).toDate();
            final now = DateTime.now();
            final difference = now.difference(createdAt);

            if (difference.inHours >= 24) {
              await updateAvailability(false);
            }
          } else if (widget.collectionName == 'offers' &&
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


  Future<void> deleteItem(BuildContext context) async {


     try {
      if (widget.collectionName == 'today_offers' ) {
        await FirebaseFirestore.instance
            .collection(widget.collectionName)
            .doc(widget.email)
            .collection('items')
            .doc(widget.id)
           .delete();
        await FirebaseFirestore.instance
            .collection(widget.subcollectionName)
            .doc('${widget.email}${widget.itemId}')
            .delete();
      } else if (widget.collectionName == 'offers' ) {
      

      
          await FirebaseFirestore.instance
              .collection(widget.collectionName)
              .doc(widget.email)
              .collection('items')
              .doc('${widget.id}')
             .delete();
          await FirebaseFirestore.instance
              .collection(widget.subcollectionName)
              .doc('${widget.email}offers${widget.itemId}')
              .delete();
        
      } else if(widget.collectionName == 'menu_items'){
         await FirebaseFirestore.instance
              .collection(widget.subcollectionName)
              .doc('${widget.email}offers${widget.itemId}')
              .delete();
                await FirebaseFirestore.instance
            .collection(widget.subcollectionName)
            .doc('${widget.email}${widget.itemId}')
            .delete();
        await FirebaseFirestore.instance
            .collection(widget.collectionName)
            .doc(widget.email)
            .collection('items')
            .doc(widget.id)
            .delete();
              await FirebaseFirestore.instance
            .collection('offers')
            .doc(widget.email)
            .collection('items')
            .doc(widget.id)
            .delete();
             await FirebaseFirestore.instance
            .collection('today_offers')
            .doc(widget.email)
            .collection('items')
            .doc(widget.id)
            .delete();
             
           
      }
    } catch (e) {
      print('Error deleting item: $e');
    }
   
  }

 Future<void> updateAvailability(bool isAvailable) async {
    try {
      await FirebaseFirestore.instance
          .collection(widget.collectionName)
          .doc(widget.email)
          .collection('items')
          .doc(widget.id)
          .update({'Available': isAvailable});
      await FirebaseFirestore.instance
          .collection(widget.subcollectionName)
          .doc('${widget.email}${widget.itemId}')
          .update({'Available': isAvailable});
    } catch (e) {
      print('Error updating availability: $e');
    }
  }

  Future<void> updatetoAvailable(bool isAvailable, BuildContext context) async {
    try {
      if (widget.collectionName == 'today_offers') {
        await FirebaseFirestore.instance
            .collection(widget.collectionName)
            .doc(widget.email)
            .collection('items')
            .doc(widget.id)
            .update({
          'Available': isAvailable,
          'created_at': Timestamp.now(),
        });
        await FirebaseFirestore.instance
            .collection(widget.subcollectionName)
            .doc('${widget.email}${widget.itemId}')
            .update({
          'Available': isAvailable,
          'created_at': Timestamp.now(),
        });
        print('anythinsdadsadad');
      } else if (widget.collectionName == 'offers') {
      

        if (isAvailable ==  true) {
            DateTimeRange? dateRange = await showDateRangePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        );
          await FirebaseFirestore.instance
              .collection(widget.collectionName)
              .doc(widget.email)
              .collection('items')
              .doc('${widget.id}')
              .update({
            'Available': isAvailable,
            'start_date': Timestamp.fromDate(dateRange!.start),
            'end_date': Timestamp.fromDate(dateRange.end),
          });
          await FirebaseFirestore.instance
              .collection(widget.subcollectionName)
              .doc('${widget.email}offers${widget.itemId}')
              .update({
            'Available': isAvailable,
            'start_date': Timestamp.fromDate(dateRange.start),
            'end_date': Timestamp.fromDate(dateRange.end),
          });
        }else{
            await FirebaseFirestore.instance
              .collection(widget.collectionName)
              .doc(widget.email)
              .collection('items')
              .doc('${widget.id}')
              .update({
            'Available': isAvailable,
           
          });
          await FirebaseFirestore.instance
              .collection(widget.subcollectionName)
              .doc('${widget.email}offers${widget.itemId}')
              .update({
            'Available': isAvailable,
          
          });
        }
      } else {
        await FirebaseFirestore.instance
            .collection(widget.collectionName)
            .doc(widget.email)
            .collection('items')
            .doc(widget.id)
            .update({'Available': isAvailable});
            
      }
    } catch (e) {
      print('Error updating availability: $e');
    }
  }
 
File? addimage;

Future<void> addphoto(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add photo', style: GoogleFonts.poppins()),
      content: GestureDetector(
        onTap: () async {
          final ImagePicker _picker = ImagePicker();
          final XFile? _images = await _picker.pickImage(source: ImageSource.gallery);
          if (_images != null) { // Ensure image is selected
            setState(() {
              addimage = File(_images.path);
            });
          } else {
            // Handle case when no image is selected
            print('No image selected');
          }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: addimage == null
                  ? Colors.red
                  : AppColors.primaryOrange,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: addimage != null
              ? Center(
                  child: Text('Image Selected',
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 16,
                      )))
              : Center(
                  child: Text('Tap to add image *',
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 16,
                      ))),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('Update'),
          onPressed: () async {
            if (addimage != null) {
              try {
                // Show loading state
                setState(() {
                  // Show loading indicator if needed
                });

                // Convert the image
                Uint8List convertedImage = await CustomOFFERCard.convertToJpeg(addimage!);
                String base64Image = base64Encode(convertedImage);

                // Upload image to Imgur
                const String clientId = "c5ed6cacbb2b5ee";
                var response = await http.post(
                  Uri.parse("https://api.imgur.com/3/upload"),
                  headers: {
                    "Authorization": "Client-ID $clientId",
                  },
                  body: {
                    "image": base64Image,
                    "type": "base64",
                  },
                );

                String? imageUrl;
                if (response.statusCode == 200) {
                  var data = jsonDecode(response.body);
                  imageUrl = data["data"]["link"]; // Get the image URL
                  print("Uploaded Image URL: $imageUrl");
                } else {
                  print("Error: ${response.body}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Image upload failed. Please try again.')),
                  );
                }

                if (imageUrl != null) {
                  final email = FirebaseAuth.instance.currentUser?.email;
                  // Add item to Firebase
                  await FirebaseFirestore.instance
                      .collection('menu_items')
                      .doc(email)
                      .collection('items')
                      .doc(widget.id)
                      .update({
                    'imageUrl': imageUrl,
                  });
                  

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Item updated successfully')),
                  );
                  setState(() {
                    addimage = null;
                  });
                  Navigator.pop(context); // Close the dialog
                }
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              } finally {
                setState(() {
                  // Hide loading indicator if any
                });
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please select an image first')),
              );
            }
          },
        ),
      ],
    ),
  );
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
      if (widget.collectionName == 'today_offers' ) {
        await FirebaseFirestore.instance
            .collection(widget.collectionName)
            .doc(widget.email)
            .collection('items')
            .doc(widget.id)
             .update({'price':double.tryParse(priceController.text) });
        await FirebaseFirestore.instance
            .collection(widget.subcollectionName)
            .doc('${widget.email}${widget.itemId}')
         .update({'discount_price': double.tryParse(priceController.text)});
      } else if (widget.collectionName == 'offers') {
      
      
          await FirebaseFirestore.instance
              .collection(widget.collectionName)
              .doc(widget.email)
              .collection('items')
              .doc('${widget.id}')
             .update({'price':double.tryParse(priceController.text)});
          await FirebaseFirestore.instance
              .collection(widget.subcollectionName)
              .doc('${widget.email}offers${widget.itemId}')
              .update({'discount_price': double.tryParse(priceController.text)});
        
      } else {
        await FirebaseFirestore.instance
            .collection(widget.collectionName)
            .doc(widget.email)
            .collection('items')
            .doc(widget.id)
           .update({'price': double.tryParse(priceController.text)});
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
                image:widget.imageUrl == '' ? AssetImage('assets/images/noimage.jpg') :NetworkImage(widget.imageUrl),
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
                    child:widget.imageUrl == ""?null: Column(
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
                          'AT ₹${widget.rate}',
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
                        widget.title,
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
                        }else if(value == 'Add Photo'){
                          addphoto(context);
                        }
                      },
                      itemBuilder:widget.collectionName == 'menu_items'?(BuildContext context) => [
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
                          value: 'Add Photo',
                          child: Text(
                            'Add Photo',
                            style: GoogleFonts.poppins(
                                color: Colors.red,
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
                      ]:(BuildContext context) => [
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
                  widget.available,
                  style: GoogleFonts.poppins(
                    color: widget.available == 'Available'
                        ? AppColors.accentGreen
                        : AppColors.accentRed,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.offer != null ? '${widget.offer} / ₹${widget.rate}' : '₹${widget.rate}',
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryOrange,
                    fontSize: fontSize * 0.8,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                widget.remainingtime == null? SizedBox.shrink() : 
                widget.remainingtime == "Expired"
                    ? Text(
                        '${widget.remainingtime}',
                        style: GoogleFonts.poppins(
                            color: AppColors.secondaryText,
                            fontSize: fontSize * 0.8,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        'Ends in ${widget.remainingtime}',
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




