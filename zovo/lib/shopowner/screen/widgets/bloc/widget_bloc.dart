import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'widget_event.dart';
part 'widget_state.dart';

class WidgetBloc extends Bloc<WidgetEvent, WidgetsState> {
  WidgetBloc() : super(WidgetInitial()){
    on<fetchuploadedimage>((event,emit){
      emit(updateimage(updatedimage: event.image));
    });
  }


}
