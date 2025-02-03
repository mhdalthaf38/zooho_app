import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/mainscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:zovo/theme.dart';
import 'package:http/http.dart' as http;

final supabase = Supabase.instance.client;

class imageDetailspage extends StatefulWidget {
  @override
  _imageDetailspageState createState() => _imageDetailspageState();
}

class _imageDetailspageState extends State<imageDetailspage> {
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


void _selectphoto() async {
setState(() {
  isLoading = true;
});
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _image = File(image.path);
                          });
                        }

                        if (_image != null) {
                          final email =
                              FirebaseAuth.instance.currentUser?.email;

                          try {
                            String? imageUrl;
                            Uint8List convertedImage =
                                await convertToJpeg(_image!);
                            String base64Image = base64Encode(convertedImage);

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
                            if (response.statusCode == 200) {
                              var data = jsonDecode(response.body);
                              String imageUrls =
                                  data["data"]["link"]; // Get the image URL
                              print("Uploaded Image URL: $imageUrls");
                              setState(() {
                                imageUrl = imageUrls;
                              });
                            } else {
                              print("Error: ${response.body}");
                            }
                            if (imageUrl == null) {
                              return print('Try again');
                            } else {
                              // First create the document if it doesn't exist
                              await FirebaseFirestore.instance
                                  .collection('shops')
                                  .doc(email)
                                  .set({'shopImages': ''},
                                      SetOptions(merge: true));

                              // Then update the array with all new images
                              await FirebaseFirestore.instance
                                  .collection('shops')
                                  .doc(email)
                                  .update({'shopImages': imageUrl});

                              if (mounted) {
                               
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainPage()));
                              }
                            }
                          } catch (e) {
                            print(e);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Error uploading images: $e')));
                            }
                          }
                        }
                        setState(() {
  isLoading = false;
});
                      }


  File? _image;
  static const String clientId = "c5ed6cacbb2b5ee";
  bool isLoading =false;
  @override
  Widget build(BuildContext context) {
    // Fetching screen height and width dynamically
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: AppColors.primaryOrange, // Background color
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.secondaryCream),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(children: [
          // Top Text Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.03), // Responsive spacing
                Text(
                  "update your Shop Images",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondaryCream,
                    fontSize: screenWidth * 0.08, // Responsive font
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do tempor",
                    style: GoogleFonts.poppins(
                      color: AppColors.secondaryCream,
                      fontSize: screenWidth * 0.04,
                    )),
              ],
            ),
          ),

          // Bottom Card Section
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: AppColors.secondaryCream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Full Name Field
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02, // Responsive padding
                        ),
                      ),
                      onPressed: isLoading? null: _selectphoto,
                      child:isLoading?CircularProgressIndicator(color: AppColors.secondaryCream,): Text(
                        "Upload photos",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w900,
                          color: AppColors.secondaryCream,
                          fontSize: screenWidth * 0.045, // Responsive font
                        ), // Responsive font
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    SizedBox(height: screenHeight * 0.02),

                    // Google and Facebook Buttons
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}
