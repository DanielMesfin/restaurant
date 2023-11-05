import 'dart:async';

import 'package:urban_restaurant/models/get_nearby_restaurants.dart';
import 'package:urban_restaurant/screens/login.dart';
import 'package:urban_restaurant/screens/restaurant_detail.dart';
import 'package:urban_restaurant/screens/search_dialogue.dart';
import 'package:urban_restaurant/style/colors.dart';
import 'package:urban_restaurant/style/style.dart';
import 'package:urban_restaurant/widgets/shimmer_loading.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/get_featured_restaurant.dart';
import '../providers/fetch_and_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/error_messages.dart';
import '../widgets/rating_bar.dart';

class Home extends StatefulWidget {
  // static List<Person> people = [
  //   Person('Mike', 'Barron', 64),
  //   Person('Todd', 'Black', 30),
  //   Person('Ahmad', 'Edwards', 55),
  //   Person('Anthony', 'Johnson', 67),
  //   Person('Annette', 'Brooks', 39),
  // ];
  const Home({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() {
    Provider.of<Fetch>(context, listen: false).getCurrentLocation();
    Provider.of<Fetch>(context, listen: false).featuredRestaurantList =
        Provider.of<Fetch>(context, listen: false)
            .fetchFeaturedRestaurants(context);
    Provider.of<Fetch>(context, listen: false).scrollController =
        ScrollController()
          ..addListener(Provider.of<Fetch>(context, listen: false).loadMore);
    Provider.of<Fetch>(context, listen: false).nearbyRestaurantList =
        Provider.of<Fetch>(context, listen: false)
            .fetchNearbyRestaurants(context);
    Provider.of<Fetch>(context, listen: false).scrollControllerA =
        ScrollController()
          ..addListener(Provider.of<Fetch>(context, listen: false).loadMoreA);
  }

  FutureOr onGoBack(dynamic value) {
    onRefresh();
  }

  onRefresh() {
    Provider.of<Fetch>(context, listen: false).page = 0;
    Provider.of<Fetch>(context, listen: false).pageA = 0;
    Provider.of<Fetch>(context, listen: false).size = 6;
    Provider.of<Fetch>(context, listen: false).sizeA = 6;
    Provider.of<Fetch>(context, listen: false).hasNextPage = true;
    Provider.of<Fetch>(context, listen: false).hasNextPageA = true;
    Provider.of<Fetch>(context, listen: false).isLoadMoreRunning = false;
    Provider.of<Fetch>(context, listen: false).isLoadMoreRunningA = false;
    Provider.of<Fetch>(context, listen: false).getCurrentLocation();
    fetch();
    setState(() {});
  }

  Widget buildNearbyCard(ctx, index, List<NearbyRestaurantsList> data) {
    final deviceSize = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: GestureDetector(
        onTap: () {
          Route route = MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(
                    restaurantId: data[index].id,
                    restaurantName: data[index].name,
                    restaurantPhone: data[index].phoneNumber,
                    ownerPid: data[index].owner.userPublicId,
                  ));
          Navigator.push(context, route).then(onGoBack);
        },
        child: Card(
            elevation: 5,
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                TitleFont(
                  text: data[index].name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  size: deviceSize > 380 ? 20 : 17,
                ),
                const SizedBox(
                  height: 3,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            data[index].restaurantImageEntities[0].url),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(width: 1, color: Colors.grey)),
                  height: MediaQuery.of(context).size.height * 0.14,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Container(
                      // margin: EdgeInsets.only(left: 5, right: 5),
                      margin: const EdgeInsets.only(left: 7, right: 7),
                      alignment: Alignment.topLeft,
                      child: DescriptionFont(
                        text: data[index].description,
                        color: AppColors.grey,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        size: deviceSize > 380 ? 13 : 11,
                      )),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(left: 7, right: 7),
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const Info2Font(
                        text: 'Rating',
                        size: 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      RatingBarWidget(rate: data[index].rate),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget featuredCard(data, index) {
    final deviceSize = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () {
          Route route = MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(
                    restaurantId: data[index].id,
                    restaurantName: data[index].name,
                    restaurantPhone: data[index].phoneNumber,
                    ownerPid: data[index].owner.userPublicId,
                  ));
          Navigator.push(context, route).then(onGoBack);
        },
        child: Card(
          // color: const Color.fromARGB(255, 182, 238, 201),
          margin: const EdgeInsets.only(right: 10, left: 10),
          elevation: 8.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.3,
                  child: Image(
                    image: NetworkImage(
                      data[index].restaurantImageEntities[0].url,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.008,
                ),
                SizedBox(
                    // alignment: Alignment.topLeft,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TitleFont(
                      text: data[index].name,
                      maxLines: 1,
                      // textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      size: deviceSize > 380 ? 18 : 16,
                      color: AppColors.black,
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                Container(
                    // height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.4,
                    margin: const EdgeInsets.only(left: 7, right: 7),
                    alignment: Alignment.topLeft,
                    child: DescriptionFont(
                      text: data[index].description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      size: deviceSize > 380 ? 13 : 11,
                      color: AppColors.grey,
                    )),
              ],
            ),
          ),
        ));
  }

  _displaySearchDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.9),
      transitionDuration: const Duration(milliseconds: 500),
      // transitionBuilder: (context, animation, secondaryAnimation, child) {
      //   return FadeTransition(
      //     opacity: animation,
      //     child: ScaleTransition(
      //       scale: animation,
      //       child: child,
      //     ),
      //   );
      // },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white.withOpacity(0.9),
            padding: const EdgeInsets.all(8),
            // color: Colors.white,
            child: const SearchDialogue());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size.width;
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            Provider.of<Fetch>(context, listen: false).getCurrentLocation();
            SharedPreferences pref = await SharedPreferences.getInstance();
            String? savedLocationLat = pref.getString('savedLocationLat');
            String? savedLocationLon = pref.getString('savedLocationLon');
            Provider.of<Fetch>(context, listen: false).token != null &&
                    Provider.of<Fetch>(context, listen: false).pid != null
                ? Navigator.of(context).push(
                    MaterialPageRoute(
                      //TODO this is updated
                      builder: (BuildContext context) =>Container()
                      //     RestaurantRegistatrationPage(
                      //   latitude: savedLocationLat,
                      //   longitude: savedLocationLon,
                      // ),
                    ),
                  )
                : Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen(
                          restaurantRegister: true,
                        )));
          },
          icon: SvgPicture.asset('assets/add.svg'),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _displaySearchDialog(context);
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          Provider.of<Fetch>(context, listen: false)
              .featuredRestaurantList!
              .then((value) => value.clear());
          Provider.of<Fetch>(context, listen: false)
              .nearbyRestaurantList!
              .then((value) => value.clear());
          onRefresh();
        },
        color: Colors.white,
        backgroundColor: const Color.fromARGB(255, 176, 101, 39),
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: ListView(
          controller:
              Provider.of<Fetch>(context, listen: false).scrollControllerA,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Poppins(
                text: 'Esoora',
                size: 22,
                color: AppColors.primary,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: PrimaryText(
                text: 'Food Delivery',
                height: 1.1,
                size: 35,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Info4Font(
                  text: 'Featured Restaurants',
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  size: 22),
            ),
            FutureBuilder<List<FeaturedRestaurantsList>>(
                future: Provider.of<Fetch>(context, listen: false)
                    .featuredRestaurantList,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    final error = snapshot.error;
                    String unreachableMsg =
                            'Network is unreachable! Please check your internet connection.',
                        timedOutMsg = 'Network is timedout please try again.',
                        ueMsg = 'Unexpected Error Occured! Please try again.';
                    if ('$error' == unreachableMsg) {
                      return ErrorMessages(
                        onRefresh: onRefresh,
                        msg: unreachableMsg,
                      );
                    } else if ('$error' == timedOutMsg) {
                      return ErrorMessages(
                        onRefresh: onRefresh,
                        msg: timedOutMsg,
                      );
                    } else if ('$error' == ueMsg) {
                      return Center(
                          child: ErrorMessages(
                        onRefresh: onRefresh,
                        msg: ueMsg,
                      ));
                    }
                  }
                  if (snapshot.hasData) {
                    List<FeaturedRestaurantsList>? data = snapshot.data;
                    return Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: deviceSize > 380
                                ? MediaQuery.of(context).size.height * 0.31
                                : MediaQuery.of(context).size.height * 0.33,
                            child: ListView.builder(
                              controller:
                                  Provider.of<Fetch>(context, listen: false)
                                      .scrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: data!.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8),
                                child: featuredCard(data, index),
                              ),
                            ),
                          ),
                        ),
                        if (Provider.of<Fetch>(context, listen: true)
                                .isLoadMoreRunning ==
                            true)
                          const Expanded(
                            flex: 1,
                            child: Center(
                              child: MoreLoadingGif(
                                type: MoreLoadingGifType.ellipsis,
                                size: 50,
                              ),
                            ),
                          ),
                        //          if (_hasNextPageA == false)
                        //  Expanded(flex: 1,
                        //    child:  Container(
                        //       padding: const EdgeInsets.only(top: 15, bottom: 20),
                        //       color: Colors.amber,
                        //       child: const Center(
                        //         child: Text('You have fetched all of the restaurants'),
                        //       ),
                        //     ),
                        //  ),
                      ],
                    );
                  }
                  return const ShimmerLoading(
                    home: true,
                    foodCard: false,
                    detail: false,
                    homeA: false,
                  );
                }),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Info4Font(
                  text: 'Nearby Restaurants',
                  fontWeight: FontWeight.w700,
                  size: 22),
            ),
            FutureBuilder<List<NearbyRestaurantsList>>(
                future: Provider.of<Fetch>(context, listen: false)
                    .nearbyRestaurantList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<NearbyRestaurantsList>? data = snapshot.data;
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        // controller: Provider.of<Fetch>(context, listen: false)
                        //     .scrollControllerA,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            // maxCrossAxisExtent: 200,
                            childAspectRatio: 2 / 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 20,
                            mainAxisExtent: deviceSize > 380 ? 240 : 200,
                            crossAxisCount: 2),
                        itemCount: data!.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return buildNearbyCard(ctx, index, data);
                        });
                  }
                  return const ShimmerLoading(
                    home: false,
                    foodCard: false,
                    detail: false,
                    homeA: true,
                    search: false,
                    favorite: false,
                    profile: false,
                  );
                }),
            if (Provider.of<Fetch>(context, listen: true).isLoadMoreRunningA ==
                true)
              const Center(
                child: MoreLoadingGif(
                  type: MoreLoadingGifType.ripple,
                  size: 50,
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            if (Provider.of<Fetch>(context, listen: false).hasNextPageA ==
                false)
              Container(
                padding: const EdgeInsets.only(top: 15, bottom: 20),
                color: AppColors.secondary,
                child: const Center(
                  child: Text('End of this list!'),
                ),
              ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  // Widget popularFoodCard(
  //     String? imagePath, String? name, String? weight, String? star) {
  //   return GestureDetector(
  //     onTap: () => {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => FoodDetail(imagePath!, name!, )))
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.only(right: 25, left: 20, top: 25),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20),
  //         boxShadow: const [
  //           BoxShadow(blurRadius: 10, color: AppColors.lighterGray)
  //         ],
  //         color: AppColors.white,
  //       ),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 25, left: 20),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       children: const [
  //                         Icon(
  //                           Icons.star,
  //                           color: AppColors.primary,
  //                           size: 20,
  //                         ),
  //                         SizedBox(width: 10),
  //                         PrimaryText(
  //                           text: 'top of the week',
  //                           size: 16,
  //                         )
  //                       ],
  //                     ),
  //                     const SizedBox(height: 15),
  //                     SizedBox(
  //                       width: MediaQuery.of(context).size.width / 2.2,
  //                       child: PrimaryText(
  //                           text: name!, size: 22, fontWeight: FontWeight.w700),
  //                     ),
  //                     PrimaryText(
  //                         text: weight!, size: 18, color: AppColors.lightGray),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               Row(
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(
  //                         horizontal: 45, vertical: 20),
  //                     decoration: const BoxDecoration(
  //                         color: AppColors.primary,
  //                         borderRadius: BorderRadius.only(
  //                           bottomLeft: Radius.circular(20),
  //                           topRight: Radius.circular(20),
  //                         )),
  //                     child: const Icon(Icons.add, size: 20),
  //                   ),
  //                   const SizedBox(width: 20),
  //                   SizedBox(
  //                     child: Row(
  //                       children: [
  //                         const Icon(Icons.star, size: 12),
  //                         const SizedBox(width: 5),
  //                         PrimaryText(
  //                           text: star!,
  //                           size: 18,
  //                           fontWeight: FontWeight.w600,
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           Container(
  //             transform: Matrix4.translationValues(30.0, 25.0, 0.0),
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(50),
  //                 boxShadow: const [
  //                   BoxShadow(color: Colors.grey, blurRadius: 20)
  //                 ]),
  //             child: Hero(
  //               tag: imagePath!,
  //               child: Image.asset(imagePath,
  //                   width: MediaQuery.of(context).size.width / 2.9),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
