class FavoriteFoodModel {
  FavoriteFoodModel({
    required this.id,
    required this.name,
    required this.foodImageEntities,
    required this.description,
    required this.price,
    required this.restaurantId,
  });

  final int id;
  final String name;
  final List<FoodImageEntity> foodImageEntities;
  final String description;
  final double price;
  final int restaurantId;

  factory FavoriteFoodModel.fromJson(Map<String, dynamic> json) =>
      FavoriteFoodModel(
        id: json["id"],
        name: json["name"],
        foodImageEntities: List<FoodImageEntity>.from(
            json["foodImageEntities"].map((x) => FoodImageEntity.fromJson(x))),
        description: json["description"],
        price: json["price"],
        restaurantId: json["restaurantId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "foodImageEntities":
            List<dynamic>.from(foodImageEntities.map((x) => x.toJson())),
        "description": description,
        "price": price,
        "restaurantId": restaurantId,
      };
}

class FoodImageEntity {
  FoodImageEntity({
    required this.id,
    required this.url,
  });

  final int id;
  final String url;

  factory FoodImageEntity.fromJson(Map<String, dynamic> json) =>
      FoodImageEntity(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}
