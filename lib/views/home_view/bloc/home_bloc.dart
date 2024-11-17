import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stimuler_assignment/data/exercise_data.dart';
import 'package:stimuler_assignment/models/day_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeLastNodeUpdatedEvent>(homeLastNodeUpdatedEvent);
  }
  List<DayModel> days = daysData.map((val) => DayModel.fromJson(val)).toList();

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    // await TableHelper().fetchAllData().then((val) {
    //   days = val;
    // }).onError((err, stack) {
    //   print("Error is $err");
    // });

    emit(state.copyWith(days: days));
    add(HomeLastNodeUpdatedEvent());
  }

  FutureOr<void> homeLastNodeUpdatedEvent(
      HomeLastNodeUpdatedEvent event, Emitter<HomeState> emit) {
    int lastIdx = 0;
    for (int i = 1; i < days.length; i++) {
      if (days[i].isCompleted) {
        lastIdx++;
      } else {
        if (days[i].exersices.every((e) => e.isCompleted == true)) {
          days[i].isCompleted = true;
          lastIdx++;
        } else if (days[i - 1].isCompleted) {
          lastIdx++;
        } else {
          break;
        }
      }
      emit(state.copyWith(lastCompletedLesson: lastIdx));
    }
  }
}
