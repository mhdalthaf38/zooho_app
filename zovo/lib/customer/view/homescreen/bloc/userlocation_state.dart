part of 'userlocation_bloc.dart';

@immutable
abstract class UserlocationState {}

class UserlocationInitial extends UserlocationState {}
class UserlocationLoaded extends UserlocationState{
  final  userposition;
final String locationName;
  final String city;
  final String state;
  
  UserlocationLoaded( {required this.userposition,required this.locationName,required this.city,required this.state});
}
class Userlocationloading extends UserlocationState{}
class UserLocationerror extends UserlocationState{}