// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:stimuler_assignment/models/exersice_model.dart';

class DayModel {
  String title;
  List<Exersice> exersices;
  bool isCompleted;
  DayModel(
      {required this.title,
      required this.exersices,
      required this.isCompleted});

  factory DayModel.fromJson(Map<String, dynamic> json) => DayModel(
      title: json["title"],
      exersices: List<Exersice>.from(
          json["exersices"].map((x) => Exersice.fromJson(x))),
      isCompleted: json['isCompleted']);
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["exersices"] = List<dynamic>.from(exersices.map((x) => x.toJson()));
    data["isCompleted"] = isCompleted;

    return data;
  }
}
