// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import 'package:stimuler_assignment/models/exersice_model.dart';
import 'package:stimuler_assignment/resources/utils/utils.dart';
import 'package:stimuler_assignment/views/home_view/bloc/home_bloc.dart';
import 'package:stimuler_assignment/views/question_view/bloc/question_bloc.dart';

import '../../../models/question_model.dart';
import '../../../resources/colors/colors.dart';

class QuestionView extends StatelessWidget {
  final Exersice exersice;
  final List<Question> questions;
  final HomeBloc homeBloc;
  const QuestionView({
    super.key,
    required this.exersice,
    required this.questions,
    required this.homeBloc,
  });

  @override
  Widget build(BuildContext context) {
    final QuestionBloc questionBloc = QuestionBloc(questions, exersice);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grammar Practice'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.flag_outlined))
        ],
      ),
      body: BlocConsumer<QuestionBloc, QuestionState>(
        bloc: questionBloc,
        listener: (context, state) {
          if (state.isAnswerChecked && !state.isAnswerCorrect) {
            Future.delayed(const Duration(seconds: 1), () {
              Utils.showIncorrectAnswerDialog(
                  questionBloc: questionBloc,
                  context: context,
                  correctAnswer: questions[state.currentQuestionIndex].answer);
            });
          } else if (state.progress == 1) {
            // that is whenever all questions are attempted
            Utils.showSnackBar(
                context: context,
                msg:
                    "You scored ${state.correctAnswerCnt} / ${questions.length}. Saving test details...");

            Future.delayed(const Duration(milliseconds: 1800), () {
              Navigator.pop(context);
              homeBloc.add(HomeLastNodeUpdatedEvent());
            });
          }
        },
        builder: (context, state) {
          Question currentQuestion = questions[state.currentQuestionIndex];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Bar
                  SimpleAnimationProgressBar(
                    height: 5,
                    width: MediaQuery.of(context).size.width * 0.9,
                    backgroundColor: AppColors.kDarkGray!,
                    foregrondColor: AppColors.kGreen,
                    ratio: state.progress,
                    direction: Axis.horizontal,
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(seconds: 5),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.kGreen,
                        offset: Offset(
                          2.5,
                          2.5,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Question Title
                  Text(
                    'Q${state.currentQuestionIndex + 1}. Fill in the blanks',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Question Text
                  Text(
                    currentQuestion.question,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // Image (Avatar or Illustration)
                  Center(
                    child: Image.network(
                      'https://avatar.iran.liara.run/public/1', // Sample image URL
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Options
                  for (int i = 0; i < currentQuestion.options.length; i++)
                    multipleChoiceOptionTile(i, currentQuestion.options[i],
                        state, questionBloc, String.fromCharCode(65 + i)),

                  const SizedBox(height: 20),
                  // Check Answer Button
                  ElevatedButton(
                      onPressed: () {
                        if (state.selectedOption != -1 &&
                            !state.isAnswerChecked) {
                          questionBloc.add(CheckAnswer());
                        } else if (state.isAnswerChecked) {
                          Utils.showToast(
                              msg:
                                  'You have already responded to this question');
                        } else {
                          Utils.showToast(
                              msg: 'Please select an option to proceed...');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.isAnswerChecked
                            ? (state.isAnswerCorrect
                                ? AppColors.kGreen
                                : AppColors.kMaroon)
                            : state.selectedOption != -1
                                ? AppColors.kBlue
                                : AppColors.kDarkGray,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                          state.isAnswerChecked
                              ? state.isAnswerCorrect
                                  ? 'Great Work!'
                                  : 'That wasn\'t right'
                              : 'Check Answer',
                          style: const TextStyle(
                              fontSize: 16, color: AppColors.kWhite))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget multipleChoiceOptionTile(int index, String text, QuestionState state,
      QuestionBloc questionBloc, String label) {
    bool isSelected = state.selectedOption == index;
    bool isCorrect = state.isAnswerChecked &&
        questions[state.currentQuestionIndex].answer ==
            questions[state.currentQuestionIndex].options[index];
    return GestureDetector(
      onTap: () {
        if (!state.isAnswerChecked) {
          questionBloc.add(SelectOption(index));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (state.isAnswerChecked
                  ? (isCorrect ? AppColors.kGreen : AppColors.kMaroon)
                  : AppColors.kBlue)
              : AppColors.kBlack,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.kLightGray),
        ),
        child: Row(
          children: [
            // Option Label (A, B, C, etc.)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  shape: BoxShape.rectangle,
                  color: AppColors.kDarkGray),
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
          ],
        ),
      ),
    );
  }
}
