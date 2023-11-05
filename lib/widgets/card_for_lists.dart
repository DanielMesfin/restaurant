import 'package:urban_restaurant/widgets/rating_bar.dart';
import 'package:flutter/material.dart';

import '../screens/restaurant_detail.dart';
import '../style/colors.dart';
import '../style/style.dart';

class CardForLists extends StatefulWidget {
  final dynamic data;
  final int index;
  final bool foodCard;
  final bool simpleCard;
  const CardForLists(
      {Key? key,
      this.data,
      required this.index,
      required this.foodCard,
      required this.simpleCard})
      : super(key: key);

  @override
  State<CardForLists> createState() => _CardForListsState();
}

class _CardForListsState extends State<CardForLists> {
  @override
  Widget build(BuildContext context) {
    if (widget.simpleCard) {
      return GestureDetector(
        onTap: () {
          if (widget.foodCard) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              // if (widget.foodCard){
              //   return FoodDetail(foodImage: foodImage, name: name, description: description, price: price, restaurantId: restaurantId)
              // }
              return RestaurantDetailScreen(
                restaurantId: widget.data![widget.index].id,
                restaurantName: widget.data![widget.index].name,
                restaurantPhone: widget.data![widget.index].phoneNumber,
                ownerPid: widget.data![widget.index].owner.userPublicId,
              );
            }));
          }
        },
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title:
                      TitleFont(text: widget.data[widget.index].name, size: 16),
                  subtitle: DescriptionFont(
                    text: widget.data[widget.index].description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    size: 13,
                    color: AppColors.grey,
                  ),
                  trailing: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(widget
                        .data[widget.index].restaurantImageEntities[0].url),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    RatingBarWidget(rate: widget.data[widget.index].rate),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                // if (widget.foodCard){
                //   return FoodDetail(foodImage: foodImage, name: name, description: description, price: price, restaurantId: restaurantId)
                // }
                return RestaurantDetailScreen(
                  restaurantId: widget.data![widget.index].id,
                  restaurantName: widget.data![widget.index].name,
                  restaurantPhone: widget.data![widget.index].phoneNumber,
                  ownerPid: widget.data![widget.index].owner.userPublicId,
                );
              }));
            },
            child: Card(
                elevation: 8,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(widget.data![widget.index]
                            .restaurantImageEntities[0].url),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TitleFont(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: widget.data![widget.index].name,
                              size: 20,
                            ),
                          ),
                          // const SizedBox(
                          //   height: 5,
                          // ),
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Align(
                                alignment: Alignment.center,
                                child: DescriptionFont(
                                  size: MediaQuery.of(context).size.width > 380
                                      ? 13
                                      : 10,
                                  text: widget.data![widget.index].description,
                                  maxLines: 3,
                                  color: AppColors.grey,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Info2Font(text: 'Rating  '),
                                const SizedBox(width: 5),
                                RatingBarWidget(
                                    rate: widget.data![widget.index].rate)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.pin_drop,
                              color: AppColors.red,
                            ),
                            DescriptionFont(
                              text:
                                  widget.data![widget.index].address[0].street,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              size: 8,
                            ),
                            DescriptionFont(
                              text: widget.data![widget.index].address[0].city,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              size: 8,
                            )
                          ],
                        ))
                  ],
                )),
          )),
    );
  }
}
