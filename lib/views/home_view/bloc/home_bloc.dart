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
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) {
    List<DayModel> days = [];
    for (var dayJsonData in daysData) {
      days.add(DayModel.fromJson(dayJsonData));
    }
    emit(state.copyWith(days: days));
    int lastIdx = 0;
    for (int i = 1; i < days.length; i++) {
      if (days[i].isCompleted) {
        lastIdx++;
      } else {
        if (days[i - 1].isCompleted) {
          lastIdx++;
        } else {
          break;
        }
      }
    }
    emit(state.copyWith(lastCompletedLesson: lastIdx));
  }
}
