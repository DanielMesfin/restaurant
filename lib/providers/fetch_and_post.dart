import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:urban_restaurant/helpers/http_exception.dart';
import 'package:urban_restaurant/models/favorite_food_model.dart';
import 'package:urban_restaurant/models/get_all_menu_model.dart';
import 'package:urban_restaurant/models/get_featured_restaurant.dart';
import 'package:urban_restaurant/models/get_menu_foods_model.dart';
import 'package:urban_restaurant/models/get_nearby_restaurants.dart';
import 'package:urban_restaurant/models/get_user_review_model.dart';
import 'package:urban_restaurant/models/post_res_models.dart';
import 'package:urban_restaurant/models/post_user_review_model.dart';
import 'package:urban_restaurant/models/restaurant_all_food_model.dart';
import 'package:urban_restaurant/models/user_info_model.dart';
import 'package:urban_restaurant/models/users_registered_restaurants.dart';
import 'package:urban_restaurant/style/colors.dart';
import 'package:urban_restaurant/widgets/bottom_nav_2.dart';
import 'package:urban_restaurant/widgets/post_registration_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/get_favorite_restaurants_list.dart';
import '../models/searched_restaurant_model.dart';
import '../screens/login.dart';
import '../style/style.dart';
import 'auth.dart';

class Fetch with ChangeNotifier {
  String? token, pid, savedLocationLat, savedLocationLon;
  List lisOfFavRestaurantId = [];
  List lisOfFavFoodId = [];
  Location currentLocation = Location();
  double? userLocationLat, userLocationLon;
  int selectedFoodCard = 0,
      page = 0,
      pageA = 0,
      size = 6,
      sizeA = 6,
      timeout = 10;
  bool isLoadMoreRunning = false,
      isLoadMoreRunningA = false,
      hasNextPage = true,
      hasNextPageA = true;
  Future<List<NearbyRestaurantsList>>? nearbyRestaurantList;
  Future<List<FeaturedRestaurantsList>>? featuredRestaurantList;
  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerA = ScrollController();
  BuildContext? cntxt;
  String backendUrl = 'https://esoora-backend-prod-qiymu.ondigitalocean.app';

