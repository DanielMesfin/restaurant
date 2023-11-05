import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:urban_restaurant/screens/restaurant_detail.dart';
import 'package:urban_restaurant/widgets/error_messages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/get_restaurants.dart';
import '../providers/fetch_and_post.dart';
import 'package:more_loading_gif/more_loading_gif.dart';

import '../style/style.dart';

class RestaurantList extends StatefulWidget {
  const RestaurantList({Key? key}) : super(key: key);
  // static const routeName = '/restaurantList';

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList>
    with AutomaticKeepAliveClientMixin {
  String backendUrl = 'https://esoora-backend-prod-qiymu.ondigitalocean.app';
  int _page = 0;
  int _limit = 7;
  bool _hasNextPage = true;
  // bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  Future<List<RestaurantsList>>? _posts;
  int timeout = 10;
  ScrollController _scrollController = ScrollController();

  final ScrollController scrollController1 = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _posts = fetchRestaurantList();
    _scrollController = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    super.dispose();
  }

  Future<List<RestaurantsList>> fetchRestaurantList() async {
    // setState(() {
    //   _isFirstLoadRunning = true;
    // });
    final url =
        Uri.parse('$backendUrl/public/restaurant/all?page=$_page&size=$_limit');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: timeout));
      if (response.statusCode == 200) {
        // setState(() {
        List jsonResponse = json.decode(response.body)['content'];
        return jsonResponse
            .map((data) => RestaurantsList.fromJson(data))
            .toList();
        // });
      }
    } on TimeoutException {
      Provider.of<Fetch>(context, listen: false).scaffoldMessage(
          context, 'Network is timedout! please try again.', Colors.red);
    } on SocketException {
      Provider.of<Fetch>(context, listen: false).scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          Colors.red);
    } on Error {
      Provider.of<Fetch>(context, listen: false)
          .scaffoldMessage(context, 'Error Occured!', Colors.red);
    }
    throw 'Unexpected Error Occured! Please try again.';
    // setState(() {
    //   _isFirstLoadRunning = false;
    // });
  }

  Future<List<RestaurantsList>> _loadMore() async {
    if (_hasNextPage == true &&
        _isLoadMoreRunning == false &&
        _scrollController.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      final url = Uri.parse(
          '$backendUrl/public/restaurant/all?page=$_page&size=$_limit');
      try {
        final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
        ).timeout(Duration(seconds: timeout));
        print('load more running');
        print(response.statusCode);
        if (response.statusCode == 200) {
          final List fetchedPosts = json.decode(response.body)['content'];
          List<RestaurantsList> po = fetchedPosts
              .map((data) => RestaurantsList.fromJson(data))
              .toList();
          if (fetchedPosts.isNotEmpty) {
            setState(() {
              _posts!.then((value) => value.addAll(po));
            });
          } else {
            setState(() {
              _hasNextPage = false;
            });
          }
        }
      } on TimeoutException {
        Provider.of<Fetch>(context, listen: false).scaffoldMessage(
            context, 'Network is timedout! please try again.', Colors.red);
      } on SocketException {
        Provider.of<Fetch>(context, listen: false).scaffoldMessage(
            context,
            'Network is unreachable! Please check your internet connection.',
            Colors.red);
      } on Error {
        Provider.of<Fetch>(context, listen: false)
            .scaffoldMessage(context, 'Error Occured!', Colors.red);
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
    throw 'Unexpected Error Occured! Please try again.';
  }

  FutureOr onGoBack(dynamic value) {
    onRefresh();
  }

  onRefresh() {
    _page = 0;
    _limit = 6;
    _hasNextPage = true;
    // _isFirstLoadRunning = false;
    _isLoadMoreRunning = false;
    _posts = fetchRestaurantList();
    // _scrollController = ScrollController()..addListener(_loadMore);
    setState(() {});
  }

  Widget _buildRatingBar(double rate) {
    var stars = <Widget>[];

    for (var i = 1; i <= 5; i++) {
      Color color;
      if (i <= rate) {
        color = const Color.fromARGB(255, 6, 190, 0);
      } else {
        color = Colors.black12;
      }
      var star = Icon(
        Icons.star,
        color: color,
        size: 15,
      );

      stars.add(star);
    }

    return Row(children: stars);
  }

  Widget buildCard(ctx, data, index) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: GestureDetector(
        onTap: () {
          //       bool _hasNextPage = true;
          // bool _isFirstLoadRunning = false;
          // bool _isLoadMoreRunning = false;
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (BuildContext context) => RestaurantDetailScreen(
          //           restaurantId: data[index].id,
          //           restaurantName: data[index].name, rating: _buildRatingBar(),
          //           ownerPid: data[index].owner.userPublicId,
          Route route = MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(
                    restaurantId: data[index].id,
                    restaurantName: data[index].name,
                    restaurantPhone: data[index].phoneNumber,
                    // rating: _buildRatingBar(),
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
                  size: 20,
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
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        size: 13,
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
                      _buildRatingBar(data[index].rate),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.of(context).push(
        //         MaterialPageRoute(builder: (context) => const NewsPage()));
        //   },
        // ),
        body: RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
        _posts!.then((value) => value.clear());
        onRefresh();
      },
      color: Colors.white,
      backgroundColor: const Color.fromARGB(255, 176, 101, 39),
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: FutureBuilder<List<RestaurantsList>>(
        future: _posts,
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
            List<RestaurantsList>? data = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Scrollbar(
                controller: scrollController1,
                // isAlwaysShown: true,
                child: Column(
                  children: [
                    // if (_isFirstLoadRunning)

                    Expanded(
                      child: GridView.builder(
                          controller: _scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  // maxCrossAxisExtent: 200,
                                  childAspectRatio: 1.9 / 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 20,
                                  mainAxisExtent: 240,
                                  crossAxisCount: 2),
                          itemCount: data!.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return buildCard(ctx, data, index);
                          }),
                    ),
                    if (_isLoadMoreRunning == true)
                      const Center(
                        child: MoreLoadingGif(
                          type: MoreLoadingGifType.ripple,
                          size: 50,
                        ),
                      ),
                    if (_hasNextPage == false)
                      Container(
                        padding: const EdgeInsets.only(top: 15, bottom: 20),
                        color: Colors.amber,
                        child: const Center(
                          child:
                              Text('You have fetched all of the restaurants'),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MoreLoadingGif(type: MoreLoadingGifType.ripple),
                Text('please wait')
              ],
            ),
          );
        },
      ),
    ));
  }
}
