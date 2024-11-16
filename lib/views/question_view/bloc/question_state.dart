part of 'question_bloc.dart';

// @immutable
// sealed
class QuestionState {
  final int currentQuestionIndex;
  final int selectedOption;
  final bool isAnswerChecked;
  final bool isAnswerCorrect;
  final double progress;
  final int correctAnswerCnt;

  const QuestionState({
    required this.currentQuestionIndex,
    required this.selectedOption,
    required this.isAnswerChecked,
    required this.isAnswerCorrect,
    required this.progress,
    required this.correctAnswerCnt,
  });

  // Initial state factory method
  factory QuestionState.initial(int totalQuestions) {
    return QuestionState(
      currentQuestionIndex: 0,
      selectedOption: -1,
      isAnswerChecked: false,
      isAnswerCorrect: false,
      correctAnswerCnt: 0,
      progress: 0 / totalQuestions,
    );
  }

  // Copy with method for immutability
  QuestionState copyWith(
      {int? currentQuestionIndex,
      int? selectedOption,
      bool? isAnswerChecked,
      bool? isAnswerCorrect,
      double? progress,
      int? correctAnswerCnt}) {
    return QuestionState(
        currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
        selectedOption: selectedOption ?? this.selectedOption,
        isAnswerChecked: isAnswerChecked ?? this.isAnswerChecked,
        isAnswerCorrect: isAnswerCorrect ?? this.isAnswerCorrect,
        progress: progress ?? this.progress,
        correctAnswerCnt: correctAnswerCnt ?? this.correctAnswerCnt);
  }
}
