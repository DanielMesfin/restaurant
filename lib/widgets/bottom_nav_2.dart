import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:urban_restaurant/providers/fetch_and_post.dart';
import 'package:urban_restaurant/screens/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../screens/home.dart';
import '../screens/profile_page.dart';
import '../style/colors.dart';

class BottomNav2 extends StatefulWidget {
  bool? restaurantRegistered = false;
  static const routeName = '/bottomNav2';
  BottomNav2({Key? key, this.restaurantRegistered}) : super(key: key);

  @override
  State<BottomNav2> createState() => _BottomNav2State();
}

class _BottomNav2State extends State<BottomNav2> {
  int _currentIndex = 0;
  List<Widget> pages = [
    const Home(
        // key: PageStorageKey('Home'),
        ),
    // const RestaurantList(
    //     // key: PageStorageKey('Restaurants'),
    //     ),
    const FavoritesScreen(
        // key: PageStorageKey('Favorites'),
        ),
    const ProfilePage(
        // key: PageStorageKey('Profile'),
        ),
  ];

  // final PageStorageBucket bucket = PageStorageBucket();
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    Provider.of<Fetch>(context, listen: false).checkLogin();
    if (Provider.of<Fetch>(context, listen: false).pid != null &&
        Provider.of<Fetch>(context, listen: false).token != null) {
      Provider.of<Fetch>(context, listen: false).fetchUserDetail(context);
    }

    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController!.dispose();
  }

  _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    pageController!.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.INFO,
          showCloseIcon: true,
          title: 'Are you sure want to leave?',
          desc: 'Exit App?!',
          btnOkOnPress: () {
            willLeave = true;
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          btnCancelColor: AppColors.secondary,
          btnOkColor: AppColors.primary,
          btnOkIcon: Icons.check,
          btnOkText: 'Confirm',
          btnCancelOnPress: () {},
          btnCancelIcon: Icons.cancel,
          btnCancelText: 'Cancel',
          onDismissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          },
        ).show();

        return willLeave;
      },
      child: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: pages,
        ),
        bottomNavigationBar: NavigationBar(
          height: MediaQuery.of(context).size.height * 0.08,
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTapped,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home,
                color: Colors.green,
              ),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            // NavigationDestination(
            //   selectedIcon: Icon(
            //     Icons.restaurant,
            //     color: Color.fromARGB(255, 156, 141, 3),
            //   ),
            //   icon: Icon(Icons.restaurant_outlined),
            //   label: 'Restaurant List',
            // ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              icon: Icon(
                Icons.favorite_outline,
              ),
              label: 'Favorites',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              icon: Icon(Icons.person_outlined),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
