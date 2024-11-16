part of 'home_bloc.dart';

class HomeState {
  final List<DayModel> days;
  final int lastCompletedLesson;

  HomeState({required this.lastCompletedLesson, required this.days});
  factory HomeState.initial() {
    return HomeState(days: [], lastCompletedLesson: 0);
  }

  HomeState copyWith({List<DayModel>? days, int? lastCompletedLesson}) {
    return HomeState(
        days: days ?? this.days,
        lastCompletedLesson: lastCompletedLesson ?? this.lastCompletedLesson);
  }
}
