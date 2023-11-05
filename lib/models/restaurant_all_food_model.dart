// class GetMenuModel {
//   GetMenuModel({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.foods,
//     required this.restaurantId,
//   });

//   int id;
//   String name;
//   String description;
//   List<GetMenuFoods> foods;
//   int restaurantId;

//   factory GetMenuModel.fromJson(Map<String, dynamic> json) => GetMenuModel(
//         id: json["id"],
//         name: json["name"],
//         description: json["description"],
//         foods: List<GetMenuFoods>.from(
//             json["foods"].map((x) => GetMenuFoods.fromJson(x))),
//         restaurantId: json["restaurantId"],
//       );

//   // Map<String, dynamic> toJson() => {
//   //     "id": id,
//   //     "name": name,
//   //     "description": description,
//   //     "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
//   //     "restaurantId": restaurantId,
//   // };
// }

class RestaurantAllFoodModel {
  RestaurantAllFoodModel({
    required this.id,
    required this.name,
    required this.foodImageEntities,
    required this.description,
    required this.price,
    required this.restaurantId,
  });

  int id;
  String name;
  List<FoodImageEntity> foodImageEntities;
  String description;
  double price;
  int restaurantId;

  factory RestaurantAllFoodModel.fromJson(Map<String, dynamic> json) =>
      RestaurantAllFoodModel(
        id: json["id"],
        name: json["name"],
        foodImageEntities: List<FoodImageEntity>.from(
            json["foodImageEntities"].map((x) => FoodImageEntity.fromJson(x))),
        description: json["description"],
        price: json["price"],
        restaurantId: json["restaurantId"],
      );

  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "name": name,
  //     "foodImageEntities": List<dynamic>.from(foodImageEntities.map((x) => x.toJson())),
  //     "description": description,
  //     "price": price,
  //     "restaurantId": restaurantId,
  // };
}

class FoodImageEntity {
  FoodImageEntity({
    required this.id,
    required this.url,
  });

  int id;
  String url;

  factory FoodImageEntity.fromJson(Map<String, dynamic> json) =>
      FoodImageEntity(
        id: json["id"],
        url: json["url"],
      );

  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "url": url,
  // };
}
