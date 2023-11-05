class GetAllMenuModel {
  GetAllMenuModel({
    required this.id,
    required this.name,
    // required this.foodId,
    required this.foods,
    required this.description,
    required this.restaurantId,
  });

  final int id;
  final String name;
  // final List<int> foodId;
  final List<dynamic> foods;
  final String description;
  final int restaurantId;

  factory GetAllMenuModel.fromJson(Map<String, dynamic> json) =>
      GetAllMenuModel(
        id: json["id"],
        name: json["name"],
        // foodId: json["foodId"],
        foods: json["foods"],
        description: json["description"],
        restaurantId: json["restaurantId"],
      );
}
