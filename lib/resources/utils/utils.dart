// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stimuler_assignment/models/exersice_model.dart';
import 'package:stimuler_assignment/resources/colors/colors.dart';

import '../../views/home_view/bloc/home_bloc.dart';
import '../../views/question_view/bloc/question_bloc.dart';
import '../components/bottom_sheet/ui/custom_bottom_sheet.dart';
import '../components/bottom_sheet/ui/incorrect_answer_sheet.dart';

class Utils {
  static showToast({required String msg}) {
    Fluttertoast.showToast(msg: msg);
  }

  static showSnackBar({required String msg, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  static showBottomSheet(
      {required BuildContext context,
      required List<Exersice> exersiceList,
      required HomeBloc homeBloc}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child:
            CustomBottomSheet(exersiceList: exersiceList, homeBloc: homeBloc),
      ),
    );
  }

  static showIncorrectAnswerDialog(
      {required BuildContext context,
      required String correctAnswer,
      required QuestionBloc questionBloc}) {
    showModalBottomSheet(
      enableDrag: false,
      showDragHandle: false,
      isDismissible: false,
      context: context,
      backgroundColor: AppColors.kLightMaroon,
      builder: (context) => Padding(
          padding: const EdgeInsets.all(20),
          child: IncorrectAnswerDialogWidget(
              correctAnswer: correctAnswer, questionBloc: questionBloc)),
    );
  }
}
