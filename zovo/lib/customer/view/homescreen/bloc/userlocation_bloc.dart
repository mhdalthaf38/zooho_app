import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'userlocation_event.dart';
part 'userlocation_state.dart';

class UserlocationBloc extends Bloc<UserlocationEvent, UserlocationState> {
  UserlocationBloc() : super(UserlocationInitial()) {
   on<locationt>((event,emit){
emit(UserlocationLoaded(city:event.city,locationName: event.locationName,state: event.state,userposition: LatLng(event.latitude, event.longitude) ));
   });
  }
}
//   /// 📌 Event Handler Function
//   Future<void> _onGetUserLocation(
//       gettinguserlocation event, Emitter<UserlocationState> emit) async {
//     try {
//       emit(Userlocationloading());

//       // Get current location
//       LatLng? userLocation = await _fetchCurrentLocation();
//       if (userLocation == null) {
//         emit(UserLocationerror());
//         return;
//       }

//       // Get address from lat/lng
//       Map<String, String> address = await _getAddressFromLatLng(userLocation);

//       // Emit loaded state
//       emit(UserlocationLoaded(
//       userposition: userLocation,
//       area: address["area"]!,
//       city: address["city"]!,
//       state: address["state"]!,
//     ));
//     } catch (e) {
//       emit(UserLocationerror());
//     }
//   }

//   /// 📌 Function to Request User Location Permission
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       throw Exception('❌ Location services are disabled.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('❌ Location permission denied.');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       await Geolocator.openAppSettings();
//       throw Exception('❌ Location permission permanently denied.');
//     }

//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }

//   /// 📌 Fetch Current Location (Latitude & Longitude)
//   Future<LatLng?> _fetchCurrentLocation() async {
//     try {
//       Position position = await _determinePosition();
//       return LatLng(position.latitude, position.longitude);
//     } catch (e) {
//       print("Error fetching location: $e");
//       return null;
//     }
//   }

//   /// 📌 Get Address from Latitude & Longitude
// Future<Map<String, String>> _getAddressFromLatLng(LatLng position) async {
//   try {
//     final url =
//         'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}';
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);

//       // Extract Address Components
//       final address = data['address'] ?? {};
//       String area = address['suburb'] ?? address['village'] ?? address['town'] ?? "Unknown Area";
//       String city = address['city'] ?? address['municipality'] ?? address['county'] ?? "Unknown City";
//       String state = address['state'] ?? "Unknown State";

//       return {
//         "area": area,
//         "city": city,
//         "state": state,
//       };
//     } else {
//       return {
//         "area": "Failed to get address",
//         "city": "Failed to get address",
//         "state": "Failed to get address",
//       };
//     }
//   } catch (e) {
//     return {
//       "area": "Error fetching address",
//       "city": "Error fetching address",
//       "state": "Error fetching address",
//     };
//   }
// }

// }
