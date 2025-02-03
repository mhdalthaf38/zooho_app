part of 'resturent_bloc.dart';

@immutable
abstract class ResturentState {}

class ResturentInitial extends ResturentState {}
class shopdataloading extends ResturentState{}
class shopdataloaded extends ResturentState{
  final Map<String,dynamic> shopdata ;

  shopdataloaded( {required this.shopdata});

}

class gettingerror extends ResturentState{}

class todayoffersloaded extends ResturentState{
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> today_offers;
final String email;
  todayoffersloaded({required this.today_offers,required this.email});
}
class todayoffersloading extends ResturentState{}
class todayoffersError extends ResturentState{}