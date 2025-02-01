import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:zovo/services/Auth/Auth_services.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/detailspage.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/mainscreen.dart';

part 'customersignup_event.dart';
part 'customersignup_state.dart';

class CustomersignupBloc extends Bloc<CustomersignupEvent, CustomersignupState> {
  CustomersignupBloc() : super(CustomersignupInitial()){

    on<Customerlogin>((event,emit)async{
      emit(Authloading());
 try {
                          final GoogleSignIn googleSignIn = GoogleSignIn(
                            clientId: '1034567890-abcdefghijklmnopqrstuvwxyz1234567.apps.googleusercontent.com',
                            scopes: ['email', 'profile']
                          );
                          await googleSignIn.signOut();
                          final result = await AuthService().Signinwithgoogle();
                          if (result != null) {
                       
                            
                            if (result.additionalUserInfo?.isNewUser ?? false) {
                             // Add user email to Firebase collection
                             await FirebaseFirestore.instance.collection('emails').doc(result.user?.email).set({
                               'email': result.user?.email,
                               'timestamp': FieldValue.serverTimestamp(),
                             });
                              emit(AuthSuccess(newuser: true));
                            
                            } else {
                              emit(AuthSuccess(newuser: false));
                         
                            }
                          }
                        } catch (e) {
                          print('Error signing in with Google: $e');
                          emit(AuthError(errorMessage: 'error: $e'));
                        }
    });
  }

  
 
}
