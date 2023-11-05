import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:urban_restaurant/screens/login.dart';
import 'package:urban_restaurant/screens/reset_password_page.dart';
import 'package:urban_restaurant/widgets/bottom_nav_2.dart';
import 'package:flutter/material.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:provider/provider.dart';
import '../helpers/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../style/colors.dart';
import 'fetch_and_post.dart';

class Auth with ChangeNotifier {
  String? _token, pid, phone, uN;

  bool isLoading = false;

  final Map<String, String> _userData = {
    "userName": "",
    "firstName": "",
    "lastName": "",
    // "email": "",
    "password": "",
    "phone": "",
    "street": "",
    "city": "",
  };

  int timeout = 10;
  String backendUrl = 'https://esoora-backend-prod-qiymu.ondigitalocean.app';

  scaffoldMessage(context, String message, Color bkgrdClr) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      backgroundColor: bkgrdClr,
    ));
  }

  void loadingDialogue(context) {
    showDialog(
        useRootNavigator: false,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: const Dialog(
              backgroundColor: Colors.transparent,
              child: MoreLoadingGif(type: MoreLoadingGifType.ripple),
            ),
          );
        });
  }

  void loginEnforceDialogue(context, String title, bool signUp) {
    AwesomeDialog(
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      context: context,
      animType: AnimType.TOPSLIDE,
      headerAnimationLoop: false,
      dialogType: DialogType.SUCCES,
      showCloseIcon: false,
      title: title,
      desc: 'Please login to continue',
      btnOkOnPress: () {
        // Navigator.of(context).pop();
        if (signUp == true) {
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => LoginScreen()),
            ModalRoute.withName('/login'),
          );
        } else {
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => LoginScreen()),
            ModalRoute.withName('/login'),
          );
        }
      },
      btnOkColor: AppColors.primary,
      btnOkIcon: Icons.login,
      btnOkText: 'Login',
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  Future<void> _authenticate(context, String userName, String password,
      bool? restaurantRegister) async {
    loadingDialogue(context);
    final url = Uri.parse(
        '$backendUrl/public/authenticate'); //later use string interpolation for Login and Signup dynamically

    try {
      final jsonBody = json.encode(
        {
          "password": password,
          "userName": userName,
        },
      );
      final response = await http.post(
        url,
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: timeout));

      final responseData = json.decode(response.body); //print response.body
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      //newly added
      _token = responseData['token'];
      pid = responseData['pid'];
      uN = responseData['firstName'];
      phone = responseData['phone'];
      if (response.statusCode == 200) {
        //new added shared prefs
        final pref = await SharedPreferences.getInstance();
        await pref.setString('savedUserName', userName);
        await pref.setString('savedPassword', password);
        await pref.setString('userName', uN!);
        await pref.setString('userToken', _token!);
        await pref.setString('phoneNumber', phone!);
        await pref.setString('userId', pid!);
        Provider.of<Fetch>(context, listen: false).getCurrentLocation();
        String? savedLocationLat = pref.getString('savedLocationLat');
        String? savedLocationLon = pref.getString('savedLocationLon');
        if (restaurantRegister == true) {
          Navigator.of(context).pop();
          // Navigator.pushAndRemoveUntil<void>(
          //   context,
          //   MaterialPageRoute<void>(
          //       builder: (BuildContext context) => RestaurantRegistatrationPage(
          //             latitude: savedLocationLat,
          //             longitude: savedLocationLon,
          //           )),
          //   ModalRoute.withName('/bottomNav2'),
          // );
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => BottomNav2()));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => Container()
              // RestaurantRegistatrationPage(
              //   latitude: savedLocationLat,
              //   longitude: savedLocationLon,
              // ),
            ),
          );
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => BottomNav2()));
        }

        Flushbar(
          maxWidth: MediaQuery.of(context).size.width * 0.90,
          backgroundColor: Colors.green,
          flushbarPosition: FlushbarPosition.TOP,
          title: 'Success',
          message: 'Welcome ${responseData['firstName']}!',
          duration: const Duration(seconds: 3),
        ).show(context);
      } else if (response.statusCode == 500) {
        Navigator.of(context).pop();
        scaffoldMessage(
            context, 'Username or password is incorrect!', Colors.red);
      } else {
        Navigator.of(context).pop();
        scaffoldMessage(context,
            'Unexpected error occured! Please try again later.', Colors.red);
      }

      _token = responseData['token'];
      pid = responseData['pid'];
      _userData['firstName'] = responseData['firstName'];
      _userData['lastName'] = responseData['lastName'];
      _userData['userName'] = responseData['username'];
      _userData['phone'] = responseData['phone'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final savedUserData = json.encode(
        {
          'token': _token,
          'pid': pid,
          'firstName': _userData['firstName'],
          'lastName': _userData['lastName'],
          'userName': _userData['userName'],
          'phone': _userData['phone'],
          'street': _userData['street'],
          'city': _userData['city'],
        },
      );
      prefs.setString('savedUserData', savedUserData);
    } on TimeoutException {
      Navigator.of(context).pop();
      scaffoldMessage(
          context, 'Network is timedout please try again later', Colors.red);
    } on SocketException {
      Navigator.of(context).pop();
      scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          Colors.red);
    }
  }

  Future forgotPassword(context, String email) async {
    final url = Uri.parse('$backendUrl/public/forget-password');
    try {
      final jsonBody = json.encode(
        {
          "userName": email,
        },
      );
      final response = await http.post(
        url,
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: timeout));
      if (response.statusCode == 200) {
        scaffoldMessage(context,
            'We have sent a reset password code to your email!', Colors.green);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ResetPassword(
                  email: email,
                )));
      } else {
        scaffoldMessage(
            context, 'User with email provided is not found!', Colors.red);
      }
    } on TimeoutException {
      scaffoldMessage(
          context, 'Network is timedout please try again later', Colors.red);
    } on SocketException {
      scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          Colors.red);
    }
  }

  Future resetPassword(context, String email, password, token) async {
    final url = Uri.parse('$backendUrl/public/reset-password');
    try {
      final jsonBody =
          json.encode({"email": email, "token": token, "password": password});
      final response = await http.post(
        url,
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen()));
        scaffoldMessage(context, 'Password changed successfully', Colors.green);
      }
      if (response.statusCode == 404) {
        scaffoldMessage(
            context, 'Code is invalid! please try again.', Colors.red);
      }
    } on TimeoutException {
      scaffoldMessage(
          context, 'Network is timedout please try again later', Colors.red);
    } on SocketException {
      scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          Colors.red);
    }
  }

  Future<void> login(context, String userName, String password,
      bool? restaurantRegister) async {
    _authenticate(context, userName, password, restaurantRegister);
  }

  Future<void> logOut(context) async {
    Provider.of<Fetch>(context, listen: false).lisOfFavRestaurantId.clear();
    Provider.of<Fetch>(context, listen: false).lisOfFavFoodId.clear();
    _token = null;
    pid = null;
    Provider.of<Fetch>(context, listen: false).token = null;
    Provider.of<Fetch>(context, listen: false).pid = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
