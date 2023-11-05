import 'dart:async';

import 'package:urban_restaurant/screens/user_restaurants_list.dart';
import 'package:urban_restaurant/style/colors.dart';
import 'package:urban_restaurant/style/style.dart';
import 'package:flutter/material.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:provider/provider.dart';

import '../models/user_info_model.dart';
import '../models/users_registered_restaurants.dart';
import '../providers/fetch_and_post.dart';
import '../screens/edit_user_details.dart';

class NavDrawer extends StatefulWidget {
  final UserInfoModel? data;
  final FutureOr<dynamic> Function(dynamic) onClicked;
  final VoidCallback logout;
  const NavDrawer(
      {Key? key,
      required this.data,
      required this.onClicked,
      required this.logout})
      : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  Future<List<UsersRegisteredRestaurants>>? list;

  @override
  void initState() {
    super.initState();
    list = Provider.of<Fetch>(context, listen: false)
        .userRegisteredRestaurants(context);
  }

  Widget trailing(AsyncSnapshot<List<UsersRegisteredRestaurants>> snapshot) {
    if (snapshot.hasData) {
      List<UsersRegisteredRestaurants>? data = snapshot.data;
      return TitleFont(text: '(${data!.length.toString()})');
    } else if (snapshot.hasError) {
      return const TitleFont(text: 'Error!');
    }
    return const SizedBox(
        height: 20, child: MoreLoadingGif(type: MoreLoadingGifType.ellipsis));
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<List<UsersRegisteredRestaurants>>(
        future: list,
        builder: (context, snapshot) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          deviceWidth > 380
                              ? const Expanded(
                                  flex: 2,
                                  child: CircleAvatar(
                                    backgroundColor: AppColors.secondary,
                                    radius: 40,
                                    backgroundImage:
                                        AssetImage('assets/esoora_logo.png'),
                                  ),
                                )
                              : Container(),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 6,
                            child: TitleFont(
                              text: 'Hi ${widget.data!.firstName}',
                              color: AppColors.black,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                      title: const Poppins(
                        text: 'Your Restaurants',
                        fontWeight: FontWeight.w500,
                        size: 15,
                      ),
                      leading: const Icon(Icons.restaurant),
                      onTap: () {
                        if (snapshot.hasData) {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  UserRestaurantsList(
                                    data: snapshot.data,
                                  )));
                        }
                      },
                      trailing: trailing(snapshot)),
                  const Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    title: const Poppins(
                      text: 'Edit Profile',
                      fontWeight: FontWeight.w500,
                      size: 15,
                    ),
                    leading: const Icon(Icons.account_circle),
                    onTap: () {
                      Navigator.of(context).pop();
                      Route route = MaterialPageRoute(
                          builder: (context) => EditUserDetails(
                              userPublicId: widget.data!.userPublicId,
                              firstName: widget.data!.firstName,
                              lastName: widget.data!.lastName,
                              phoneNumber: widget.data!.phoneNumber,
                              userPassword: widget.data!.userPassword,
                              email: widget.data!.email,
                              street: widget.data!.address.street,
                              city: widget.data!.address.city,
                              addressId: widget.data!.address.id));
                      Navigator.push(context, route).then(widget.onClicked);
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (BuildContext context) => profile()));
                    },
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    title: const Poppins(
                      text: 'Logout',
                      fontWeight: FontWeight.w500,
                      size: 15,
                    ),
                    leading: const Icon(Icons.logout),
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.logout();
                      // Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (BuildContext context) => contact()));
                    },
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: deviceWidth > 380
                        ? MediaQuery.of(context).size.height * 0.3
                        : MediaQuery.of(context).size.height * 0.1,
                  ),
                  // const Align(
                  //   child: Info4Font(
                  //       text: 'Version 0.1.0+7 (internal tester copy)'),
                  //   alignment: Alignment.center,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Provider.of<Fetch>(context, listen: false)
                              .aboutDialogue(context);
                        },
                        child: const TitleFont(
                          text: 'About',
                          color: AppColors.primary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Provider.of<Fetch>(context, listen: false)
                              .contactDialogue(context);
                        },
                        child: const TitleFont(
                          text: 'Contact Us',
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
