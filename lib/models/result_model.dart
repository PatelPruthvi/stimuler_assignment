class Results {
  int? totalQuestions;
  int? correctAnswers;

  Results({required this.totalQuestions, required this.correctAnswers});

  factory Results.fromJson(Map<String, dynamic> json) => Results(
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalQuestions'] = totalQuestions;
    data['correctAnswers'] = correctAnswers;
    return data;
  }
}
