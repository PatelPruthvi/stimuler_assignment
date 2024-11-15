import 'question_model.dart';
import 'result_model.dart';

class Exersice {
  String title;
  bool isCompleted;
  String imgLink;
  Results? results;
  List<Question> questions;

  Exersice(
      {required this.title,
      required this.isCompleted,
      required this.imgLink,
      this.results,
      required this.questions});

  factory Exersice.fromJson(Map<String, dynamic> json) => Exersice(
        title: json['title'],
        isCompleted: json['isCompleted'],
        imgLink: json['imgLink'],
        results:
            json['results'] != null ? Results.fromJson(json['results']) : null,
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['isCompleted'] = isCompleted;
    data['imgLink'] = imgLink;
    if (results != null) {
      data['results'] = results!.toJson();
    }

    data['questions'] = List<dynamic>.from(questions.map((x) => x.toJson()));

    return data;
  }
}
