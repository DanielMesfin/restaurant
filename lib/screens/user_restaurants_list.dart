import 'package:urban_restaurant/models/users_registered_restaurants.dart';
import 'package:urban_restaurant/style/style.dart';
import 'package:urban_restaurant/widgets/card_for_lists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/fetch_and_post.dart';
import '../style/colors.dart';

class UserRestaurantsList extends StatelessWidget {
  final List<UsersRegisteredRestaurants>? data;
  const UserRestaurantsList({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const TitleFont(text: 'Your Restaurants'),
          backgroundColor: AppColors.transparent,
          elevation: 0,
          leading: const BackButton(),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: data!.isNotEmpty
                ? ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CardForLists(
                        data: data,
                        index: index,
                        foodCard: false,
                        simpleCard: false,
                      );
                    })
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const TitleFont(
                            size: 20,
                            text: 'You have no restaurants registered'),
                        TextButton(
                            onPressed: () async {
                              Provider.of<Fetch>(context, listen: false)
                                  .getCurrentLocation();
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              String? savedLocationLat =
                                  pref.getString('savedLocationLat');
                              String? savedLocationLon =
                                  pref.getString('savedLocationLon');
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Container()
                                    // RestaurantRegistatrationPage(
                                    //   latitude: savedLocationLat,
                                    //   longitude: savedLocationLon,
                                    // )
                                    ),
                              );
                            },
                            child: const DescriptionFont(
                              text: 'Register',
                              color: AppColors.primary,
                              size: 20,
                            ))
                      ],
                    ),
                  )));
  }
}
