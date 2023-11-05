import 'dart:async';
import 'package:urban_restaurant/models/get_menu_foods_model.dart';
import 'package:urban_restaurant/style/colors.dart';
import 'package:urban_restaurant/style/style.dart';
import 'package:urban_restaurant/widgets/card_for_lists.dart';
import 'package:urban_restaurant/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/searched_restaurant_model.dart';
import '../providers/fetch_and_post.dart';
import '../widgets/error_messages.dart';

class SearchDialogue extends StatefulWidget {
  final String? searchString;
  const SearchDialogue({Key? key, this.searchString}) : super(key: key);

  @override
  SearchDialogueState createState() => SearchDialogueState();
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      const Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class SearchDialogueState extends State<SearchDialogue> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController searchController = TextEditingController();
  final _debouncer = Debouncer();
  // int? activeTab = 0;
  Future<List<SearchedRestaurant>>? restaurantResults;
  List<GetMenuFoods> foodResults = [];
  ScrollController scrollController = ScrollController();
  // bool? isLoading;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(hideKeyboard);
    if (widget.searchString != null) {
      searchController.text = widget.searchString!;
      search(context);
    }
  }

  hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void search(context) {
    print(searchController.text);
    // if (activeTab == 0) {
    _debouncer.run(() {
      restaurantResults = Provider.of<Fetch>(context, listen: false)
          .fetchSearchedRestaurants(context, searchController.text);
      setState(() {
        // restaurantResults = Provider.of<Fetch>(context, listen: false).postsB;
        // .where(
        //   (element) => (element.name.toLowerCase().contains(
        //         string.toLowerCase(),
        //       )),
        // )
        // .toList();
        // isLoading = false;
      });
    });
    // } else {
    //   _debouncer.run(() {
    //     restaurantResults = Provider.of<Fetch>(context, listen: false)
    //         .fetchSearchedRestaurants(context, searchController.text);
    //     setState(() {
    //       // restaurantResults = Provider.of<Fetch>(context, listen: false).postsB;
    //       // .where(
    //       //   (element) => (element.name.toLowerCase().contains(
    //       //         string.toLowerCase(),
    //       //       )),
    //       // )
    //       // .toList();
    //       // isLoading = false;
    //     });
    //   });
    // }
  }

  Widget searchResult() {
    return FutureBuilder<List<SearchedRestaurant>>(
        future: restaurantResults,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Column(
                children: [
                  ShimmerLoading(
                    detail: false,
                    home: false,
                    homeA: false,
                    foodCard: false,
                    search: true,
                  )
                ],
              );
            case ConnectionState.done:
            default:
              if (snapshot.hasError) {
                final error = snapshot.error;
                String unreachableMsg =
                        'Network is unreachable! Please check your internet connection.',
                    timedOutMsg = 'Network is timedout please try again.',
                    ueMsg = 'Unexpected Error Occured! Please try again.';
                if ('$error' == unreachableMsg) {
                  return ErrorMessages(
                    msg: unreachableMsg,
                  );
                } else if ('$error' == timedOutMsg) {
                  return ErrorMessages(
                    msg: timedOutMsg,
                  );
                } else if ('$error' == ueMsg) {
                  return ErrorMessages(
                    msg: ueMsg,
                  );
                }
              }
              if (snapshot.hasData) {
                List<SearchedRestaurant>? data = snapshot.data;
                if (data!.isEmpty) {
                  const Center(
                    child: DescriptionFont(
                      text: 'No results found',
                      color: AppColors.black,
                    ),
                  );
                }
                return ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(5),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CardForLists(
                        data: data,
                        index: index,
                        foodCard: true,
                        simpleCard: false);
                  },
                );
              } else {
                return Center(child: Container());
              }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child:
          // DefaultTabController(
          //   initialIndex: 0,
          //   length: 2,
          //   child:
          Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: Form(
                key: _formKey,
                child: TextFormField(
                    autofocus: true,
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: AppColors.secondary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            if (searchController.text.isNotEmpty) {
                              setState(() {
                                searchController.clear();
                                restaurantResults =
                                    Provider.of<Fetch>(context, listen: false)
                                        .fetchSearchedRestaurants(
                                            context, searchController.text)
                                        .then((value) => value..clear());
                              });
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Icon(
                            Icons.clear,
                            color: AppColors.secondary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(15.0),
                        hintText:
                            //  activeTab == 0
                            // ?
                            'Search Restaurants'
                        // : 'Search Food',
                        ),
                    onChanged: (string) {
                      setState(() {
                        // isLoading = true;
                        search(context);
                      });
                    })),
          ),
          Expanded(child: searchResult())
          // TabBar(
          //   onTap: (index) {
          //     setState(() {
          //       activeTab = index;
          //       searchController.clear();
          //       restaurantResults = Provider.of<Fetch>(context, listen: false)
          //           .fetchSearchedRestaurants(context, searchController.text)
          //           .then((value) => value..clear());
          //     });
          //     print(activeTab);
          //   },
          //   labelColor: Colors.black,
          //   indicatorColor: AppColors.primary,
          //   labelPadding: const EdgeInsets.all(0),
          //   unselectedLabelStyle:
          //       const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
          //   labelStyle:
          //       const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          //   tabs: const [
          //     Tab(
          //       text: 'Restaurants',
          //     ),
          //     Tab(
          //       text: 'Foods',
          //     ),
          //   ],
          // ),
          // Expanded(
          //   child:
          //   TabBarView(
          //     physics: const NeverScrollableScrollPhysics(),
          //     children: [
          //       searchResult(),
          //       searchResult()
          //       // ListView.builder(
          //       //   shrinkWrap: true,
          //       //   physics: const ClampingScrollPhysics(),
          //       //   padding: const EdgeInsets.all(5),
          //       //   itemCount: foodResults.length,
          //       //   itemBuilder: (BuildContext context, int index) {
          //       //     return Card(
          //       //       shape: RoundedRectangleBorder(
          //       //         borderRadius: BorderRadius.circular(20),
          //       //         side: BorderSide(
          //       //           color: Colors.grey.shade300,
          //       //         ),
          //       //       ),
          //       //       child: Padding(
          //       //         padding: const EdgeInsets.all(5.0),
          //       //         child: Column(
          //       //           mainAxisAlignment: MainAxisAlignment.start,
          //       //           crossAxisAlignment: CrossAxisAlignment.start,
          //       //           children: <Widget>[
          //       //             ListTile(
          //       //               title: TitleFont(
          //       //                   text: foodResults[index].name, size: 16),
          //       //               subtitle: DescriptionFont(
          //       //                 text: foodResults[index].description,
          //       //                 size: 13,
          //       //                 color: AppColors.grey,
          //       //               ),
          //       //               trailing: CircleAvatar(
          //       //                 backgroundColor: Colors.transparent,
          //       //                 backgroundImage: NetworkImage(
          //       //                     foodResults[index]
          //       //                         .foodImageEntities[0]
          //       //                         .url),
          //       //               ),
          //       //             ),
          //       //             Row(
          //       //               children: [
          //       //                 SizedBox(
          //       //                   width: 20,
          //       //                 ),
          //       //                 // RatingBarWidget(
          //       //                 //     rate: Provider.of<Fetch>(context,
          //       //                 //             listen: false)
          //       //                 //         .postsB[index]
          //       //                 //         .rate),
          //       //               ],
          //       //             )
          //       //           ],
          //       //         ),
          //       //       ),
          //       //     );
          //       //   },
          //       // ),
          //     ],
          //   ),
          // ),
        ],
      ),
      //   ),
    );
  }
}
