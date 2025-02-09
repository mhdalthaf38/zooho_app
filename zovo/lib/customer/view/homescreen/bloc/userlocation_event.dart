part of 'userlocation_bloc.dart';

@immutable
abstract class UserlocationEvent {}
class locationt extends UserlocationEvent{
  String locationName;
  double latitude;
  double longitude;
  String city;
  String state;
  locationt({required this.city,required this.locationName,required this.latitude,required this.longitude,required this.state});
}