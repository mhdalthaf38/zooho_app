part of 'profilebloc_bloc.dart';

@immutable
abstract class ProfileblocEvent {}
class menuclicked extends ProfileblocEvent {
 
  final String email;
  menuclicked({required this.email});
}