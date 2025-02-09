part of 'userhome_bloc.dart';

@immutable
abstract class UserhomeState {}

class UserhomeInitial extends UserhomeState {}
class today_offersLength extends UserhomeState{
  int itemlength = 0;
  today_offersLength({required this.itemlength});
}
