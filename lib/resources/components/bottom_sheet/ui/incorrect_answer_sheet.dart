import 'package:flutter/material.dart';

import '../../../../views/question_view/bloc/question_bloc.dart';
import '../../../colors/colors.dart';

class IncorrectAnswerDialogWidget extends StatelessWidget {
  final String correctAnswer;
  final QuestionBloc questionBloc;
  const IncorrectAnswerDialogWidget(
      {super.key, required this.correctAnswer, required this.questionBloc});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                "assets/icons/incorrect_icon.png",
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Incorrect Answer',
                      style: TextStyle(fontSize: 22),
                    ),
                    Text(
                      'Correct Answer is $correctAnswer',
                      style: const TextStyle(
                          fontSize: 20, color: AppColors.kYellow),
                    )
                  ],
                ),
              )
            ],
          ),
          const Expanded(
            child: Text(
              'Lore Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  minimumSize:
                      const WidgetStatePropertyAll(Size(double.infinity, 50)),
                  padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
                  foregroundColor:
                      const WidgetStatePropertyAll(AppColors.kWhite),
                  backgroundColor: WidgetStatePropertyAll(
                      AppColors.kLightMaroon.withOpacity(0.2))),
              onPressed: () {
                Navigator.pop(context);
                questionBloc.add(NextQuestion());
              },
              child: const Text("Continue to next question"))
        ],
      ),
    );
  }
}
