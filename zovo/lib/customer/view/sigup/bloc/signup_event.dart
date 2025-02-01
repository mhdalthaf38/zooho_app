part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}
class Userlogin extends SignupEvent{
  final BuildContext context;
  Userlogin({required this.context});
}