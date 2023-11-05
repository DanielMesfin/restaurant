class UserInfoModel {
  UserInfoModel({
    required this.userPublicId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.userPassword,
    required this.email,
    required this.address,
    // required this.questionsAndAnswers,
  });

  String userPublicId;
  String firstName;
  String lastName;
  String phoneNumber;
  String userPassword;
  String email;
  Address address;
  // List<String> questionsAndAnswers;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        userPublicId: json["userPublicId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        userPassword: json["userPassword"],
        email: json["email"],
        address: Address.fromJson(json["address"]),
        // questionsAndAnswers:
        //     List<String>.from(json["questionsAndAnswers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "userPublicId": userPublicId,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "userPassword": userPassword,
        "email": email,
        "address": address.toJson(),
        // "questionsAndAnswers":
        //     List<dynamic>.from(questionsAndAnswers.map((x) => x)),
      };
}

class Address {
  Address({
    this.id,
    required this.street,
    required this.city,
  });

  int? id;
  String street;
  String city;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        street: json["street"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "street": street,
        "city": city,
      };
}
