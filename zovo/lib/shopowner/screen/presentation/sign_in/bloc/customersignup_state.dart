part of 'customersignup_bloc.dart';

@immutable
abstract class CustomersignupState {}

class CustomersignupInitial extends CustomersignupState {}
class Authloading extends CustomersignupState{}
class AuthSuccess extends CustomersignupState{
  final bool newuser ;
  AuthSuccess({required this.newuser});
}
class AuthError extends CustomersignupState{
  final String errorMessage;
  AuthError({required this.errorMessage});
}