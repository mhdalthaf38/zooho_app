import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/theme.dart';

class Todayoffers extends StatefulWidget {
  const Todayoffers({Key? key}) : super(key: key);

  @override
  State<Todayoffers> createState() => _TodayoffersState();
}

class _TodayoffersState extends State<Todayoffers> {
  String? selectedItem;
  final TextEditingController _discountPriceController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime? startDate;
  DateTime? endDate;
  String? dropdownError;
  String? priceError;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final email = FirebaseAuth.instance.currentUser?.email;
    return Scaffold(
      backgroundColor: AppColors.secondaryCream,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryCream,
        title:  Text('Add Today Offer Items' ,style: GoogleFonts.poppins(
                      color: AppColors.primaryOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream:FirebaseFirestore.instance.collection('menu_items').doc(email).collection('items').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      List<DropdownMenuItem<String>> menuItems = snapshot.data!.docs
                          .map((doc) => DropdownMenuItem(
                                value: doc.id,
                                child: Text(doc['name']),
                              ))
                          .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton<String>(
                            style: GoogleFonts.poppins(
                                color: AppColors.primaryOrange,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            dropdownColor: AppColors.secondaryCream,
                            value: selectedItem,
                            hint: Text('Select an item',style: GoogleFonts.poppins(
                                color: AppColors.primaryOrange,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),),
                            items: menuItems,
                            onChanged: (value) {
                              setState(() {
                                selectedItem = value;
                                dropdownError = null;
                              });
                            },
                            icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryOrange),
                            isExpanded: true,
                            elevation: 3,
                            underline: Container(
                              height: 2,
                              color: AppColors.primaryOrange,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          if (dropdownError != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 8),
                              child: Text(
                                dropdownError!,
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _discountPriceController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        priceError = null;
                      });
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.primaryOrange),
                      ),
                      focusColor: AppColors.primaryOrange,
                      floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                      labelText: 'Discount Price',
                      labelStyle: TextStyle(fontSize: screenWidth * 0.045),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: AppColors.secondaryCream,
                      errorText: priceError,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      minimumSize: Size(screenWidth, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                    ),
              onPressed: () async {
                bool hasError = false;
                
                if (selectedItem == null) {
                  setState(() {
                    dropdownError = 'Please select an item';
                    hasError = true;
                  });
                }
                
                if (_discountPriceController.text.isEmpty) {
                  setState(() {
                    priceError = 'Please enter discount price';
                    hasError = true;
                  });
                }

                if (!hasError) {
                  // Check if the item already exists in today_offers
                  final existingOffer = await _firestore
                      .collection('today_offers')
                      .doc(email)
                      .collection('items')
                      .where('item_id', isEqualTo: selectedItem)
                      .get();

                  if (existingOffer.docs.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('This item already exists in offers')),
                    );
                    return;
                  }

                  await _firestore.collection('today_offers').doc(email).collection('items').add({
                    'item_id': selectedItem,
                    'discount_price': double.parse(_discountPriceController.text),
                    'created_at': FieldValue.serverTimestamp(),
                    'Available': true,
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item added to offers')),
                  );
                  
                  setState(() {
                    selectedItem = null;
                    _discountPriceController.clear();
                    startDate = null;
                    endDate = null;
                    dropdownError = null;
                    priceError = null;
                  });
                }
              },
              child: Text('Add to Offers',style: GoogleFonts.poppins(
                      color: AppColors.secondaryCream,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),)
            ),
          ],
        ),
      ),
    );
  }}