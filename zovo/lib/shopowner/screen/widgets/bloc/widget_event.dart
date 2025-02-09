part of 'widget_bloc.dart';

@immutable
abstract class WidgetEvent {}
class fetchuploadedimage extends WidgetEvent{
  File image;
  fetchuploadedimage({required this.image});
}