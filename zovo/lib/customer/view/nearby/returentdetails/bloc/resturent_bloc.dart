import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'resturent_event.dart';
part 'resturent_state.dart';

class ResturentBloc extends Bloc<ResturentEvent, ResturentState> {
  ResturentBloc() : super(ResturentInitial()) {
    on<Fetchshopdata>((event, state) async {
      try {
        emit(shopdataloading());
        final snapshopt = await FirebaseFirestore.instance
            .collection('shops')
            .doc(event.email)
            .get();
        if (snapshopt.exists) {
          emit(shopdataloaded(
              shopdata: snapshopt.data() as Map<String, dynamic>));
        }
      } catch (e) {
        emit(gettingerror());
      }
    });

    on<FetchTodayoffersdata>((event, emit) async {
      try {
        emit(todayoffersloading());
        final snapshot = await FirebaseFirestore.instance
            .collection('today_offers')
            .doc(event.email)
            .collection('items')
            .get();
        if (snapshot.docs.isNotEmpty) {
          emit(
            todayoffersloaded(today_offers: snapshot.docs, email: event.email));
        }
      } catch (e) {
        emit(todayoffersError());
      }
    });
  }
}
