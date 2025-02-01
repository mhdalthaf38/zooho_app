part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}
class AuthSuccess extends SignupState{
 
}
class AuthError extends SignupState{
  final String error;
AuthError({required this.error});
}

class Authloading extends SignupState{}