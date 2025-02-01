import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:zovo/customer/view/homescreen/homescreen.dart';
import 'package:zovo/services/Auth/Auth_services.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<Userlogin>((event, emit) async {
      emit(Authloading());
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn(
            clientId:
                '1034567890-abcdefghijklmnopqrstuvwxyz1234567.apps.googleusercontent.com',
            scopes: ['email', 'profile']);
        await googleSignIn.signOut(); // Sign out first to force account picker
        final result = await AuthService().Signinwithgoogle();
        if (result != null) {
          final userRef = FirebaseFirestore.instance
              .collection('customers')
              .doc(result.user!.email);
          final userData = {
            'email': result.user!.email,
          };
          await userRef.set(userData);
         
        }
      } catch (e) {
        print('Error signing in with Google: $e');
        return emit(AuthError(error: ' Error :$e'));
      } finally {
       emit(AuthSuccess( ));
      }
    });
  }
}
