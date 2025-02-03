part of 'resturent_bloc.dart';

@immutable
abstract class ResturentEvent {}
class Fetchshopdata extends ResturentEvent{
  final String email;

  Fetchshopdata({required this.email});
  
}
class FetchTodayoffersdata extends ResturentEvent{
  final String email;

  FetchTodayoffersdata({required this.email});
}