class UserReviewModel {
  UserReviewModel({
    required this.id,
    required this.feedback,
    required this.user,
    required this.currentTime,
  });

  final int id;
  final String feedback;
  final User user;
  final DateTime currentTime;

  factory UserReviewModel.fromJson(Map<String, dynamic> json) =>
      UserReviewModel(
        id: json["id"],
        feedback: json["feedback"],
        user: User.fromJson(json["user"]),
        currentTime: DateTime.parse(json["currentTime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "feedback": feedback,
        "user": user.toJson(),
        "currentTime": currentTime.toIso8601String(),
      };
}

class User {
  User({
    required this.id,
    required this.userName,
    required this.passWord,
    // required this.roles,
    required this.createdOn,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.userPublicId,
    // required this.address,
    required this.questionsAndAnswers,
    required this.verifiedEmail,
    required this.isEmailVerified,
    required this.locked,
    required this.enabled,
  });

  final int id;
  final String userName;
  final String passWord;
  // final List<Role> roles;
  final DateTime createdOn;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String userPublicId;
  // final Address address;
  final String questionsAndAnswers;
  final dynamic verifiedEmail;
  final bool isEmailVerified;
  final bool locked;
  final bool enabled;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userName: json["userName"],
        passWord: json["passWord"],
        // roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
        createdOn: DateTime.parse(json["createdOn"]),
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        userPublicId: json["userPublicId"],
        // address: Address.fromJson(json["address"]),
        questionsAndAnswers: json["questionsAndAnswers"],
        verifiedEmail: json["verifiedEmail"],
        isEmailVerified: json["isEmailVerified"],
        locked: json["locked"],
        enabled: json["enabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "passWord": passWord,
        // "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
        "createdOn": createdOn.toIso8601String(),
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "userPublicId": userPublicId,
        // "address": address.toJson(),
        "questionsAndAnswers": questionsAndAnswers,
        "verifiedEmail": verifiedEmail,
        "isEmailVerified": isEmailVerified,
        "locked": locked,
        "enabled": enabled,
      };
}
