import 'dart:async';

import 'package:urban_restaurant/models/get_user_review_model.dart';
import 'package:urban_restaurant/models/post_res_models.dart';
import 'package:urban_restaurant/screens/add_menu.dart';
import 'package:urban_restaurant/screens/login.dart';
import 'package:urban_restaurant/style/style.dart';
import 'package:urban_restaurant/widgets/chips.dart';
import 'package:urban_restaurant/widgets/dividers.dart';
import 'package:urban_restaurant/widgets/error_messages.dart';
import 'package:urban_restaurant/widgets/food_card.dart';
import 'package:urban_restaurant/widgets/image_view.dart';
import 'package:urban_restaurant/widgets/image_carousel.dart';
import 'package:urban_restaurant/widgets/menu_detail.dart';
import 'package:urban_restaurant/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:provider/provider.dart';
import '../models/get_all_menu_model.dart';
import '../models/restaurant_all_food_model.dart';
import '../providers/fetch_and_post.dart';
import '../style/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:favorite_button/favorite_button.dart';
import '../widgets/rating_bar.dart';

class RestaurantDetailScreen extends StatefulWidget {
  static const routeName = '/restaurantDetail';
  final int restaurantId;
  final String restaurantName;
  final String restaurantPhone;
  final Widget? rating;
  final String? ownerPid;
  const RestaurantDetailScreen({
    Key? key,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantPhone,
    this.rating,
    this.ownerPid,
  }) : super(key: key);

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  // int selectedTab = 0;

  // int _current = 0;
  List imgList = [
    'https://i.dlpng.com/static/png/6838599_preview.png',
    'https://i.dlpng.com/static/png/6838599_preview.png',
    'https://i.dlpng.com/static/png/6838599_preview.png',
    'https://i.dlpng.com/static/png/6838599_preview.png',
  ];
  late Future<Restaurant> detail;
  late Future<List<GetAllMenuModel>> menu;
  late Future<List<RestaurantAllFoodModel>> allFood;
  Future<List<UserReviewModel>>? usersReview;

  TextEditingController reviewController = TextEditingController();

  String? token, pid;
  Color favoriteStarColor = Colors.grey;

  @override
  void initState() {
    super.initState();

    _checkLogin();
    usersReview = Provider.of<Fetch>(context, listen: false)
        .fetchRestaurantReviews(context, widget.restaurantId);
    detail = Provider.of<Fetch>(context, listen: false)
        .fetchRestaurantDetail(widget.restaurantId, context);
    menu = Provider.of<Fetch>(context, listen: false)
        .fetchMenuList(context, widget.restaurantId);
    allFood = Provider.of<Fetch>(context, listen: false)
        .fetchRestaurntFoodsList(widget.restaurantId, context);
  }

  void _checkLogin() {
    Provider.of<Fetch>(context, listen: false).checkLogin();
    if (Provider.of<Fetch>(context, listen: false).token != null &&
        Provider.of<Fetch>(context, listen: false).pid != null) {
      Provider.of<Fetch>(context, listen: false).lisOfFavFoodId.clear();
      Provider.of<Fetch>(context, listen: false).lisOfFavRestaurantId.clear();
      Provider.of<Fetch>(context, listen: false)
          .fetchFavoriteFoodList(context, false);
      Provider.of<Fetch>(context, listen: false)
          .fetchFavoriteRestaurantList(context, false);
    }
  }

  FutureOr onGoBack(dynamic value) {
    onRefresh();
    // setState(() {});
  }

  onRefresh() {
    setState(() {});
    detail = Provider.of<Fetch>(context, listen: false)
        .fetchRestaurantDetail(widget.restaurantId, context);
    menu = Provider.of<Fetch>(context, listen: false)
        .fetchMenuList(context, widget.restaurantId);
    allFood = Provider.of<Fetch>(context, listen: false)
        .fetchRestaurntFoodsList(widget.restaurantId, context);
    usersReview = Provider.of<Fetch>(context, listen: false)
        .fetchRestaurantReviews(context, widget.restaurantId);
    _checkLogin();
  }

