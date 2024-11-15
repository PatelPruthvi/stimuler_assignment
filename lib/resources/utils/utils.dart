import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stimuler_assignment/models/exersice_model.dart';

import '../components/bottom_sheet/ui/custom_bottom_sheet.dart';

class Utils {
  static showToast({required String msg}) {
    Fluttertoast.showToast(msg: msg);
  }

  static showSnackBar({required String msg, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  static showBottomSheet(
      {required BuildContext context, required List<Exersice> exersiceList}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: CustomBottomSheet(exersiceList: exersiceList),
      ),
    );
  }
}
