import 'package:flutter/material.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:provider/provider.dart';

import '../models/get_all_menu_model.dart';
import '../models/get_menu_foods_model.dart';
import '../providers/fetch_and_post.dart';
import '../style/colors.dart';
import '../style/style.dart';
import '../screens/food_detail.dart';

class MenuDetail extends StatefulWidget {
  final List<GetAllMenuModel> data;
  final int index;
  const MenuDetail({Key? key, required this.data, required this.index})
      : super(key: key);

  @override
  State<MenuDetail> createState() => _MenuDetailState();
}

Future<List<GetMenuFoods>>? foodList;

class _MenuDetailState extends State<MenuDetail> {
  @override
  void initState() {
    super.initState();
    foodList = Provider.of<Fetch>(context, listen: false)
        .fetchMenuFoodsList(widget.data[widget.index].id, context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: widget.data[widget.index].foods.isEmpty
            ? const Center(
                child: TitleFont(
                  text: 'No foods added in this menu',
                  size: 20,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: TitleFont(
                        text: widget.data[widget.index].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        size: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DescriptionFont(
                        text: widget.data[widget.index].description,
                        color: AppColors.grey,
                        align: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: FutureBuilder<List<GetMenuFoods>>(
                        future: foodList,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasError) {
                            final error = snapshot.error;
                            if ('$error' ==
                                'Network is unreachable! Please check your internet connection.') {
                              return const Center(
                                child: InfoFont(
                                    text:
                                        'Network is unreachable! Please check your internet connection.'),
                              );
                            }
                            if ('$error' ==
                                'Network is timedout please try again.') {
                              return const Center(
                                child: InfoFont(
                                    text:
                                        'Network is timedout please try again.'),
                              );
                            } else if ('$error' ==
                                'Unexpected Error Occured! Please try again.') {
                              return const Center(
                                child: InfoFont(
                                    text:
                                        'Unexpected Error Occured! Please try again.'),
                              );
                            }
                          }
                          if (snapshot.hasData) {
                            List<GetMenuFoods>? data = snapshot.data;
                            return ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (ctx, index) {
                                int convertedPrice = data[index].price.toInt();
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FoodDetail(
                                                  foodImage: data[index]
                                                      .foodImageEntities,
                                                  name: data[index].name,
                                                  description:
                                                      data[index].description,
                                                  price: convertedPrice,
                                                  restaurantId:
                                                      data[index].restaurantId,
                                                )));
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(
                                            data[index]
                                                .foodImageEntities[0]
                                                .url)),
                                    title: TitleFont(
                                      text: data[index].name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: DescriptionFont(
                                      text: data[index].description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: TitleFont(
                                      text: '$convertedPrice Birr ',
                                      size: 20,
                                    ),
                                  ),
                                );
                              },
                              itemCount: data!.length,
                            );
                          }
                          return const Center(
                              child: MoreLoadingGif(
                                  type: MoreLoadingGifType.ripple));
                        },
                      ),
                    )
                  ],
                ),
              ));
  }
}
