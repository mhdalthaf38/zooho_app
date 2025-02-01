
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:zovo/customer/view/homescreen/homescreen.dart';
import 'package:zovo/customer/view/sigup/bloc/signup_bloc.dart';





import 'package:zovo/theme.dart';

class Usersignup extends StatefulWidget {
  @override
  _UsersignupState createState() => _UsersignupState();
}

class _UsersignupState extends State<Usersignup> {


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
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if(state is AuthError){
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
          if (state is AuthSuccess) {
             Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  UserHome(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
          }
        },
        builder: (context, state) {
      
          return Stack(
            children: [
              // Top Text Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.03), // Responsive spacing
                    Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondaryCream,
                        fontSize: screenWidth * 0.08, // Responsive font
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                        "you need better offers? then you are at the right place ",
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Shop Owner Sign-In Button

                        // Customer Sign-In Button
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
                          onPressed: () async {
                            context.read<SignupBloc>().add(Userlogin(context: context));
                          },
                          child: state is Authloading
                              ? CircularProgressIndicator(
                                  color: AppColors.secondaryCream,
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/google.webp',
                                      width: screenWidth * 0.055,
                                    ),
                                    SizedBox(width: screenWidth * 0.02),
                                    Text(
                                      "Sign up with Google",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.secondaryCream,
                                        fontSize: screenWidth * 0.045,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
