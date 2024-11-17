import 'question_model.dart';
import 'result_model.dart';

class Exersice {
  String title;
  bool isCompleted;
  String imgLink;
  Results results;
  List<Question> questions;

  Exersice(
      {required this.title,
      required this.isCompleted,
      required this.imgLink,
      required this.results,
      required this.questions});

  factory Exersice.fromJson(Map<String, dynamic> json) => Exersice(
        title: json['title'],
        isCompleted: json['isCompleted'],
        imgLink: json['imgLink'],
        results: Results.fromJson(json['results']),
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['isCompleted'] = isCompleted;
    data['imgLink'] = imgLink;

    data['results'] = results.toJson();

    data['questions'] = List<dynamic>.from(questions.map((x) => x.toJson()));

    return data;
  }
}
