import 'dart:async';

import 'package:urban_restaurant/models/favorite_food_model.dart';
import 'package:urban_restaurant/screens/login.dart';
import 'package:urban_restaurant/screens/restaurant_detail.dart';
import 'package:urban_restaurant/widgets/error_messages.dart';
import 'package:urban_restaurant/screens/food_detail.dart';
import 'package:urban_restaurant/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/get_favorite_restaurants_list.dart';
import '../providers/fetch_and_post.dart';
import '../style/colors.dart';
import '../style/style.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Future<List<FavoriteRestaurantsList>>? favoriteRestaurantList;
  Future<List<FavoriteFoodModel>>? favoriteFoodList;

  @override
  void initState() {
    super.initState();
    // futureData = fetchData();
    checkLogin();
  }

  void checkLogin() {
    Provider.of<Fetch>(context, listen: false).checkLogin();
    if (Provider.of<Fetch>(context, listen: false).token != null &&
        Provider.of<Fetch>(context, listen: false).pid != null) {
      Provider.of<Fetch>(context, listen: false).lisOfFavRestaurantId.clear();
      Provider.of<Fetch>(context, listen: false).lisOfFavFoodId.clear();
      favoriteRestaurantList = Provider.of<Fetch>(context, listen: false)
          .fetchFavoriteRestaurantList(context, true);
      favoriteFoodList = Provider.of<Fetch>(context, listen: false)
          .fetchFavoriteFoodList(context, false);
    }
  }

  FutureOr onGoBack(dynamic value) {
    onRefresh();
  }

  onRefresh() {
    checkLogin();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Provider.of<Fetch>(context, listen: false).token != null &&
                Provider.of<Fetch>(context, listen: false).pid != null
            ? Scaffold(
                body: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 25, bottom: 8),
                    child: Column(
                      children: [
                        const PrimaryText(
                          text: 'Your Favorites',
                          size: 22,
                        ),
                        TabBar(
                          onTap: (index) {
                            setState(() {});
                          },
                          labelColor: Colors.black,
                          indicatorColor: AppColors.primary,
                          labelPadding: const EdgeInsets.all(0),
                          unselectedLabelStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300),
                          labelStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                          tabs: const [
                            Tab(
                              text: 'Restaurant',
                            ),
                            Tab(
                              text: 'Food',
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                              // physics: NeverScrollableScrollPhysics(),
                              children: [
                                SingleChildScrollView(
                                    child: FutureBuilder<
                                            List<FavoriteRestaurantsList>>(
                                        future: favoriteRestaurantList,
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return const ShimmerLoading(
                                                detail: false,
                                                home: false,
                                                homeA: false,
                                                foodCard: false,
                                                search: false,
                                                favorite: true,
                                              );
                                            case ConnectionState.done:
                                            default:
                                              if (snapshot.hasError) {
                                                final error = snapshot.error;
                                                String unreachableMsg =
                                                        'Network is unreachable! Please check your internet connection.',
                                                    timedOutMsg =
                                                        'Network is timedout please try again.',
                                                    ueMsg =
                                                        'Unexpected Error Occured! Please try again.';
                                                if ('$error' ==
                                                    unreachableMsg) {
                                                  return Center(
                                                    child: ErrorMessages(
                                                      onRefresh: onRefresh,
                                                      msg: unreachableMsg,
                                                    ),
                                                  );
                                                } else if ('$error' ==
                                                    timedOutMsg) {
                                                  return ErrorMessages(
                                                    onRefresh: onRefresh,
                                                    msg: timedOutMsg,
                                                  );
                                                } else if ('$error' == ueMsg) {
                                                  return ErrorMessages(
                                                    onRefresh: onRefresh,
                                                    msg: ueMsg,
                                                  );
                                                }
                                              }
                                              if (snapshot.hasData) {
                                                List<FavoriteRestaurantsList>?
                                                    data = snapshot.data;
                                                return ListView.builder(
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder: (ctx, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Route route =
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        RestaurantDetailScreen(
                                                                          restaurantId:
                                                                              data[index].id,
                                                                          restaurantName:
                                                                              data[index].name,
                                                                          restaurantPhone:
                                                                              data[index].phoneNumber,
                                                                        ));
                                                        Navigator.push(
                                                                context, route)
                                                            .then(onGoBack);
                                                      },
                                                      child: ListTile(
                                                        leading: CircleAvatar(
                                                            radius: 25,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            backgroundImage:
                                                                NetworkImage(data[
                                                                        index]
                                                                    .restaurantImageEntities[
                                                                        0]
                                                                    .url)),
                                                        title: TitleFont(
                                                          text:
                                                              data[index].name,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        subtitle:
                                                            DescriptionFont(
                                                          text: data[index]
                                                              .description,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        trailing: IconButton(
                                                            onPressed: () {
                                                              Provider.of<Fetch>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .deleteFavoriteRestaurant(
                                                                      context,
                                                                      data[index]
                                                                          .id,
                                                                      true,
                                                                      onRefresh);
                                                            },
                                                            icon: const Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                            )),
                                                      ),
                                                    );
                                                  },
                                                  itemCount: data!.length,
                                                );
                                              } else {
                                                return const SizedBox(
                                                  height: 400,
                                                  child: Center(
                                                      child: Info2Font(
                                                          text:
                                                              'No favorite restaurant added!')),
                                                );
                                              }
                                          }
                                        })),
                                SingleChildScrollView(
                                  child: FutureBuilder<List<FavoriteFoodModel>>(
                                    future: favoriteFoodList,
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState
                                            .waiting: //need to be removed to prevent loading everytime
                                          return const ShimmerLoading(
                                            detail: false,
                                            home: false,
                                            homeA: false,
                                            foodCard: false,
                                            search: false,
                                            favorite: true,
                                          );
                                        case ConnectionState.done:
                                        default:
                                          if (snapshot.hasError) {
                                            final error = snapshot.error;
                                            String unreachableMsg =
                                                    'Network is unreachable! Please check your internet connection.',
                                                timedOutMsg =
                                                    'Network is timedout please try again.',
                                                ueMsg =
                                                    'Unexpected Error Occured! Please try again.';
                                            if ('$error' == unreachableMsg) {
                                              return Center(
                                                child: ErrorMessages(
                                                  onRefresh: onRefresh,
                                                  msg: unreachableMsg,
                                                ),
                                              );
                                            } else if ('$error' ==
                                                timedOutMsg) {
                                              return ErrorMessages(
                                                onRefresh: onRefresh,
                                                msg: timedOutMsg,
                                              );
                                            } else if ('$error' == ueMsg) {
                                              return ErrorMessages(
                                                onRefresh: onRefresh,
                                                msg: ueMsg,
                                              );
                                            }
                                          }
                                          if (snapshot.hasData) {
                                            List<FavoriteFoodModel>? data =
                                                snapshot.data;
                                            return ListView.builder(
                                              primary: false,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (ctx, index) {
                                                int convertedPrice =
                                                    data[index].price.toInt();
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    FoodDetail(
                                                                      foodImage:
                                                                          data[index]
                                                                              .foodImageEntities,
                                                                      name: data[
                                                                              index]
                                                                          .name,
                                                                      description:
                                                                          data[index]
                                                                              .description,
                                                                      price:
                                                                          convertedPrice,
                                                                      restaurantId:
                                                                          data[index]
                                                                              .restaurantId,
                                                                    )));
                                                  },
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        backgroundImage:
                                                            NetworkImage(data[
                                                                    index]
                                                                .foodImageEntities[
                                                                    0]
                                                                .url)),
                                                    title: TitleFont(
                                                      text: data[index].name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    subtitle: DescriptionFont(
                                                      text: data[index]
                                                          .description,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    trailing: IconButton(
                                                        onPressed: () {
                                                          // context
                                                          //     .watch<Fetch>()
                                                          //     .deleteFavoriteFood(
                                                          //         context,
                                                          //         data[index]
                                                          //             .id);
                                                          Provider.of<Fetch>(
                                                                  context,
                                                                  listen: false)
                                                              .deleteFavoriteFood(
                                                                  context,
                                                                  data[index]
                                                                      .id,
                                                                  onRefresh);
                                                          // onRefresh();
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        )),
                                                  ),
                                                );
                                              },
                                              itemCount: data!.length,
                                            );
                                          } else {
                                            return const SizedBox(
                                              height: 400,
                                              child: Center(
                                                  child: Info2Font(
                                                      text:
                                                          'No favorite food added!')),
                                            );
                                          }
                                      }
                                    },
                                  ),
                                ),
                              ]),
                        )
                      ],
                    )))
            : Scaffold(
                body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Info2Font(
                        text: 'You need to login to view your favorites.'),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(LoginScreen.routeName);
                        },
                        icon: const Icon(
                          Icons.login,
                          color: AppColors.white,
                        ),
                        label: const InfoFont(
                          text: 'Login',
                          color: AppColors.white,
                        )),
                  ],
                ),
              )));
  }
}
