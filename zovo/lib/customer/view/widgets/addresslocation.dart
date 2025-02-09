import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
class LocationDetails {
  final double latitude;
  final double longitude;
  final String placeName;
  final String locality; // City/Town
  final String state;
  final String country;

  LocationDetails({
    required this.latitude,
    required this.longitude,
    required this.placeName,
    required this.locality,
    required this.state,
    required this.country,
  });

  @override
  String toString() {
    return "Lat: $latitude, Lng: $longitude\nPlace: $placeName, City: $locality, State: $state, Country: $country";
  }
}

Future<LocationDetails?> getUserLocationAndAddress() async {
  try {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    // Check and request location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied.");
    }

    // Get current GPS position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Get address from coordinates
     
 Map<String, String> address = await _getAddressFromLatLng(LatLng(position.latitude, position.longitude));
    if (address['state'] != null) {
     
      return LocationDetails(
        latitude: position.latitude,
        longitude: position.longitude,
        placeName: address['place'] ?? "Unknown",
        locality: address['city'] ?? "Unknown",
        state: address['state'] ?? "Unknown",
        country: address['area'] ?? "Unknown",
      );
    } else {
      throw Exception("Address not found.");
    }
  
  } catch (e) {
    print("Error: $e");
    return null;
  }
}


Future<Map<String, String>> _getAddressFromLatLng(LatLng position) async {
  try {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Extract Address Components
      final address = data['address'] ?? {};

      String placeName = address['name'] ??
          address['road'] ??
          address['neighbourhood'] ??
          address['suburb'] ??
          "Unknown Place";

      String area = address['suburb'] ??
          address['village'] ??
          address['town'] ??
          "Unknown Area";

      String city = address['city'] ??
          address['municipality'] ??
          address['county'] ??
          "Unknown City";

      String state = address['state'] ?? "Unknown State";

      return {
        "place": placeName,
        "area": area,
        "city": city,
        "state": state,
      };
    } else {
      return {
        "place": "Failed to get location",
        "area": "Failed to get area",
        "city": "Failed to get city",
        "state": "Failed to get state",
      };
    }
  } catch (e) {
    return {
      "place": "Error fetching location",
      "area": "Error fetching area",
      "city": "Error fetching city",
      "state": "Error fetching state",
    };
  }
}