  void _updateRating(double rating) {
    Provider.of<Fetch>(context, listen: false)
        .fetchRestaurantRating(context, widget.restaurantId, rating, onRefresh);
    Navigator.of(context).pop();
  }

  Widget _buildRatingBar(double? rate) {
    if (rate == 0.0) {
      return TextButton(
          onPressed: () {
            if (widget.ownerPid ==
                Provider.of<Fetch>(context, listen: false).pid) {
              return;
            } else {
              reviewModal(context);
            }
          },
          child: const Info4Font(
            text: 'Not Rated',
            color: AppColors.black,
            size: 15,
          ));
    } else {
      return RatingBarWidget(rate: rate!);
    }
  }

  // Future<void> _giveComment(
  //   double rating,
  // ) async {
  //   int rate = rating.toInt();
  //   final url = Uri.parse(
  //       'https://cqfntvunda.us-east-1.awsapprunner.com/dealer/rate/?rate=$rate');

  //   try {} catch (error) {
  //     rethrow;
  //   }
  // }

  void confirmationDialogue(String title, desc, int id) {
    AwesomeDialog(
      context: context,
      animType: AnimType.TOPSLIDE,
      headerAnimationLoop: false,
      dialogType: DialogType.WARNING,
      showCloseIcon: true,
      title: title,
      desc: desc,
      btnOkOnPress: () async {
        await Provider.of<Fetch>(context, listen: false)
            .deleteMenuHandler(id, context, onRefresh);
        onRefresh();
      },
      btnOkIcon: Icons.check_circle,
      btnOkText: 'Ok',
      btnCancelOnPress: () {
        // Navigator.of(context).pop();
        // Navigator.pop(context);
      },
      btnCancelIcon: Icons.cancel,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  void confirmationDialogueForRestaurantDelete(String title, desc, int id) {
    AwesomeDialog(
      context: context,
      animType: AnimType.TOPSLIDE,
      headerAnimationLoop: false,
      dialogType: DialogType.WARNING,
      showCloseIcon: true,
      title: 'Delete?',
      desc: 'Are you sure you want to delete ${widget.restaurantName}?',
      btnOkOnPress: () async {
        await Provider.of<Fetch>(context, listen: false)
            .deleteRestaurantHandler(
                widget.restaurantId, widget.restaurantName, context);
      },
      btnOkIcon: Icons.check_circle,
      btnOkText: 'Ok',
      btnCancelOnPress: () {
        // Navigator.of(context).pop();
        // Navigator.pop(context);
      },
      btnCancelIcon: Icons.cancel,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  void infoModal() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: TitleFont(text: 'How to add menu?'),
            content: DescriptionFont(
              color: AppColors.grey,
              size: 15,
              text:
                  'Tap Add Menu button then enter the menu name you want to add then enter the menu description after that tap Done botton. You can edit or update your existing menu from the restaurant detail screen.',
            ),
          );
        });
  }

