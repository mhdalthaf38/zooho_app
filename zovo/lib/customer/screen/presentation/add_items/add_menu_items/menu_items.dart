import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zovo/theme.dart';

class AddMenuItem extends StatefulWidget {
  @override
  _AddMenuItemState createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _uploadItem() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Upload image to Supabase Storage
        final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final storageResponse = await Supabase.instance.client.storage
            .from('shop menu items images')
            .upload(fileName, _image!);

        // Get the public URL of the uploaded image
        final String imageUrl = Supabase.instance.client.storage
            .from('shop menu items images')
            .getPublicUrl(fileName);
   final email = FirebaseAuth.instance.currentUser?.email;
        // Add item to Firebase
        await FirebaseFirestore.instance.collection('menu_items').doc(email).collection('items').add({
          'name': _nameController.text,
          'price': double.parse(_priceController.text),
          'description': _descriptionController.text,
          'imageUrl': imageUrl,
          'Available': true,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item added successfully')),
        );
        
        // Clear form
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        setState(() {
          _image = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding item: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.secondaryCream,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryCream,
        title: Text('Add Menu Item',style: GoogleFonts.poppins(
                      color: AppColors.secondaryCream,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: _image == null ? Colors.red : AppColors.primaryOrange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_image!, fit: BoxFit.cover,)
                        )
                      : Center(child: Text('Tap to add image *',style: GoogleFonts.poppins( color: Colors.red, fontSize: 16,))),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: AppColors.primaryOrange),
                  ),
                  focusColor: AppColors.primaryOrange,
                  floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                  labelText: 'Item name *',
                  labelStyle: TextStyle(fontSize: screenWidth * 0.045),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: AppColors.secondaryCream,
                  errorStyle: TextStyle(color: Colors.red),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item name';
                  }
                  if (value.length < 3) {
                    return 'Item name must be at least 3 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: AppColors.primaryOrange),
                  ),
                  focusColor: AppColors.primaryOrange,
                  floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                  labelText: 'Price *',
                  labelStyle: TextStyle(fontSize: screenWidth * 0.045),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: AppColors.secondaryCream,
                  errorStyle: TextStyle(color: Colors.red),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Price must be greater than 0';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: AppColors.primaryOrange),
                  ),
                  focusColor: AppColors.primaryOrange,
                  floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                  labelText: 'Description *',
                  labelStyle: TextStyle(fontSize: screenWidth * 0.045),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: AppColors.secondaryCream,
                  errorStyle: TextStyle(color: Colors.red),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  if (value.length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
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
                onPressed: _isLoading ? null : _uploadItem,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Add Item',style: GoogleFonts.poppins(
                      color: AppColors.secondaryCream,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}