  Future checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('userToken');
    pid = pref.getString('userId');
  }

  getCurrentLocation() async {
    LocationData location = await currentLocation.getLocation();
    userLocationLat = location.latitude!;
    userLocationLon = location.longitude!;
    savedLocationLat = location.latitude.toString();
    savedLocationLon = location.longitude.toString();
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('savedLocationLat', savedLocationLat!);
    await pref.setString('savedLocationLon', savedLocationLon!);
  }

  Future<List<FeaturedRestaurantsList>> fetchFeaturedRestaurants(ctx) async {
    cntxt = ctx;
    final url = Uri.parse(
        '$backendUrl/public/restaurant/popular?page=$page&size=$size');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['content'];
        return jsonResponse
            .map((data) => FeaturedRestaurantsList.fromJson(data))
            .toList();
      } else {
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Error Occured!'),
          backgroundColor: Colors.red,
        ));
      }
    } on TimeoutException {
      throw 'Network is timedout please try again.';
    } on SocketException {
      throw 'Network is unreachable! Please check your internet connection.';
    }
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<List<FeaturedRestaurantsList>> loadMore() async {
    if (hasNextPage == true &&
        isLoadMoreRunning == false &&
        scrollController.position.extentAfter < 300) {
      isLoadMoreRunning = true;
      notifyListeners();
      page += 1;
      final url = Uri.parse(
          '$backendUrl/public/restaurant/popular?page=$page&size=$size');
      try {
        final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
        ).timeout(Duration(seconds: timeout));
        if (response.statusCode == 200) {
          final List fetchedPosts = json.decode(response.body)['content'];
          List<FeaturedRestaurantsList> po = fetchedPosts
              .map((data) => FeaturedRestaurantsList.fromJson(data))
              .toList();
          if (fetchedPosts.isNotEmpty) {
            featuredRestaurantList!.then((value) => value.addAll(po));
            notifyListeners();
          } else {
            hasNextPage = false;
            notifyListeners();
          }
        }
      } on TimeoutException {
        scaffoldMessage(
            cntxt, 'Network is timedout! please try again.', Colors.red);
      } on SocketException {
        scaffoldMessage(
            cntxt,
            'Network is unreachable! Please check your internet connection.',
            Colors.red);
      } on Error {
        scaffoldMessage(cntxt, 'Error Occured!', Colors.red);
      }
      isLoadMoreRunning = false;
      notifyListeners();
    }
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<List<NearbyRestaurantsList>> fetchNearbyRestaurants(ctx) async {
    https: //esoora-backend-prod-qiymu.ondigitalocean.app/public/restaurant/near-by?page=0&size=3&latitude=0&longitude=0
    await getCurrentLocation();
    cntxt = ctx;
    String lat = userLocationLat!.toStringAsFixed(5);
    String lon = userLocationLon!.toStringAsFixed(5);
    final url = Uri.parse(
        '$backendUrl/public/restaurant/near-by?page=$pageA&size=$sizeA&latitude=$lat&longitude=$lon');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['content'];
        return jsonResponse
            .map((data) => NearbyRestaurantsList.fromJson(data))
            .toList();
      }
    } on TimeoutException {
      throw 'Network is timedout please try again.';
    } on SocketException {
      throw 'Network is unreachable! Please check your internet connection.';
    }
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<List<NearbyRestaurantsList>> loadMoreA() async {
    String lat = userLocationLat!.toStringAsFixed(5);
    String lon = userLocationLon!.toStringAsFixed(5);
    if (hasNextPageA == true &&
        isLoadMoreRunningA == false &&
        scrollControllerA.position.extentAfter < 300) {
      isLoadMoreRunningA = true;
      notifyListeners();
      pageA += 1;
      final url = Uri.parse(
          '$backendUrl/public/restaurant/near-by?page=$pageA&size=$sizeA&latitude=$lat&longitude=$lon');
      try {
        final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
        ).timeout(Duration(seconds: timeout));
        if (response.statusCode == 200) {
          final List fetchedPosts = json.decode(response.body)['content'];
          List<NearbyRestaurantsList> po = fetchedPosts
              .map((data) => NearbyRestaurantsList.fromJson(data))
              .toList();
          if (fetchedPosts.isNotEmpty) {
            nearbyRestaurantList!.then((value) => value.addAll(po));
            notifyListeners();
          } else {
            hasNextPageA = false;
            notifyListeners();
          }
        }
      } on TimeoutException {
        scaffoldMessage(
            cntxt, 'Network is timedout! please try again.', Colors.red);
      } on SocketException {
        scaffoldMessage(
            cntxt,
            'Network is unreachable! Please check your internet connection.',
            Colors.red);
      } on Error {
        scaffoldMessage(cntxt, 'Error Occured!', Colors.red);
      }
      isLoadMoreRunningA = false;
      notifyListeners();
    }
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<Restaurant> fetchRestaurantDetail(id, context) async {
    final url = Uri.parse('$backendUrl/public/restaurant/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: timeout));
      if (response.statusCode == 200) {
        return Restaurant.fromJson(jsonDecode(response.body));
      }
    } on TimeoutException {
      scaffoldMessage(
          context, 'Network is timedout! please try again.', Colors.red);
      throw 'Network is timedout please try again.';
    } on SocketException {
      scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          Colors.red);
      throw 'Network is unreachable! Please check your internet connection.';
    }
    scaffoldMessage(context, 'Error Occured!', Colors.red);
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<List<FavoriteRestaurantsList>> fetchFavoriteRestaurantList(
      context, bool showError) async {
    checkLogin();
    final url = Uri.parse('$backendUrl/restaurant/user-favorites');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      ).timeout(Duration(seconds: timeout));
      if (response.statusCode == 200) {
        //
        List jsonResponse = json.decode(response.body);
        print("favorite restaurants $jsonResponse");
        print(jsonResponse[0]['id']);
        lisOfFavRestaurantId = jsonResponse.map((data) => data['id']).toList();
        return jsonResponse.map((data) {
          return FavoriteRestaurantsList.fromJson(data);
        }).toList();
      }
    } on TimeoutException {
      if (showError) {
        scaffoldMessage(
            context, 'Network is timedout! please try again.', Colors.red);
      }
      throw 'Network is timedout please try again.';
    } on SocketException {
      if (showError) {
        scaffoldMessage(
            context,
            'Network is unreachable! Please check your internet connection.',
            Colors.red);
      }
      throw 'Network is unreachable! Please check your internet connection.';
    }
    if (showError) {
      scaffoldMessage(context, 'Error Occured!', Colors.red);
    }
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<List<FavoriteFoodModel>> fetchFavoriteFoodList(
      context, bool showError) async {
    checkLogin();
    final url = Uri.parse('$backendUrl/food/user-favorites');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      if (response.statusCode == 200) {
        //
        List jsonResponse = json.decode(response.body);
        print("favorite food $jsonResponse");
        print(jsonResponse[0]['id']);
        lisOfFavFoodId = jsonResponse.map((data) => data['id']).toList();
        return jsonResponse.map((data) {
          return FavoriteFoodModel.fromJson(data);
        }).toList();
      }
    } on TimeoutException {
      if (showError) {
        scaffoldMessage(
            context, 'Network is timedout! please try again.', Colors.red);
      }
      throw 'Network is timedout please try again.';
    } on SocketException {
      if (showError) {
        scaffoldMessage(
            context,
            'Network is unreachable! Please check your internet connection.',
            Colors.red);
      }
      throw 'Network is unreachable! Please check your internet connection.';
    }
    if (showError) {
      scaffoldMessage(context, 'Error Occured!', Colors.red);
    }
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<List<UsersRegisteredRestaurants>> userRegisteredRestaurants(
    context,
  ) async {
    checkLogin();
    final url = Uri.parse('$backendUrl/restaurant/all-users?page=0&size=8');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      if (response.statusCode == 200) {
        //
        List jsonResponse = json.decode(response.body)['content'];
        return jsonResponse.map((data) {
          return UsersRegisteredRestaurants.fromJson(data);
        }).toList();
      }
    } on TimeoutException {
      scaffoldMessage(
          context, 'Network is timedout! please try again.', Colors.red);
      throw 'Network is timedout please try again.';
    } on SocketException {
      scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          Colors.red);

      throw 'Network is unreachable! Please check your internet connection.';
    }
    scaffoldMessage(context, 'Error Occured!', Colors.red);

    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<void> deleteRestaurantHandler(id, name, context) async {
    checkLogin();
    final url = Uri.parse('$backendUrl/restaurant/$id');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => BottomNav2()));
        scaffoldMessage(context, '$name successfully Deleted!', Colors.green);
      }
    } on TimeoutException {
      throw 'Network is timedout please try again.';
    } on SocketException {
      throw 'Network is unreachable! Please check your internet connection.';
    }

    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<List<GetAllMenuModel>> fetchMenuList(context, id) async {
    final url = Uri.parse('$backendUrl/public/menu/all/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => GetAllMenuModel.fromJson(data))
            .toList();
      }
    } on TimeoutException {
      throw 'Network is timedout please try again.';
    } on SocketException {
      throw 'Network is unreachable! Please check your internet connection.';
    }
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<List<GetMenuFoods>> fetchMenuFoodsList(id, context) async {
    final url = Uri.parse('$backendUrl/public/menu/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['foods'];
        return jsonResponse.map((data) => GetMenuFoods.fromJson(data)).toList();
      }
    } on TimeoutException {
      throw 'Network is timedout please try again.';
    } on SocketException {
      throw 'Network is unreachable! Please check your internet connection.';
    }
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<List<RestaurantAllFoodModel>> fetchRestaurntFoodsList(
      id, context) async {
    final url = Uri.parse(
        '$backendUrl/public/food/all/restaurant-food-list/$id?page=0&size=20');
    try {
      final response = await http.get(
        url,
        headers: {},
      );
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['content'];
        return jsonResponse
            .map((data) => RestaurantAllFoodModel.fromJson(data))
            .toList();
      }
    } on TimeoutException {
      throw 'Network is timedout please try again.';
    } on SocketException {
      throw 'Network is unreachable! Please check your internet connection.';
    }
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<void> deleteFoodHandler(id, context, VoidCallback onRefresh) async {
    checkLogin();
    final url = Uri.parse('$backendUrl/food/$id');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Food Successfully deleted!'),
          backgroundColor: Colors.green,
        ));
        onRefresh();
      }
    } on TimeoutException {
      throw 'Network is timedout please try again.';
    } on SocketException {
      throw 'Network is unreachable! Please check your internet connection.';
    }

    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<void> deleteMenuHandler(id, context, VoidCallback onRefresh) async {
    checkLogin();
    final url = Uri.parse('$backendUrl/menu/$id');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Menu Successfully deleted!'),
          backgroundColor: Colors.green,
        ));
        onRefresh();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Error Occured!'),
          backgroundColor: Colors.red,
        ));
      }
    } on TimeoutException {
      throw 'Network is timedout please try again.';
    } on SocketException {
      throw 'Network is unreachable! Please check your internet connection.';
    }
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<UserInfoModel> fetchUserDetail(context) async {
    checkLogin();
    final url = Uri.parse('$backendUrl/user');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      if (response.statusCode == 200) {
        return UserInfoModel.fromJson(jsonDecode(response.body));
      }
    } on TimeoutException {
      scaffoldMessage(
          context, 'Network is timedout! please try again.', Colors.red);
      throw 'Network is timedout please try again.';
    } on SocketException {
      scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          Colors.red);
      throw 'Network is unreachable! Please check your internet connection.';
    }
    scaffoldMessage(context, 'Error Occured!', Colors.red);
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<void> addFavoriteRestaurant(context, id) async {
    final url = Uri.parse('$backendUrl/restaurant/add-favorites/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      if (response.statusCode == 200) {
        scaffoldMessage(
            context, 'Restaurant added to favorites list!', Colors.green);
      }
    } on TimeoutException {
      scaffoldMessage(
          context, 'Network is timedout please try again.', AppColors.red);
      throw 'Network is timedout please try again.';
    } on SocketException {
      scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          AppColors.red);
      throw 'Network is unreachable! Please check your internet connection.';
    }
    // scaffoldMessage(
    //     context, 'Unexpected Error Occured! Please try again.', AppColors.red);
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<void> deleteFavoriteRestaurant(
      context, id, bool? infoOnTop, VoidCallback? onPressed) async {
    final url = Uri.parse('$backendUrl/restaurant/delete-favorites/$id');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      if (response.statusCode == 200) {
        scaffoldMessage(
            context, 'Restaurant removed from favorites list!.', Colors.green);
        onPressed!();
      }
    } on TimeoutException {
      scaffoldMessage(
          context, 'Network is timedout please try again.', AppColors.red);
      throw 'Network is timedout please try again.';
    } on SocketException {
      scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          AppColors.red);
      throw 'Network is unreachable! Please check your internet connection.';
    }
    // scaffoldMessage(
    //     context, 'Unexpected Error Occured! Please try again.', AppColors.red);
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<void> addFavoriteFood(context, id) async {
    final url = Uri.parse('$backendUrl/food/add-favorites/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      if (response.statusCode == 200) {
        scaffoldMessage(context, 'Food added to favorites list!', Colors.green);
      }
    } on TimeoutException {
      scaffoldMessage(
          context, 'Network is timedout please try again.', AppColors.red);
      throw 'Network is timedout please try again.';
    } on SocketException {
      scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          AppColors.red);
      throw 'Network is unreachable! Please check your internet connection.';
    }
    // scaffoldMessage(
    //     context, 'Unexpected Error Occured! Please try again.', AppColors.red);
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<void> deleteFavoriteFood(context, id, VoidCallback? onPressed) async {
    final url = Uri.parse('$backendUrl/food/delete-favorites/$id');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      if (response.statusCode == 200) {
        scaffoldMessage(
            context, 'Food removed from favorites list!', Colors.green);
        onPressed!();
      }
    } on TimeoutException {
      scaffoldMessage(
          context, 'Network is timedout please try again.', AppColors.red);
      throw 'Network is timedout please try again.';
    } on SocketException {
      scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          AppColors.red);
      throw 'Network is unreachable! Please check your internet connection.';
    }
    // scaffoldMessage(
    //     context, 'Unexpected Error Occured! Please try again.', AppColors.red);
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<void> fetchRestaurantRating(
      context, restaurantId, rate, VoidCallback? refresh) async {
    double num1 = rate;
    String rating = num1.toInt().toString();

    final url =
        Uri.parse('$backendUrl/restaurant/rate/$restaurantId?rate=$rating');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      if (response.statusCode == 200) {
        refresh!();
      } else if (response.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Please Login to rate this restaurant!!'),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Error Occured!'),
          backgroundColor: Colors.red,
        ));
      }
    } on TimeoutException {
      throw 'Network is timedout please try again.';
    } on SocketException {
      throw 'Network is unreachable! Please check your internet connection.';
    }
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<List<UserReviewModel>> fetchRestaurantReviews(
      context, restaurantId) async {
    https: //esoora-backend-prod-qiymu.ondigitalocean.app/restaurant/feedback/1
    final url = Uri.parse('$backendUrl/restaurant/feedback/$restaurantId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => UserReviewModel.fromJson(data))
            .toList();
      }
    } on TimeoutException {
      throw 'Network is timedout please try again.';
    } on SocketException {
      throw 'Network is unreachable! Please check your internet connection.';
    }
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future postFeedback(context, restaurantId, String feedback) async {
    DateTime currentTime = DateTime.now();
    final url = Uri.parse('$backendUrl/restaurant/give-feedback/$restaurantId');
    try {
      final jsonBody = json.encode(UserReviewPostModel(
        feedback: feedback,
        firstName: '',
        lastName: '',
        feedbackDate: currentTime,
        feedbackType: 'USER_FEEDBACK',
      ));
      final response = await http.post(
        url,
        body: jsonBody,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      if (response.statusCode == 200) {
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Error Occured!'),
          backgroundColor: Colors.red,
        ));
      }
    } on TimeoutException {
      throw 'Network is timedout please try again.';
    } on SocketException {
      throw 'Network is unreachable! Please check your internet connection.';
    }
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future<List<SearchedRestaurant>> fetchSearchedRestaurants(
      context, String keyword) async {
    checkLogin();
    final url = Uri.parse(
        '$backendUrl/public/search/serving-restaurant?keyword=$keyword&page=0&size=2');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['content'];
        return jsonResponse
            .map((data) => SearchedRestaurant.fromJson(data))
            .toList();
      } else {
        scaffoldMessage(context, 'Unexpected Error Occured! Please try again.',
            AppColors.red);
      }
    } on TimeoutException {
      scaffoldMessage(
          context, 'Network is timedout please try again.', AppColors.red);
      throw 'Network is timedout please try again.';
    } on SocketException {
      scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          AppColors.red);
      throw 'Network is unreachable! Please check your internet connection.';
    }
    notifyListeners();
    scaffoldMessage(
        context, 'Unexpected Error Occured! Please try again.', AppColors.red);
    throw 'Unexpected Error Occured! Please try again.';
  }

  Future fetchSearchedFoods(
    context,
    keyword,
  ) async {
    final url = Uri.parse(
        '$backendUrl/search/serving-foods?keyword=$keyword&page=0&size=1');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        scaffoldMessage(context, 'test is done', Colors.amber);
        List jsonResponse = json.decode(response.body)['content'];
        return jsonResponse
            .map((data) => SearchedRestaurant.fromJson(data))
            .toList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Error Occured!'),
          backgroundColor: Colors.red,
        ));
      }
    } on TimeoutException {
      throw 'Network is timedout please try again.';
    } on SocketException {
      throw 'Network is unreachable! Please check your internet connection.';
    }
  }

  Future<void> changeUserPassword(
      context, String userName, String password) async {
    final url = Uri.parse('$backendUrl/user/updatePassword');
    try {
      final jsonBody =
          json.encode({"userName": userName, "password": password});
      final response = await http.post(
        url,
        body: jsonBody,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ' Bearer $token',
          'pid': '$pid',
        },
      );
      if (response.statusCode == 200) {
        scaffoldMessage(
            context, 'Password changed successfully!', Colors.green);
        Provider.of<Auth>(context, listen: false).logOut(context);
        Provider.of<Auth>(context, listen: false).loginEnforceDialogue(
            context, 'Password Changed Successfully!', false);
      } else {
        throw scaffoldMessage(
            context, 'Unexpected Error Occured! Please try again.', Colors.red);
      }
    } on TimeoutException {
      throw scaffoldMessage(
          context, 'Network is timedout please try again.', Colors.red);
    } on SocketException {
      throw scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          Colors.red);
    }
  }

  scaffoldMessage(context, String message, Color bkgrdClr) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 1300),
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      backgroundColor: bkgrdClr,
    ));
  }

  Future<void> callNow(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void loginRequestDialogue(context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.TOPSLIDE,
      headerAnimationLoop: false,
      dialogType: DialogType.INFO,
      showCloseIcon: true,
      title: 'Add to favorites?',
      desc: 'You need to login to add favorites!',
      btnOkOnPress: () {
        // Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen()));
      },
      btnOkColor: AppColors.primary,
      btnOkIcon: Icons.login,
      btnOkText: 'Login',
      // btnCancelOnPress: () {},
      // btnCancelIcon: Icons.cancel,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  void showSuccessDialog(context, title) async {
    final deviceWidth = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
                height: deviceWidth > 380
                    ? MediaQuery.of(context).size.height * 0.45
                    : MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.75,
                child: PostRegistrationDialogue(
                  title: title,
                )),
          );
        });
  }

  void aboutDialogue(BuildContext context) {
    showAboutDialog(
        useRootNavigator: false,
        applicationLegalese:
            'Esoora Food Delivery app is developed by EthioClicks® PLC all rights reserved 2022.',
        // 'This version is for testing purpose only! \nEC Food Delivery app is developed by EthioClicks® Technologies all rights reserved 2022.',
        context: context,
        applicationName: 'Esoora Food Delivery',
        applicationIcon: const CircleAvatar(
          backgroundColor: AppColors.transparent,
          backgroundImage: AssetImage('assets/esoora_logo.png'),
        ),
        applicationVersion: 'Version 0.0.0+1');
  }

  void willPopDialogue(context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    AwesomeDialog(
      context: context,
      animType: AnimType.TOPSLIDE,
      headerAnimationLoop: false,
      dialogType: DialogType.INFO,
      showCloseIcon: true,
      title: 'Are you sure you want to leave?',
      desc: 'Any change will be discarded!',
      buttonsTextStyle: TextStyle(
          fontSize: deviceWidth > 380 ? 14 : 12, color: AppColors.white),
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
      btnCancelColor: AppColors.secondary,
      btnOkColor: AppColors.primary,
      btnOkIcon: Icons.check,
      btnOkText: 'Confirm',
      btnCancelOnPress: () {},
      btnCancelIcon: Icons.cancel,
      btnCancelText: 'Cancel',
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  void contactDialogue(context) async {
    final deviceWidth = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              height: deviceWidth > 380
                  ? MediaQuery.of(context).size.height * 0.35
                  : MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.transparent,
                          backgroundImage: AssetImage('assets/esoora_logo.png'),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.transparent,
                          backgroundImage:
                              AssetImage('assets/ethioclickslogo.png'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const TitleFont(
                      text: 'EthioClicks PLC',
                      size: 18,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const DescriptionFont(text: 'Phone: '),
                        TextButton(
                            onPressed: () {
                              callNow('+251977011111');
                            },
                            child: const DescriptionFont(text: '+251977011111')),
                        SizedBox(
                          width: deviceWidth > 380 ? deviceWidth * 0.15 : 5,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const DescriptionFont(text: 'Email: '),
                        TextButton(
                            onPressed: () {
                              launch(
                                  'mailto:ethioclick2020@gmail.com?subject=Esoora Food Delivery App Title&body=Esoora');
                            },
                            child: const DescriptionFont(
                                text: 'ethioclicks2020@gmail.com'))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const DescriptionFont(text: 'Address: '),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: const DescriptionFont(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            text: 'Piassa, Sekka Tower 11th floor, Addis Ababa',
                            color: AppColors.secondary,
                          ),
                        )
                      ],
                    ),
                  ],
                )),
              ),
            ),
          );
        });
  }
}
