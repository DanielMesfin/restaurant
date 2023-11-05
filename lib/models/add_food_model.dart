class AddFoodModel {
  int? id;
  String name;
  List<FoodImage> foodImageEntities;
  String description;
  int price;
  int restaurantId;
  AddFoodModel(this.id, this.name, this.foodImageEntities, this.description,
      this.price, this.restaurantId);
  Map toJson() {
    List<Map>? imageJson =
        foodImageEntities.map((image) => image.toJson()).toList();
    return {
      'id': id ?? id,
      'name': name,
      'foodImageEntities': imageJson,
      'description': description,
      'price': price,
      'restaurantId': restaurantId
    };
  }
}

class FoodImage {
  // int id;
  String url;
  FoodImage(this.url);
  Map toJson() => {'url': url};
}

class UpdateFoodModel {
  int id;
  String name;
  List<UpdateFoodImage> foodImageEntities;
  String description;
  int price;
  UpdateFoodModel(
      this.id, this.name, this.foodImageEntities, this.description, this.price);
  Map toJson() {
    List<Map>? imageJson =
        foodImageEntities.map((image) => image.toJson()).toList();
    return {
      'name': name,
      'foodImageEntities': imageJson,
      'description': description,
      'price': price
    };
  }
}

class UpdateFoodImage {
  // int id;
  String url;
  UpdateFoodImage(
    this.url,
  );
  Map toJson() => {
        'url': url,
      };
}
