import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
// google sign in
  Signinwithgoogle() async {
 final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
 if (googleUser == null) 
 
 return;
 final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
 final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);  
   return await _firebaseAuth.signInWithCredential(credential);
  }

 
}