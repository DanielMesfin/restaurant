class UserReviewPostModel {
  UserReviewPostModel({
    required this.feedback,
    required this.firstName,
    required this.lastName,
    required this.feedbackDate,
    required this.feedbackType,
    this.reply,
  });

  final String feedback;
  final String firstName;
  final String lastName;
  final DateTime feedbackDate;
  final String feedbackType;
  final String? reply;

  factory UserReviewPostModel.fromJson(Map<String, dynamic> json) =>
      UserReviewPostModel(
        feedback: json["feedback"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        feedbackDate: DateTime.parse(json["feedbackDate"]),
        feedbackType: json["feedbackType"],
        reply: json["reply"],
      );

  Map<String, dynamic> toJson() => {
        "feedback": feedback,
        "firstName": firstName,
        "lastName": lastName,
        "feedbackDate": feedbackDate.toIso8601String(),
        "feedbackType": feedbackType,
        "reply": reply,
      };
}
