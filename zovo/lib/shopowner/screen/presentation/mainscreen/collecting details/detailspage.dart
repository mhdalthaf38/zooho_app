import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/placepicker.dart';
import 'package:zovo/theme.dart';

class Detailspage extends StatefulWidget {
  @override
  State<Detailspage> createState() => _DetailspageState();
}

class _DetailspageState extends State<Detailspage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _LocationController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _shopDescriptionController = TextEditingController();

  Map<String, List<String>> areasByDistrict = {
    'Kollam': ['Kundara', 'Karunagappally', 'Chavara', 'Kottarakkara', 'Punalur', 'Kadakkal', 'Anchal'],
    'Thiruvananthapuram': ['Varkala', 'Attingal', 'Neyyattinkara', 'Nedumangad', 'Kazhakkoottam'],
    'Pathanamthitta': ['Adoor', 'Konni', 'Ranni', 'Pandalam', 'Thiruvalla'],
    'Alappuzha': ['Chengannur', 'Mavelikkara', 'Kayamkulam', 'Haripad', 'Ambalappuzha'],
    'Kottayam': ['Pala', 'Vaikom', 'Changanassery', 'Kanjirappally', 'Erattupetta'],
    'Idukki': ['Thodupuzha', 'Munnar', 'Adimali', 'Kumily', 'Nedumkandam'],
    'Ernakulam': ['Aluva', 'Perumbavoor', 'Angamaly', 'Muvattupuzha', 'Kothamangalam'],
    'Thrissur': ['Chalakudy', 'Kodungallur', 'Irinjalakuda', 'Guruvayur', 'Kunnamkulam'],
    'Palakkad': ['Ottapalam', 'Mannarkkad', 'Chittur', 'Alathur', 'Pattambi'],
    'Malappuram': ['Tirur', 'Ponnani', 'Manjeri', 'Perinthalmanna', 'Nilambur'],
    'Kozhikode': ['Vadakara', 'Koyilandy', 'Thamarassery', 'Feroke', 'Ramanattukara'],
    'Wayanad': ['Kalpetta', 'Mananthavady', 'Sulthan Bathery', 'Meenangadi'],
    'Kannur': ['Thalassery', 'Payyanur', 'Mattannur', 'Iritty', 'Kannur City'],
    'Kasaragod': ['Kanhangad', 'Nileshwaram', 'Cheruvathur', 'Uppala', 'Manjeshwar'],
  };

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isLoading = false;

    return Scaffold(
      backgroundColor: AppColors.primaryOrange,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.secondaryCream),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Collecting Details",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondaryCream,
                    fontSize: screenWidth * 0.08,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do tempor",
                  style: GoogleFonts.poppins(
                    color: AppColors.secondaryCream,
                    fontSize: screenWidth * 0.04,
                  )
                ),
              ],
            ),
          ),

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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _shopNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter shop name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: AppColors.primaryOrange),
                          ),
                          focusColor: AppColors.primaryOrange,
                          floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                          labelText: 'Shop Name',
                          labelStyle: TextStyle(fontSize: screenWidth * 0.045),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: AppColors.secondaryCream,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      TextFormField(
                        controller: _LocationController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter location';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: AppColors.primaryOrange),
                          ),
                          focusColor: AppColors.primaryOrange,
                          floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                          labelText: 'Location',
                          labelStyle: TextStyle(fontSize: screenWidth * 0.045),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: AppColors.secondaryCream,
                          suffixIcon: PopupMenuButton<String>(
                            color: AppColors.secondaryCream,
                            icon: Icon(Icons.arrow_drop_down),
                            onSelected: (String value) {
                              setState(() {
                                _LocationController.text = value;
                                _areaController.clear(); // Clear area when location changes
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                'Thiruvananthapuram',
                                'Kollam',
                                'Pathanamthitta',
                                'Alappuzha',
                                'Kottayam',
                                'Idukki',
                                'Ernakulam',
                                'Thrissur',
                                'Palakkad',
                                'Malappuram',
                                'Kozhikode',
                                'Wayanad',
                                'Kannur',
                                'Kasaragod',
                              ].map<PopupMenuItem<String>>((String value) {
                                return PopupMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      TextFormField(
                        controller: _areaController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an area';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: AppColors.primaryOrange),
                          ),
                          focusColor: AppColors.primaryOrange,
                          floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                          labelText: 'Area',
                          labelStyle: TextStyle(fontSize: screenWidth * 0.045),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: AppColors.secondaryCream,
                          suffixIcon: _LocationController.text.isNotEmpty
                              ? PopupMenuButton<String>(
                                  color: AppColors.secondaryCream,
                                  icon: Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    setState(() {
                                      _areaController.text = value;
                                    });
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return (areasByDistrict[_LocationController.text] ?? [])
                                        .map<PopupMenuItem<String>>((String value) {
                                      return PopupMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList();
                                  },
                                )
                              : null,
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      TextFormField(
                        controller: _phonenumberController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: AppColors.primaryOrange),
                          ),
                          focusColor: AppColors.primaryOrange,
                          floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                          labelText: 'Phone number',
                          labelStyle: TextStyle(fontSize: screenWidth * 0.045),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: AppColors.secondaryCream,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      TextFormField(
                        controller: _shopDescriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter shop description';
                          }
                          return null;
                        },
                        maxLines: 3,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: AppColors.primaryOrange),
                          ),
                          focusColor: AppColors.primaryOrange,
                          floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                          labelText: 'Write about your shop',
                          labelStyle: TextStyle(fontSize: screenWidth * 0.045),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: AppColors.secondaryCream,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                        ),
                        onPressed: isLoading ? null : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              final email = FirebaseAuth.instance.currentUser?.email;
                              await FirebaseFirestore.instance.collection('shops').doc(email).set({
                                'shopName': _shopNameController.text,
                                'location': _LocationController.text,
                                'area': _areaController.text,
                                'phoneNumber': _phonenumberController.text,
                                'shopDescription': _shopDescriptionController.text,
                                'email': email,
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PlacePicker()),
                              );
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: isLoading
                            ? CircularProgressIndicator(color: AppColors.secondaryCream)
                            : Text(
                                "Next",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.secondaryCream,
                                  fontSize: screenWidth * 0.045,
                                ),
                              ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}