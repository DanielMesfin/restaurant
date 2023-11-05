import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:urban_restaurant/providers/auth.dart';
import 'package:urban_restaurant/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../providers/fetch_and_post.dart';
import '../widgets/bottom_nav_2.dart';
import 'package:app_settings/app_settings.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  String? savedUserName, savedPassword;
  final Location location = Location();
  PermissionStatus? permissionGranted;
  String backendUrl = 'https://esoora-backend-prod-qiymu.ondigitalocean.app';

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  Future<void> checkPermission() async {
    final PermissionStatus permissionGrantedResult =
        await location.hasPermission();
    setState(() {
      permissionGranted = permissionGrantedResult;
    });
  }

  Future<void> requestPermission() async {
    if (permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      setState(() {
        permissionGranted = permissionRequestedResult;
      });
      setState(() {});
    }
    setState(() {});
    if (permissionGranted == PermissionStatus.granted) {
      Provider.of<Fetch>(context, listen: false).getCurrentLocation();
      autoLogin(context);
    }
    if (permissionGranted == PermissionStatus.denied) {
      AwesomeDialog(
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        context: context,
        animType: AnimType.TOPSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.INFO,
        showCloseIcon: false,
        title: 'Location access',
        desc: 'Allow location access to continue?',
        btnOkOnPress: () async {
          requestPermission();
          setState(() {});
        },
        btnOkIcon: Icons.check_circle,
        btnOkText: 'Ok',
        btnCancelOnPress: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        btnCancelIcon: Icons.cancel,
        btnCancelText: 'Cancel',
        onDismissCallback: (type) {
          debugPrint('Dialog Dissmiss from callback $type');
        },
      ).show();
    }
    if (permissionGranted == PermissionStatus.deniedForever) {
      AwesomeDialog(
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        context: context,
        animType: AnimType.TOPSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.INFO,
        showCloseIcon: false,
        title: 'Location access',
        desc: 'Allow location access to continue?',
        btnOkOnPress: () async {
          // requestPermission();
          AppSettings.openLocationSettings();
          setState(() {});
          // if (permissionGranted == PermissionStatus.granted) {
          //   Provider.of<Fetch>(context, listen: false).getCurrentLocation();
          //   autoLogin(context);
          // } else {
          //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          // }
        },
        btnOkIcon: Icons.check_circle,
        btnOkText: 'Ok',
        btnCancelOnPress: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        btnCancelIcon: Icons.cancel,
        btnCancelText: 'Cancel',
        onDismissCallback: (type) {
          debugPrint('Dialog Dissmiss from callback $type');
        },
      ).show();
    }
    setState(() {});
  }

  void startTimer() {
    Timer(const Duration(seconds: 2), () async {
      checkPermission();
      await requestPermission();
      setState(() {});
      if (permissionGranted == PermissionStatus.granted) {
        Provider.of<Fetch>(context, listen: false).getCurrentLocation();
        // _authenticate(context);
        autoLogin(context);
      } else {
        AwesomeDialog(
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
          context: context,
          animType: AnimType.TOPSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.INFO,
          showCloseIcon: false,
          title: 'Location access',
          desc: 'Allow location access to continue?',
          btnOkOnPress: () async {
            requestPermission();
          },
          btnOkIcon: Icons.check_circle,
          btnOkText: 'Ok',
          btnCancelOnPress: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          btnCancelIcon: Icons.cancel,
          btnCancelText: 'Cancel',
          onDismissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          },
        ).show();
      }
      setState(() {});
    });
  }

  Future autoLogin(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    savedUserName = pref.getString('savedUserName');
    savedPassword = pref.getString('savedPassword');
    if (savedUserName != null && savedPassword != null) {
      await _authenticate(context);
    } else {
      final prefs = await SharedPreferences.getInstance();
      //prefs need to be cleared after failed login
      prefs.clear(); //new addition
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
  }

  Future<void> _authenticate(context) async {
    final pref = await SharedPreferences.getInstance();
    final url = Uri.parse('$backendUrl/public/authenticate');
    try {
      final jsonBody = json.encode(
        {
          "password": savedPassword,
          "userName": savedUserName,
        },
      );
      final response = await http.post(
        url,
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = json.decode(response.body);
      // final prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        pref.remove('userToken');
        pref.remove('userId');
        String token = responseData['token'];
        String pid = responseData['pid'];
        String uN = responseData['username'];
        await pref.setString('userName', uN);
        await pref.setString('userToken', token);
        await pref.setString('userId', pid);
        Navigator.of(context).pushReplacementNamed(BottomNav2.routeName);
      } else {
        //prefs need to be cleared after failed login
        Provider.of<Auth>(context, listen: false)
            .logOut(context); //new addition
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      }
    } on TimeoutException {
      Provider.of<Fetch>(context, listen: false).scaffoldMessage(
          context, 'Network is timedout! please try again.', Colors.red);
      Provider.of<Auth>(context, listen: false).logOut(context);
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    } on SocketException {
      Provider.of<Fetch>(context, listen: false).scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          Colors.red);
      Provider.of<Auth>(context, listen: false).logOut(context);
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    } on Error {
      Provider.of<Fetch>(context, listen: false)
          .scaffoldMessage(context, 'Error Occured!', Colors.red);
      Provider.of<Auth>(context, listen: false).logOut(context);
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
  }

  // void navigateUser() async {
  //   // Provider.of<Fetch>(context, listen: false).checkLogin(context);
  //   Navigator.of(context).pushReplacementNamed(BottomNav2.routeName);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/esoora_logo.png"),
                fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
