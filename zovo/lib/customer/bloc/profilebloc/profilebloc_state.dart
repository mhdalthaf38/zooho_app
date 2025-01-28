part of 'profilebloc_bloc.dart';

@immutable
abstract class ProfileblocState {}

class ProfileblocInitial extends ProfileblocState {}
class menudata extends ProfileblocState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> menuitems;
  menudata(this.menuitems);
}