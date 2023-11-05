// class Detail {
//   final int id;
//   final String name;
//   final List<Address> address;
//   final List<RestaurantImageEntities1> restaurantImageEntities1;
//   final String description;
//   final String phoneNumber;
//   final double rate;
//   final int usersRated;

//   Detail(
//       {required this.id,
//       required this.name,
//       required this.address,
//       required this.restaurantImageEntities1,
//       required this.description,
//       required this.phoneNumber,
//       required this.rate,
//       required this.usersRated});
//   factory Detail.fromJson(Map<String, dynamic> json) {
//     return Detail(
//       id: json['id'],
//       name: json['name'],
//       address: parseAddress(json),
//       restaurantImageEntities1: parseImages1(json),
//       description: json['description'] ?? 'No description',
//       phoneNumber: json['phoneNumber'],
//       rate: json['rate'],
//       usersRated: json["usersRated"],
//     );
//   }

//   static List<Address> parseAddress(imagesJson) {
//     var list = imagesJson['address'] as List;

//     return list.map((data) => Address.fromJson(data)).toList();
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

// class Address {
//   final int id;
//   final String street;
//   final String city;
//   final String email;

//   Address(
//       {required this.id,
//       required this.street,
//       required this.city,
//       required this.email});

//   factory Address.fromJson(Map<dynamic, dynamic> json) {
//     return Address(
//         id: json['id'],
//         street: json['street'],
//         city: json['city'],
//         email: json['email']);
//   }
// }
