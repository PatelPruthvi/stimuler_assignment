part of 'question_bloc.dart';

@immutable
sealed class QuestionEvent {}

class SelectOption extends QuestionEvent {
  final int selectedOption;

  SelectOption(this.selectedOption);
}

class CheckAnswer extends QuestionEvent {}

class NextQuestion extends QuestionEvent {}
