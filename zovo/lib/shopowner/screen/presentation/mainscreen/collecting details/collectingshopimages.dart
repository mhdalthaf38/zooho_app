import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/mainscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/detailspage.dart';
import 'package:zovo/theme.dart';

final supabase = Supabase.instance.client;

class imageDetailspage extends StatefulWidget {
  @override
  _imageDetailspageState createState() => _imageDetailspageState();
}

class _imageDetailspageState extends State<imageDetailspage> {
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
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final List<XFile>? images =
                            await picker.pickMultiImage();

                        if (images != null && images.isNotEmpty) {
                          final email = FirebaseAuth.instance.currentUser?.email;
                          List<String> imageUrls = [];

                          try {
                            for (var image in images) {
                              final bytes = await image.readAsBytes();
                              final fileExt = image.path.split('.').last;
                              final fileName =
                                  '${DateTime.now().toIso8601String()}.$fileExt';
                              final filePath = fileName;

                              // Create a user-specific path
                              final userSpecificPath =
                                  'users/$email/$filePath';

                              await supabase.storage
                                  .from('shop_images')
                                  .uploadBinary(userSpecificPath, bytes);

                              final imageUrl = supabase.storage
                                  .from('shop_images')
                                  .getPublicUrl(userSpecificPath);

                              imageUrls.add(imageUrl);
                            }

                            // First create the document if it doesn't exist
                            await FirebaseFirestore.instance
                                .collection('shops')
                                .doc(email)
                                .set({'shopImages': []},
                                    SetOptions(merge: true));

                            // Then update the array with all new images
                            await FirebaseFirestore.instance
                                .collection('shops')
                                .doc(email)
                                .update({
                              'shopImages': FieldValue.arrayUnion(imageUrls)
                            });

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Images uploaded successfully')));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()));
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
                      },
                      child: Text(
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
