import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/theme.dart';

class AddOfferItems extends StatefulWidget {
  const AddOfferItems({Key? key}) : super(key: key);

  @override
  State<AddOfferItems> createState() => _AddOfferItemsState();
}

class _AddOfferItemsState extends State<AddOfferItems> {
  String? selectedItem;
  final TextEditingController _discountPriceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime? startDate;
  DateTime? endDate;
  String? itemError;
  String? priceError;
  String? dateError;
   double? currentPrice;
  String? selectedItemImage;
  String? selectedItemName;
  String? description;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final email = FirebaseAuth.instance.currentUser?.email;
    return Scaffold(
      backgroundColor: AppColors.secondaryCream,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryCream,
        title:  Text('Add Offer Items' ,style: GoogleFonts.poppins(
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
                            onChanged: (value) async{
                              setState(() {
                                selectedItem = value;
                                itemError = null;
                              });
                               if (value != null) {
                                final doc = await FirebaseFirestore.instance
                                    .collection('menu_items')
                                    .doc(email)
                                    .collection('items')
                                    .doc(value)
                                    .get();
                                setState(() {
                                  currentPrice = doc['price'].toDouble();
                                  selectedItemImage = doc['imageUrl'];
                                  selectedItemName = doc['name'];
                                  description = doc['description'];
                                });
                              }
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
                          if (itemError != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 8),
                              child: Text(
                                itemError!,
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                            if (selectedItemImage != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(selectedItemImage!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (currentPrice != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Current Price: ₹${currentPrice!.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  color: AppColors.primaryOrange,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTimeRange? dateRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.primaryOrange,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (dateRange != null) {
                        setState(() {
                          startDate = dateRange.start;
                          endDate = dateRange.end;
                          _dateController.text =
                              '${startDate!.day}/${startDate!.month}/${startDate!.year} - ${endDate!.day}/${endDate!.month}/${endDate!.year}';
                          dateError = null;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.primaryOrange),
                      ),
                      focusColor: AppColors.primaryOrange,
                      floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                      labelText: 'Select Offer Date Range',
                      labelStyle: TextStyle(fontSize: screenWidth * 0.045),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: AppColors.secondaryCream,
                      suffixIcon: Icon(Icons.calendar_today, color: AppColors.primaryOrange),
                      errorText: dateError,
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
                    itemError = 'Please select an item';
                    hasError = true;
                  });
                }
                
                if (_discountPriceController.text.isEmpty) {
                  setState(() {
                    priceError = 'Please enter discount price';
                    hasError = true;
                  });
                }
                
                if (startDate == null || endDate == null) {
                  setState(() {
                    dateError = 'Please select date range';
                    hasError = true;
                  });
                }
                
                if (!hasError) {
                  // Check if offer already exists
                  final existingOffers = await _firestore
                      .collection('offers')
                      .doc(email)
                      .collection('items')
                      .where('item_id', isEqualTo: selectedItem)
                      .where('Available', isEqualTo: true)
                      .get();

                  if (existingOffers.docs.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Already added the offer')),
                    );
                    return;
                  }

                  await _firestore.collection('offers').doc(email).collection('items').add({
                    'item_id': selectedItem,
                    'price': double.parse(_discountPriceController.text),
                    'start_date': Timestamp.fromDate(startDate!),
                    'end_date': Timestamp.fromDate(endDate!),
                    'created_at': FieldValue.serverTimestamp(),
                    'Available': true,
                  });
                  await _firestore.collection('offers_today').doc('$email+$selectedItem').set({
                     'Offertype':'offers',
                    'email': email,
                    'item_id': selectedItem,
                    'item_name': selectedItemName,
                    'item_image': selectedItemImage,
                    'item_price': currentPrice,
                    'discount_price': double.parse(_discountPriceController.text),
                    'start_time': Timestamp.fromDate(startDate!),
                    'end_date': Timestamp.fromDate(endDate!),
                    'created_at': FieldValue.serverTimestamp(),
                    'Available': true,
                    'description':description,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item added to offers')),
                  );
                  
                  setState(() {
                    selectedItem = null;
                    _discountPriceController.clear();
                    _dateController.clear();
                    startDate = null;
                    endDate = null;
                    itemError = null;
                    priceError = null;
                    dateError = null;
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