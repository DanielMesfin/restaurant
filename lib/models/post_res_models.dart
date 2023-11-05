class Restaurant {
  Restaurant({
    this.id,
    required this.name,
    required this.tag,
    required this.address,
    required this.restaurantImageEntities,
    required this.description,
    required this.phoneNumber,
    required this.openHours,
    required this.latitude,
    required this.longitude,
    this.rate,
    this.usersRated,
    required this.menuId,
  });

  final int? id;
  final String name;
  final String tag;
  final List<Address> address;
  final List<RestaurantImageEntity> restaurantImageEntities;
  final String description;
  final String phoneNumber;
  final List<OpenHour> openHours;
  final double latitude;
  final double longitude;
  final double? rate;
  final int? usersRated;
  final List<int>? menuId;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        tag: json["tag"],
        address:
            List<Address>.from(json["address"].map((x) => Address.fromJson(x))),
        restaurantImageEntities: List<RestaurantImageEntity>.from(
            json["restaurantImageEntities"]
                .map((x) => RestaurantImageEntity.fromJson(x))),
        description: json["description"],
        phoneNumber: json["phoneNumber"],
        openHours: List<OpenHour>.from(
            json["openHours"].map((x) => OpenHour.fromJson(x))),
        latitude: json["latitude"],
        longitude: json["longitude"],
        rate: json["rate"],
        usersRated: json["usersRated"],
        menuId: json["menuId"] == null
            ? null
            : List<int>.from(json["menuId"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tag": tag,
        "address": List<dynamic>.from(address.map((x) => x.toJson())),
        "restaurantImageEntities":
            List<dynamic>.from(restaurantImageEntities.map((x) => x.toJson())),
        "description": description,
        "phoneNumber": phoneNumber,
        "openHours": List<dynamic>.from(openHours.map((x) => x.toJson())),
        "latitude": latitude,
        "longitude": longitude,
        "rate": rate,
        "usersRated": usersRated,
        "menuId": List<dynamic>.from(menuId!.map((x) => x)),
      };
}

class Address {
  Address({
    this.id,
    required this.street,
    required this.city,
    required this.email,
  });

  final int? id;
  final String street;
  final String city;
  final String email;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        street: json["street"],
        city: json["city"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "street": street,
        "city": city,
        "email": email,
      };
}

class OpenHour {
  OpenHour({
    this.id,
    required this.openDays,
    required this.startTime,
    required this.endTime,
  });

  final int? id;
  final String openDays;
  final String startTime;
  final String endTime;

  factory OpenHour.fromJson(Map<String, dynamic> json) => OpenHour(
        id: json["id"],
        openDays: json["openDays"],
        startTime: json["startTime"],
        endTime: json["endTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "openDays": openDays,
        "startTime": startTime,
        "endTime": endTime,
      };
}

class RestaurantImageEntity {
  RestaurantImageEntity({
    this.id,
    required this.url,
  });

  final int? id;
  final String url;

  factory RestaurantImageEntity.fromJson(Map<String, dynamic> json) =>
      RestaurantImageEntity(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}
