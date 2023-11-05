class RestaurantsList {
  final int id;
  final String name;
  final List<RestaurantImageEntities> restaurantImageEntities;
  final String description;
  final String phoneNumber;
  final double rate;
  final Owner owner;
  final int usersRated;

  RestaurantsList(
      {required this.id,
      required this.name,
      required this.restaurantImageEntities,
      required this.description,
      required this.phoneNumber,
      required this.rate,
      required this.owner,
      required this.usersRated});

  factory RestaurantsList.fromJson(Map<String, dynamic> json) {
    return RestaurantsList(
      id: json['id'],
      name: json['name'],
      restaurantImageEntities: parseImages(json),
      description: json['description'] ?? 'No description',
      phoneNumber: json['phoneNumber'],
      rate: json['rate'],
      owner: Owner.fromJson(
        json["owner"],
      ),
      usersRated: json["usersRated"],
    );
  }

  static List<RestaurantImageEntities> parseImages(imagesJson) {
    var list = imagesJson['restaurantImageEntities'] as List;

    return list.map((data) => RestaurantImageEntities.fromJson(data)).toList();
  }
}

class RestaurantImageEntities {
  final String url;
  RestaurantImageEntities({required this.url});

  factory RestaurantImageEntities.fromJson(Map<dynamic, dynamic> json) {
    return RestaurantImageEntities(
        url: json['url'] ??
            'https://us.123rf.com/450wm/pavelstasevich/pavelstasevich1811/pavelstasevich181101027/112815900-no-image-available-icon-flat-vector.jpg?ver=6');
  }
}

class GetAddress {
  final String street;
  final String city;
  final String email;
  GetAddress({required this.street, required this.city, required this.email});
}

class Owner {
  // final int id;
  // final String userName;
  // final String passWord;
  // final List<Role> roles;
  // final DateTime createdOn;
  // final String firstName;
  // final String lastName;
  // final String phoneNumber;
  final String userPublicId;
  // final Address address;
  // final String questionsAndAnswers;
  // final String verifiedEmail;
  // final bool isEmailVerified;
  // final bool locked;
  // final bool enabled;

  Owner({
    // required this.id,
    // required this.userName,
    // required this.passWord,
    // required this.roles,
    // required this.createdOn,
    // required this.firstName,
    // required this.lastName,
    // required this.phoneNumber,
    required this.userPublicId,
    // required this.address,
    // required this.questionsAndAnswers,
    // required this.verifiedEmail,
    // required this.isEmailVerified,
    // required this.locked,
    // required this.enabled,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        // id: json["id"],
        // userName: json["userName"],
        // passWord: json["passWord"],
        // roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
        // createdOn: DateTime.parse(json["createdOn"]),
        // firstName: json["firstName"],
        // lastName: json["lastName"],
        // phoneNumber: json["phoneNumber"],
        userPublicId: json["userPublicId"],
        // address: Address.fromJson(json["address"]),
        // questionsAndAnswers: json["questionsAndAnswers"],
        // verifiedEmail: json["verifiedEmail"],
        // isEmailVerified: json["isEmailVerified"],
        // locked: json["locked"],
        // enabled: json["enabled"],
      );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "userName": userName,
//         "passWord": passWord,
//         "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
//         "createdOn": createdOn.toIso8601String(),
//         "firstName": firstName,
//         "lastName": lastName,
//         "phoneNumber": phoneNumber,
//         "userPublicId": userPublicId,
//         "address": address.toJson(),
//         "questionsAndAnswers": questionsAndAnswers,
//         "verifiedEmail": verifiedEmail,
//         "isEmailVerified": isEmailVerified,
//         "locked": locked,
//         "enabled": enabled,
//       };
// }

// class Role {
//   Role({
//     required this.id,
//     required this.name,
//   });

//   final int id;
//   final String name;

//   factory Role.fromJson(Map<String, dynamic> json) => Role(
//         id: json["id"],
//         name: json["name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//       };
// }

// class Address {
//   Address({
//     required this.id,
//     required this.street,
//     required this.city,
//     required this.email,
//   });

//   final int id;
//   final String street;
//   final String city;
//   final String email;

//   factory Address.fromJson(Map<String, dynamic> json) => Address(
//         id: json["id"],
//         street: json["street"],
//         city: json["city"],
//         email: json["email"] == null ? null : json["email"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "street": street,
//         "city": city,
//         "email": email == null ? null : email,
//       };
}

// class RestaurantDetail {
//   final int id;
//   final String name;
//   final List<RestaurantImageEntities1> restaurantImageEntities;
//   final String description;
//   RestaurantDetail(
//       {required this.id,
//       required this.name,
//       required this.restaurantImageEntities,
//       required this.description});
//   factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
//     return RestaurantDetail(
//         id: json['id'],
//         name: json['name'],
//         restaurantImageEntities: parseImages1(json),
//         description: json['description'] ?? 'No description');
//   }

//   static List<RestaurantImageEntities1> parseImages1(imagesJson) {
//     var list = imagesJson['restaurantImageEntities'] as List;

//     return list.map((data) => RestaurantImageEntities1.fromJson(data)).toList();
//   }
// }

// class RestaurantImageEntities1 {
//   final String url;
//   RestaurantImageEntities1({required this.url});

//   factory RestaurantImageEntities1.fromJson(Map<dynamic, dynamic> json) {
//     return RestaurantImageEntities1(
//         url: json['url'] ??
//             'https://us.123rf.com/450wm/pavelstasevich/pavelstasevich1811/pavelstasevich181101027/112815900-no-image-available-icon-flat-vector.jpg?ver=6');
//   }
// }

