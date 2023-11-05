import 'dart:async';

import 'package:urban_restaurant/models/user_info_model.dart';
import 'package:urban_restaurant/screens/login.dart';
import 'package:urban_restaurant/style/colors.dart';
import 'package:urban_restaurant/style/style.dart';
import 'package:urban_restaurant/widgets/error_messages.dart';
import 'package:urban_restaurant/widgets/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth.dart';
import '../../providers/fetch_and_post.dart';
import '../widgets/shimmer_loading.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  // late UserInfoModel userInfo;
  Future<UserInfoModel>? userInfo;

  // String? token;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    Provider.of<Fetch>(context, listen: false).checkLogin();
    _checkLogin();
    super.initState();
  }

  void _checkLogin() {
    Provider.of<Fetch>(context, listen: false).checkLogin();
    if (Provider.of<Fetch>(context, listen: false).token != null &&
        Provider.of<Fetch>(context, listen: false).pid != null) {
      userInfo =
          Provider.of<Fetch>(context, listen: false).fetchUserDetail(context);
    }
  }

  onRefresh() {
    _checkLogin();
    setState(() {});
  }

  Widget logoutButton() {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Provider.of<Auth>(context, listen: false).logOut(context);
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => LoginScreen()),
          ModalRoute.withName('/login'),
        );
      },
      child: const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.logout),
            TitleFont(
              text: 'Logout',
              size: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget body(UserInfoModel data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          const Center(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: TitleFont(
                    text: 'Profile',
                    size: 30,
                    color: AppColors.primary,
                  ))),
          Center(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Info2Font(
                      color: AppColors.grey,
                      text: 'Name',
                    ),
                    const SizedBox(height: 1),
                    Container(
                        width: 350,
                        height: 30,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ))),
                        child: Row(children: [
                          Align(
                              // alignment: Alignment.topLeft,
                              alignment: Alignment.topCenter,
                              child: Info4Font(
                                text: '${data.firstName} ${data.lastName}',
                                color: AppColors.black,
                                size: 17,
                              )),
                        ])),
                    const SizedBox(
                      height: 15,
                    ),
                    const Info2Font(
                      text: 'Email',
                      color: AppColors.grey,
                    ),
                    const SizedBox(height: 1),
                    Container(
                        width: 350,
                        height: 30,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ))),
                        child: Row(children: [
                          Align(
                              // alignment: Alignment.topLeft,
                              alignment: Alignment.topCenter,
                              child: Info4Font(
                                text: data.email,
                                size: 17,
                                color: AppColors.black,
                              )),
                        ])),
                    const SizedBox(
                      height: 15,
                    ),
                    const Info2Font(
                      text: 'Phone',
                      color: AppColors.grey,
                    ),
                    const SizedBox(height: 1),
                    Container(
                        width: 350,
                        height: 30,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ))),
                        child: Row(children: [
                          Align(
                              // alignment: Alignment.topLeft,
                              alignment: Alignment.topCenter,
                              child: Info4Font(
                                text: data.phoneNumber,
                                size: 17,
                                color: AppColors.black,
                              )),
                        ])),
                    const SizedBox(
                      height: 15,
                    ),
                    const Info2Font(
                      text: 'Adress',
                      color: AppColors.grey,
                    ),
                    const SizedBox(height: 1),
                    Container(
                        width: 350,
                        height: 30,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ))),
                        child: Row(children: [
                          Align(
                              // alignment: Alignment.topLeft,
                              alignment: Alignment.topCenter,
                              child: Info4Font(
                                text:
                                    '${data.address.street} ${data.address.city}',
                                color: AppColors.black,
                                size: 17,
                              )),
                        ])),
                  ],
                )),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (Provider.of<Fetch>(context, listen: false).token != null &&
        Provider.of<Fetch>(context, listen: false).pid != null) {
      return FutureBuilder<UserInfoModel>(
          future: userInfo,
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
                  onLogout: logoutButton(),
                  msg: unreachableMsg,
                );
              } else if ('$error' == timedOutMsg) {
                return ErrorMessages(
                  onRefresh: onRefresh,
                  onLogout: logoutButton(),
                  msg: timedOutMsg,
                );
              } else if ('$error' == ueMsg) {
                return ErrorMessages(
                  onRefresh: onRefresh,
                  onLogout: logoutButton(),
                  msg: ueMsg,
                );
              }
            }
            if (snapshot.hasData) {
              UserInfoModel? data = snapshot.data;
              return Scaffold(
                  endDrawer: NavDrawer(
                    data: data,
                    onClicked: onGoBack,
                    logout: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      Provider.of<Auth>(context, listen: false).logOut(context);
                      Navigator.pushAndRemoveUntil<void>(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => LoginScreen()),
                        ModalRoute.withName('/login'),
                      );
                    },
                  ),
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                    elevation: 0,
                  ),
                  body: body(data!));
            }
            return const ShimmerLoading(
              detail: false,
              home: false,
              homeA: false,
              foodCard: false,
              search: false,
              favorite: false,
              profile: true,
            );
          });
    } else {
      return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            elevation: 0,
            title: Row(
              children: [
                TextButton(
                  onPressed: () {
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
          ),
          body: Center(
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
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
          ));
    }
  }

  FutureOr onGoBack(dynamic value) {
    onRefresh();
  }
}
