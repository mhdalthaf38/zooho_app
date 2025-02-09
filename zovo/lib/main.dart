import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zovo/customer/view/alloffers/bloc/userhome_bloc.dart';
import 'package:zovo/customer/view/homescreen/bloc/userlocation_bloc.dart';

import 'package:zovo/customer/view/homescreen/homescreen.dart';
import 'package:zovo/customer/view/nearby/returentdetails/bloc/resturent_bloc.dart';


import 'package:zovo/services/database/deleteexpireddata.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/collectingshopimages.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/detailspage.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/placepicker.dart';


import 'package:zovo/shopowner/screen/presentation/mainscreen/mainscreen.dart';

import 'package:zovo/shopowner/screen/presentation/sign_in/welcomescreen.dart';

import 'package:zovo/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
    providers: [
    
          
        
               BlocProvider(create:(context)=>ResturentBloc() ),
                BlocProvider(create:(context)=>UserlocationBloc() ),
                BlocProvider(create:(context)=>UserhomeBloc() ),
         
            
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'zoho app',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder<firebase_auth.User?>(
          stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
          builder: (context, data) {
            if (data.hasData) {
              return StreamBuilder<DocumentSnapshot?>(
                stream: FirebaseFirestore.instance
                    .collection('shops')
                    .doc(data.data?.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.data() != null) {
                    Map<String, dynamic> shopData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    if (!shopData.containsKey('shopName') ||
                        shopData['shopName'] == null ||
                        shopData['shopName'] == '') {
                      return Detailspage();
                    } else if (!shopData.containsKey('latitude')) {
                      return PlacePicker();
                    } else if (!shopData.containsKey('longitude')) {
                      return PlacePicker();
                    } else if (!shopData.containsKey('shopImages')) {
                      return imageDetailspage();
                    } else {
                      return MainPage();
                    }
                  } else {
                    return StreamBuilder<DocumentSnapshot?>(
                        stream: FirebaseFirestore.instance
                            .collection('customers')
                            .doc(data.data?.email)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.data() != null) {
                            Map<String, dynamic> shopData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            if (shopData.containsKey('email') ||
                                shopData['email'] != null ||
                                shopData['email'] != '') {
                              return UserHome();
                            } else {
                              return WelcomeScreen();
                            }
                          } else {
                            return WelcomeScreen();
                          }
                        });
                  }
                },
              );
            }
            return WelcomeScreen();
          },
        ),
      ),
    );
  }
}
 
// Future<void> deleteExpiredOffers() async {
//   // Get the current date
//   DateTime now = DateTime.now();
  
//   // Reference to the 'offers_today' collection
//   CollectionReference offersToday = FirebaseFirestore.instance.collection('offers_today');

//   // Get all documents in the collection
//   QuerySnapshot snapshot = await offersToday.get();

//   for (var doc in snapshot.docs) {
//     var offerType = doc['Offertype']; // Get the offer type
//     if (offerType == 'today_offers') {
//       // Correctly handle Timestamp field for 'created_at'
//       Timestamp createdAtTimestamp = doc['created_at']; // Firestore stores this as a Timestamp
//       DateTime createdAt = createdAtTimestamp.toDate(); // Convert to DateTime

//       Duration difference = now.difference(createdAt);

//       // If it's more than 24 hours, delete the document
//       if (difference.inHours > 24) {
//         await offersToday.doc(doc.id).delete();
//         print('Deleted document with ID: ${doc.id} (today_offers)');
//       }
//     } else if (offerType == 'offers') {
    
//      Timestamp  endDateTimestamp = doc['end_date'];
//    DateTime endDate = endDateTimestamp.toDate();

//       if (endDate.isBefore(now)) {
//         await offersToday.doc(doc.id).delete();
//         print('Deleted document with ID: ${doc.id} (offers)');
//       }
//     }
//   }
// }