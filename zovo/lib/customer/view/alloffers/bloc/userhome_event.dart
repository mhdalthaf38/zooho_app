part of 'userhome_bloc.dart';

@immutable
abstract class UserhomeEvent {}
class todayofferslistlength extends UserhomeEvent{
  int itemlength;
  todayofferslistlength({required this.itemlength});
}
