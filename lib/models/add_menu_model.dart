class AddMenuModel {
  // int id;
  String name;
  List<int> foodId;
  String description;
  // MenuCategory menuCategory;
  int restaurantId;

  AddMenuModel(
    // this.id,
    this.name,
    this.foodId,
    this.description,
    // this.menuCategory,
    this.restaurantId,
  );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "name": name,
        "foodId":
            foodId == null ? null : List<dynamic>.from(foodId.map((x) => x)),
        "description": description,
        // "menuCategory": menuCategory.toJson(),
        "restaurantId": restaurantId,
      };
}

class UpdateMenuModel {
  int id;
  String name;
  List<int> foodId;
  String description;
  // MenuCategory menuCategory;
  int restaurantId;

  UpdateMenuModel(
    this.id,
    this.name,
    this.foodId,
    this.description,
    // this.menuCategory,
    this.restaurantId,
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "foodId":
            foodId == null ? null : List<dynamic>.from(foodId.map((x) => x)),
        "description": description,
        // "menuCategory": menuCategory.toJson(),
        "restaurantId": restaurantId,
      };
}
