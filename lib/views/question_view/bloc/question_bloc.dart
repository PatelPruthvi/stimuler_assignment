import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stimuler_assignment/models/question_model.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  List<Question> questions;
  QuestionBloc(this.questions)
      : super(QuestionState.initial(questions.length)) {
    on<SelectOption>(_onSelectOption);
    on<CheckAnswer>(_onCheckAnswer);
    on<NextQuestion>(_onNextQuestion);
  }

  void _onSelectOption(SelectOption event, Emitter<QuestionState> emit) {
    emit(state.copyWith(selectedOption: event.selectedOption));
  }

  void _onCheckAnswer(CheckAnswer event, Emitter<QuestionState> emit) {
    bool isCorrect =
        questions[state.currentQuestionIndex].options[state.selectedOption] ==
            questions[state.currentQuestionIndex].answer;

    emit(state.copyWith(isAnswerChecked: true, isAnswerCorrect: isCorrect));
    if (isCorrect) {
      emit(state.copyWith(correctAnswerCnt: state.correctAnswerCnt + 1));
      Future.delayed(const Duration(seconds: 1), () {
        add(NextQuestion());
      });
    }
  }

  void _onNextQuestion(NextQuestion event, Emitter<QuestionState> emit) {
    if (state.currentQuestionIndex < questions.length - 1) {
      int nextIndex = state.currentQuestionIndex + 1;
      double newProgress = (nextIndex) / questions.length;
      emit(state.copyWith(
        currentQuestionIndex: nextIndex,
        selectedOption: -1,
        isAnswerChecked: false,
        isAnswerCorrect: false,
        progress: newProgress,
      ));
    } else {
      emit(state.copyWith(
          progress: 1,
          isAnswerChecked: false,
          isAnswerCorrect: false,
          selectedOption: -1));
    }
  }
}