  void menuDetailModal(List<GetAllMenuModel> data, int index) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        isScrollControlled: true,
        elevation: 5,
        builder: (context) {
          return MenuDetail(data: data, index: index);
        });
  }

  void reviewModal(BuildContext ctx) {
    showModalBottomSheet(
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        isScrollControlled: true,
        elevation: 5,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 0),
                child: SizedBox(
                  height: 100,
                  // height: 600,
                  // child: SingleChildScrollView(
                  //   child: Column(
                  //     mainAxisSize: MainAxisSize.min,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           const PrimaryText(
                  //             height: 1,
                  //             text: 'Reviews',
                  //             size: 22,
                  //             color: Color.fromARGB(255, 41, 34, 14),
                  //           ),
                  //           IconButton(
                  //               onPressed: () {
                  //                 Navigator.of(context).pop();
                  //               },
                  //               icon: const Icon(Icons.cancel_outlined))
                  //         ],
                  //       ),
                  //       SingleChildScrollView(
                  //         child: FutureBuilder<List<UserReviewModel>>(
                  //           future: usersReview,
                  //           builder: (context, snapshot) {
                  //             List<UserReviewModel>? data = snapshot.data;
                  //             if (snapshot.hasData) {
                  //               // List<UserReviewModel>? data = snapshot.data;

                  //               return SizedBox(
                  //                 height: 400,
                  //                 child: ListView.builder(
                  //                   itemCount: snapshot.data!.length,
                  //                   itemBuilder: (_, index) {
                  //                     String date =
                  //                         data![index].currentTime.toString();
                  //                     //
                  //                     String postedDay =
                  //                         Jiffy(date).format('MMM d yyyy');
                  //                     String postedTime =
                  //                         Jiffy(date).format('h:mm:ss a');
                  //                     // print(result1);
                  //                     // var postedAt = date.split(' , ').first;
                  //                     return Container(
                  //                       margin: const EdgeInsets.symmetric(
                  //                           horizontal: 10, vertical: 5),
                  //                       padding: const EdgeInsets.all(15.0),
                  //                       decoration: BoxDecoration(
                  //                         color: const Color.fromARGB(
                  //                             255, 197, 199, 199),
                  //                         borderRadius:
                  //                             BorderRadius.circular(15.0),
                  //                       ),
                  //                       child: Column(
                  //                         children: [
                  //                           Row(
                  //                             mainAxisAlignment:
                  //                                 MainAxisAlignment
                  //                                     .spaceBetween,
                  //                             children: [
                  //                               Text(
                  //                                 snapshot.data![index].user
                  //                                     .firstName,
                  //                                 style: const TextStyle(
                  //                                   fontSize: 18.0,
                  //                                   fontWeight: FontWeight.bold,
                  //                                 ),
                  //                               ),
                  //                               Column(
                  //                                 children: [
                  //                                   Text(
                  //                                     postedDay,
                  //                                     style: const TextStyle(
                  //                                         color: Color.fromARGB(
                  //                                             255,
                  //                                             117,
                  //                                             117,
                  //                                             117),
                  //                                         fontSize: 10),
                  //                                   ),
                  //                                   Text('At $postedTime',
                  //                                       style: const TextStyle(
                  //                                           color:
                  //                                               Color.fromARGB(
                  //                                                   255,
                  //                                                   117,
                  //                                                   117,
                  //                                                   117),
                  //                                           fontSize: 10))
                  //                                 ],
                  //                               )
                  //                             ],
                  //                           ),
                  //                           const SizedBox(height: 10),
                  //                           SizedBox(
                  //                             width: MediaQuery.of(context)
                  //                                     .size
                  //                                     .width *
                  //                                 0.8,
                  //                             child: Text(snapshot
                  //                                 .data![index].feedback),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     );
                  //                   },
                  //                 ),
                  //               );
                  //             } else if (snapshot.data == null) {
                  //               const Center(child: Text('No Feedback!'));
                  //             } else if (snapshot.data!.isEmpty) {
                  //               const Center(child: Text('No Feedback!'));
                  //             }
                  //             return const SizedBox(
                  //               height: 400,
                  //               child:
                  //                   Center(child: Text('No feddback found!')),
                  //             );
                  //           },
                  //         ),
                  //       ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RatingBar.builder(
                              //tapOnlyMode: true,
                              itemSize: 30,
                              initialRating: 0.0, //_rating,
                              minRating: 1,
                              maxRating: 5,
                              itemBuilder: (ctx, _) => const Icon(Icons.star,
                                  color: AppColors.primary),
                              updateOnDrag: true,
                              onRatingUpdate: (rating) {
                                if (Provider.of<Fetch>(context, listen: false)
                                        .pid !=
                                    null) {
                                  _updateRating(rating);
                                } else {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Rate this restaurant?'),
                                        content: const SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                'You need to login to rate this restaurant!',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 122, 120, 120)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text(
                                              'Login',
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          LoginScreen()));
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }),
                          // SizedBox(width: 8.0),
                          // ElevatedButton(
                          //   onPressed: () async {
                          //     await _updateAndGetRating(
                          //       _rating,
                          //     );
                          //   },
                          //   child: Text(
                          //     'rate',
                          //     style: TextStyle(
                          //         fontSize: 18,
                          //         color: Color.fromARGB(255, 255, 255, 255)),
                          //   ),
                          // ),
                        ],
                      ),
                      // Form(
                      //   key: _formKey,
                      //   child: TextFormField(
                      //     controller: reviewController,
                      //     keyboardType: TextInputType.multiline,
                      //     decoration: const InputDecoration(
                      //       labelText: 'Type something',
                      //     ),
                      //     validator: (val) {
                      //       if (val.toString().isEmpty) {
                      //         return 'Menu description is required';
                      //       }
                      //       if (!(RegExp(r"^[a-zA-Z () 0-9 .,?]*$")
                      //           .hasMatch(val.toString()))) {
                      //         return 'Invalid Menu Description';
                      //       }
                      //       return null;
                      //     },
                      //     onSaved: (value) {
                      //       reviewController.text = value.toString();
                      //       // nameController.text = value.toString();
                      //     },
                      //   ),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     ElevatedButton(
                      //       onPressed: () async {
                      //         // await _giveComment(
                      //         //   _rating,
                      //         // );
                      //         if (_formKey.currentState!.validate()) {
                      //           await Provider.of<Fetch>(context, listen: false)
                      //               .postFeedback(context, widget.restaurantId,
                      //                   reviewController.text);
                      //           usersReview =
                      //               Provider.of<Fetch>(context, listen: false)
                      //                   .fetchRestaurantReviews(
                      //                       context, widget.restaurantId);
                      //           reviewController.clear();
                      //           setState;
                      //           onRefresh();
                      //         }
                      //       },
                      //       child: const Text(
                      //         'Submit review',
                      //         style: TextStyle(
                      //             fontSize: 18,
                      //             color: Color.fromARGB(255, 255, 255, 255)),
                      //       ),
                      //     ),
                      //     Container()
                      //   ],
                      // ),
                    ],
                  ),

                  // const SizedBox(
                  //   height: 200,
                  // )
                  //       ],
                  //     ),
                  //   ),
                ),
              );
            },
          );
        });
  }

  Container imageCard(String? imagePath) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        margin: const EdgeInsets.only(
          right: 20,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.white,
            boxShadow: const [
              BoxShadow(blurRadius: 10, color: AppColors.lightGray),
            ]),
        child: GestureDetector(
          child: Image.network(
            imagePath!,
            width: 130,
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ImageView(
                img: imagePath,
              );
            }));
          },
        ));
  }

  Widget body(Restaurant data, List<String> tags) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.pin_drop,
                        size: 15,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Info2Font(
                            text:
                                '${data.address[0].street}, ${data.address[0].city}',
                            maxLines: 1,
                            size: 14,
                            fontStyle: FontStyle.italic,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      _buildRatingBar(data.rate),
                      const SizedBox(
                        width: 5,
                      ),
                      Text('(${data.usersRated.toString()})')
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8.0),
              ExpansionTile(
                title: const Row(
                  children: [
                    TitleFont(
                      text: 'Tap here for details',
                      color: AppColors.primary,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.arrow_downward,
                      color: AppColors.primary,
                    )
                  ],
                ),
                backgroundColor: const Color.fromARGB(255, 236, 234, 234),
                trailing: const Text(''),
                children: [
                  const DividerWidget(title: 'Description'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Info3Font(
                      text: data.description,
                      size: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const DividerWidget(title: 'Tags'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChipsWidget(
                      list: tags,
                      detailPage: true,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const DividerWidget(title: 'Our Working Hours'),
                  SizedBox(
                    height: data.openHours.length > 3
                        ? MediaQuery.of(context).size.height * 0.28
                        : MediaQuery.of(context).size.height * 0.10,
                    child: GridView.builder(
                      shrinkWrap: false,
                      padding: EdgeInsets.zero,
                      itemCount: data.openHours.length,
                      itemBuilder: (context, index) => ListTile(
                          title: InfoFont(
                            text: data.openHours[index].openDays,
                            color: AppColors.tertiary,
                            size: 17,
                          ),
                          subtitle: Info3Font(
                            size: 12,
                            text:
                                'From ${data.openHours[index].startTime} to ${data.openHours[index].endTime}',
                          )),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              // maxCrossAxisExtent: 200,
                              mainAxisExtent: 100,
                              // childAspectRatio: 0.5 / 0.5,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 3,
                              crossAxisCount: 3),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Info3Font(
                          text: 'Phone: ${data.phoneNumber}',
                          fontStyle: FontStyle.italic,
                          size: 16,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const DividerWidget(title: 'Our Menu'),
        FutureBuilder<List<GetAllMenuModel>>(
          future: menu,
          builder: (context, snapshot) {
            // print(snapshot.data![0]);
            if (snapshot.hasData) {
              List<GetAllMenuModel>? data = snapshot.data;
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Info2Font(
                            text: data!.isEmpty
                                ? 'No menus available!'
                                : 'Menus available (${data.length}) ',
                            size: deviceWidth > 380 ? 20 : 17,
                          ),
                          if (widget.ownerPid != null &&
                              Provider.of<Fetch>(context, listen: false).pid ==
                                  widget.ownerPid)
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  child: IconButton(
                                      onPressed: () {
                                        infoModal();
                                      },
                                      icon: const Icon(
                                        Icons.question_mark,
                                        size: 15,
                                      )),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary),
                                    onPressed: data.length <= 6
                                        ? () {
                                            Route route = MaterialPageRoute(
                                                builder: (context) => AddMenu(
                                                      resId:
                                                          widget.restaurantId,
                                                    ));
                                            Navigator.push(context, route)
                                                .then(onGoBack);
                                          }
                                        : null,
                                    icon: const Icon(
                                      Icons.add,
                                      color: AppColors.white,
                                    ),
                                    label: const InfoFont(
                                      text: 'Add Menu',
                                      size: 18,
                                      color: AppColors.white,
                                    )),
                              ],
                            )
                          else
                            Container()
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: widget.ownerPid != null &&
                                Provider.of<Fetch>(context, listen: false)
                                        .pid ==
                                    widget.ownerPid
                            ? () {
                                Route route = MaterialPageRoute(
                                    builder: (context) => Container()
                                    // UpdateMenu(
                                    //       menuId: data[index].id,
                                    //       menuDesc: data[index].description,
                                    //       menuName: data[index].name,
                                    //       restaurantId: widget.restaurantId,
                                    //       restaurantName: widget.restaurantName,
                                    //     )
                                    );
                                Navigator.push(context, route).then(onGoBack);
                              }
                            : () {
                                menuDetailModal(data, index);
                              },
                        child: Slidable(
                          key: const ValueKey(0),
                          endActionPane: widget.ownerPid != null &&
                                  Provider.of<Fetch>(context, listen: false)
                                          .pid ==
                                      widget.ownerPid
                              ? ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (BuildContext context) {
                                        confirmationDialogue(
                                            'Delete?',
                                            'Delete ${data[index].name}',
                                            data[index].id);
                                      },
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                    SlidableAction(
                                      onPressed: (BuildContext context) {
                                        Route route = MaterialPageRoute(
                                          //TODO this is updated
                                            builder: (context) =>Container()
                                            //  UpdateMenu(
                                            //       menuId: data[index].id,
                                            //       menuDesc:
                                            //           data[index].description,
                                            //       menuName: data[index].name,
                                            //       restaurantId:
                                            //           widget.restaurantId,
                                            //       restaurantName:
                                            //           widget.restaurantName,
                                            //     ),
                                                );
                                        Navigator.push(context, route)
                                            .then(onGoBack);
                                      },
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.black,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                    ),
                                  ],
                                )
                              : null,
                          child: ListTile(
                            // leading: const CircleAvatar(
                            //   child: Text(
                            //     "Menu",
                            //     style: TextStyle(fontSize: 15),
                            //   ),
                            //   backgroundColor: Colors.purple,
                            // ),
                            title: TitleFont(
                              text: data[index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: DescriptionFont(
                              text: data[index].description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DescriptionFont(
                                    text: '${data[index].foods.length} foods'),
                                widget.ownerPid != null &&
                                        Provider.of<Fetch>(context,
                                                    listen: false)
                                                .pid ==
                                            widget.ownerPid
                                    ? const Icon(Icons.arrow_left)
                                    : widget.ownerPid == null ||
                                            Provider.of<Fetch>(context,
                                                        listen: false)
                                                    .pid !=
                                                widget.ownerPid
                                        ? Container()
                                        : Container()
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: data.length,
                  ),
                ],
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('please wait'),
                  MoreLoadingGif(type: MoreLoadingGifType.ripple),
                ],
              ));
              // return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: const Center(child: Text('No menus added')));
            }
            if (snapshot.hasError) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Text("${snapshot.error}"));
            }
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: const Center(child: Text('No menus added')));
          },
        ),
        const SizedBox(
          height: 30,
        ),
        const DividerWidget(title: 'Our Foods'),
        // const SizedBox(
        //   height: 15,
        // ),
        FutureBuilder<List<RestaurantAllFoodModel>>(
          future: allFood,
          builder: (context, snapshot) {
            // print(snapshot.data![0]);
            if (snapshot.hasData) {
              List<RestaurantAllFoodModel>? data = snapshot.data;
              return Column(
                  children: List.generate(data!.length, (index) {
                return data.isEmpty
                    ? const Text('No foods added')
                    : FoodCard(
                        // might need to bring the food card widget to res detail for state update
                        restaurantName: widget.restaurantName,
                        restautantPhone: widget.restaurantPhone,
                        restaurantId: widget.restaurantId,
                        data: data,
                        showDetail: true,
                        showFavorite: widget.ownerPid != null &&
                                Provider.of<Fetch>(context, listen: false)
                                        .pid ==
                                    widget.ownerPid
                            ? false
                            : true,
                        enableEdit: false,
                        index: index,
                      );
              }));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('please wait'),
                  MoreLoadingGif(type: MoreLoadingGifType.ripple),
                ],
              ));
              // return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: const Center(child: Text('No foods added')));
            }
            if (snapshot.hasError) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Text("${snapshot.error}"));
            }
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: const Center(child: Text('No foods added')));
          },
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  // _onItemTapped(int index) {
  //   setState(() {
  //     selectedTab = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        floatingActionButton: // uncomment floating action button later to implemnt review
            //selectedTab == 0
            //     ?
            widget.ownerPid == Provider.of<Fetch>(context, listen: false).pid
                ? null
                : FloatingActionButton(
                    backgroundColor: AppColors.primary,
                    onPressed: () {
                      usersReview = Provider.of<Fetch>(context, listen: false)
                          .fetchRestaurantReviews(context, widget.restaurantId);
                      reviewModal(context);
                    },
                    tooltip: 'Add review',
                    child: const Icon(Icons.reviews),
                  ),
        // : null,
        body: FutureBuilder<Restaurant>(
          future: detail,
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              final error = snapshot.error;
              String unreachableMsg =
                      'Network is unreachable! Please check your internet connection.',
                  timedOutMsg = 'Network is timedout please try again.',
                  ueMsg = 'Unexpected Error Occured! Please try again.';
              if ('$error' == unreachableMsg) {
                return Center(
                  child: ErrorMessages(
                    msg: unreachableMsg,
                    onRefresh: onRefresh,
                  ),
                );
              } else if ('$error' == timedOutMsg) {
                return Center(
                  child: ErrorMessages(
                    msg: timedOutMsg,
                    onRefresh: onRefresh,
                  ),
                );
              } else if ('$error' == ueMsg) {
                return Center(
                  child: ErrorMessages(
                    msg: ueMsg,
                    onRefresh: onRefresh,
                  ),
                );
              }
            }
            if (snapshot.hasData) {
              Restaurant? data = snapshot.data;
              List<String> stringList = data!.tag.split(",");
              List<String> tags = [];
              tags.addAll(stringList);
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    leading: Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: BackButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      Container(
                          // decoration: const BoxDecoration(boxShadow: [
                          //   BoxShadow(
                          //       color: Color.fromARGB(255, 255, 255, 255),
                          //       blurRadius: 20)
                          // ]),
                          child: widget.ownerPid != null &&
                                  Provider.of<Fetch>(context, listen: false)
                                          .pid ==
                                      widget.ownerPid
                              ? Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 20,
                                      child: IconButton(
                                          onPressed: () {
                                            confirmationDialogueForRestaurantDelete(
                                                'Delete?',
                                                'Are you sure you want to delete ${widget.restaurantName}?',
                                                widget.restaurantId);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: AppColors.red,
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 20,
                                      child: IconButton(
                                          onPressed: () {
                                            Route route = MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>Container()
                                                        // EditRestaurant(
                                                        //   restaurantData: data,
                                                        //   // restaurantId: widget
                                                        //   //     .restaurantId,
                                                        //   // restaurantName: widget
                                                        //   // .restaurantName,
                                                        //   // ownerPid: widget.ownerPid,
                                                        //   // tags: tags,
                                                        // )
                                                        );
                                            Navigator.push(context, route)
                                                .then(onGoBack);
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          )),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(right: 5))
                                  ],
                                )
                              : null),
                      if (widget.ownerPid != null &&
                          Provider.of<Fetch>(context, listen: false).pid ==
                              widget.ownerPid)
                        Container()
                      else
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 20,
                              child: Provider.of<Fetch>(context, listen: false)
                                              .pid !=
                                          null &&
                                      Provider.of<Fetch>(context, listen: false)
                                              .token !=
                                          null
                                  ? FavoriteButton(
                                      // iconColor:
                                      //     Provider.of<Fetch>(context, listen: false)
                                      //             .lisOfFavFoodId
                                      //             .contains(data[index].id)
                                      //         ? _favoriteColor = Colors.red
                                      //         : _favoriteColor,
                                      iconSize: 40,
                                      isFavorite: Provider.of<Fetch>(context,
                                                  listen: false)
                                              .lisOfFavRestaurantId
                                              .contains(widget.restaurantId)
                                          ? true
                                          : false,
                                      // iconDisabledColor: Colors.white,
                                      valueChanged: (isFavorite) async {
                                        setState(() {
                                          // _favoriteColor == Colors.grey
                                          //     ? Colors.red
                                          //     : Colors.grey;
                                          isFavorite == false
                                              ? isFavorite = true
                                              : isFavorite = false;
                                        });
                                        // print('Is Favorite : $_isFavorite');
                                        if (isFavorite == true) {
                                          Provider.of<Fetch>(context,
                                                  listen: false)
                                              .deleteFavoriteRestaurant(
                                                  context,
                                                  widget.restaurantId,
                                                  false,
                                                  null);
                                          // _isFavorite = false;
                                          onRefresh();
                                        } else if (isFavorite == false) {
                                          Provider.of<Fetch>(context,
                                                  listen: false)
                                              .addFavoriteRestaurant(
                                                  context, widget.restaurantId);
                                          onRefresh();
                                        }

                                        // print('Is Favorite : $_isFavorite');
                                      })
                                  : IconButton(
                                      onPressed: () {
                                        Provider.of<Fetch>(context,
                                                listen: false)
                                            .loginRequestDialogue(context);
                                      },
                                      icon: const Icon(
                                        Icons.favorite,
                                        size: 25,
                                        color: AppColors.grey,
                                      )),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 5))
                          ],
                        ),
                    ],
                    backgroundColor: const Color.fromARGB(241, 255, 255, 255),
                    // automaticallyImplyLeading: false,
                    pinned: true,
                    snap: true,
                    floating: true,
                    expandedHeight: 180.0,
                    flexibleSpace: FlexibleSpaceBar(
                        title: TitleFont(
                          text: data.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.black,
                          shadows: const [
                            Shadow(
                              blurRadius: 20.0,
                              color: Colors.white,
                              offset: Offset(5.0, 5.0),
                            ),
                            Shadow(
                              color: Colors.white,
                              blurRadius: 20.0,
                              offset: Offset(-10.0, 5.0),
                            ),
                            Shadow(
                              color: Colors.white,
                              blurRadius: 20.0,
                              offset: Offset(-20.0, -5.0),
                            ),
                            Shadow(
                              color: Colors.white,
                              blurRadius: 20.0,
                              offset: Offset(20.0, 5.0),
                            ),
                          ],
                        ),
                        background: CarouselWidget(
                            imagesList: data.restaurantImageEntities)),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 20,
                      child: Center(
                        child: Container(),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return body(data, tags);
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              );
            }
            // }

            return const ShimmerLoading(
              detail: true,
              search: false,
              favorite: false,
              foodCard: false,
            );
          },
        ));
  }
}
