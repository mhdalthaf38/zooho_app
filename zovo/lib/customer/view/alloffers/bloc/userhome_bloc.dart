import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'userhome_event.dart';
part 'userhome_state.dart';

class UserhomeBloc extends Bloc<UserhomeEvent, UserhomeState> {
  UserhomeBloc() : super(UserhomeInitial()){
    on<todayofferslistlength>((event,emit){
emit(today_offersLength(itemlength: event.itemlength));
    });
    
  }

 
}
