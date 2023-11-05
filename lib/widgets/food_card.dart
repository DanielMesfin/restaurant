import 'dart:async';

import 'package:urban_restaurant/style/colors.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/fetch_and_post.dart';
import '../style/style.dart';
import '../screens/food_detail.dart';

class FoodCard extends StatefulWidget {
  final int restaurantId;
  final String restaurantName;
  final String restautantPhone;
  final dynamic data;
  final bool showDetail;
  final bool? showFavorite;
  final bool enableEdit;
  final int index;
  const FoodCard({
    Key? key,
    required this.restaurantName,
    required this.restautantPhone,
    required this.restaurantId,
    required this.data,
    required this.showDetail,
    this.showFavorite,
    required this.enableEdit,
    required this.index,
    // this.function
  }) : super(key: key);

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  int favoriteTapColor = 0;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() {
    Provider.of<Fetch>(context, listen: false).checkLogin();
    if (Provider.of<Fetch>(context, listen: false).token != null &&
        Provider.of<Fetch>(context, listen: false).pid != null) {
      Provider.of<Fetch>(context, listen: false)
          .fetchFavoriteFoodList(context, false);
    }
  }

  onRefresh() {
    Provider.of<Fetch>(context, listen: false).lisOfFavFoodId.clear();
    Provider.of<Fetch>(context, listen: false).checkLogin();
    if (Provider.of<Fetch>(context, listen: false).token != null &&
        Provider.of<Fetch>(context, listen: false).pid != null) {
      Provider.of<Fetch>(context, listen: false)
          .fetchFavoriteFoodList(context, false);
    }
    // fechFevoriteFood();
    setState(() {});
  }

  Future<void> callnow() async {
    String url = 'tel:${widget.restautantPhone}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Provider.of<Fetch>(context, listen: false).scaffoldMessage(
          context, 'Error Occured! Please try again later.', Colors.red);
    }
  }

  Widget foodListCard(data, int index) {
    int convertedPrice = data[index].price.toInt();
    //  String updatedFoodPriceController.text = convertedPrice.toString();
    return GestureDetector(
      onTap: widget.showDetail == false
          ? null
          : () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FoodDetail(
                              foodImage: data[index].foodImageEntities,
                              name: data[index].name,
                              restaurantName: widget.restaurantName,
                              description: data[index].description,
                              price: convertedPrice,
                              restaurantId: widget.restaurantId,
                            )))
              },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.only(right: 25, left: 20, top: 25),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(20),
        //   boxShadow: const [
        //     BoxShadow(blurRadius: 10, color: AppColors.lighterGray)
        //   ],
        //   color: AppColors.white,
        // ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // const Icon(
                            //   Icons.star,
                            //   color: AppColors.primary,
                            //   size: 20,
                            // ),
                            // SizedBox(width: 5),
                            SizedBox(
                              width: 170,
                              child: Poppins(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: 'from ${widget.restaurantName}',
                                size: 13,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: TitleFont(
                              color: AppColors.secondary,
                              text: data[index].name,
                              size: 22,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: widget.showFavorite == false ? 25 : 0,
                        ),
                        Info2Font(
                            text: '$convertedPrice Birr',
                            size: 20,
                            color: AppColors.tertiary),
                        const SizedBox(
                          height: 10,
                        ),
                        widget.showFavorite == false
                            ? Container()
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.lightGray),
                                onPressed: () {
                                  callnow();
                                },
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 14,
                                    ),
                                    DescriptionFont(
                                        text: '  ${widget.restautantPhone}',
                                        size: 14,
                                        color: AppColors.black),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      widget.showFavorite == false
                          ? Container()
                          : CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 25,
                              child: Provider.of<Fetch>(context, listen: false)
                                          .pid !=
                                      null
                                  ? FavoriteButton(
                                      // iconColor:
                                      //     Provider.of<Fetch>(context, listen: false)
                                      //             .lisOfFavFoodId
                                      //             .contains(data[index].id)
                                      //         ? _favoriteColor = Colors.red
                                      //         : _favoriteColor,
                                      iconSize: 43,
                                      isFavorite: Provider.of<Fetch>(context,
                                                  listen: false)
                                              .lisOfFavFoodId
                                              .contains(data[index].id)
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
                                              .deleteFavoriteFood(context,
                                                  data[index].id, null);
                                          // _isFavorite = false;
                                          onRefresh();
                                        } else if (isFavorite == false) {
                                          Provider.of<Fetch>(context,
                                                  listen: false)
                                              .addFavoriteFood(
                                                  context, data[index].id);
                                          onRefresh();
                                        }
                                      })
                                  : IconButton(
                                      onPressed: () {
                                        Provider.of<Fetch>(context,
                                                listen: false)
                                            .loginRequestDialogue(context);
                                      },
                                      icon: const Icon(
                                        Icons.favorite,
                                        size: 30,
                                        color: AppColors.grey,
                                      )),
                            ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
              // Expanded(
              //   // your image goes here which will take as much height as possible.
              //   child: Container(
              //     transform: Matrix4.translationValues(-40, 0.0, 0.0),
              //     child: Image.network(data[index].foodImageEntities[0].url,
              //         fit: BoxFit.contain),
              //   ),
              // ),
              Container(
                transform: Matrix4.translationValues(-30, 0.0, 0.0),
                // constraints: BoxConstraints(
                //     maxHeight: MediaQuery.of(context).size.width * 0.75,
                //     maxWidth: double.infinity),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.28,
                  child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          NetworkImage(data![index].foodImageEntities[0].url)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return foodListCard(widget.data, widget.index);
  }
}
