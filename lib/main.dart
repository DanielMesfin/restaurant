import 'package:urban_restaurant/providers/fetch_and_post.dart';
import 'package:urban_restaurant/screens/home.dart';
import 'package:urban_restaurant/screens/login.dart';
import 'package:urban_restaurant/screens/splash_screen.dart';
import 'package:urban_restaurant/style/colors.dart';
import 'package:urban_restaurant/widgets/bottom_nav_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:firebase_core/firebase_core.dart';

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: const FirebaseOptions(
//         apiKey: "AIzaSyANji_JOiJkGf9CiTLc8c45MdTxIp1kfZ8",
//         appId: "com.ethioclicks.esoora_food_delivery",
//         messagingSenderId: "723300209225",
//         projectId: "esoora-food-delivery",
//         storageBucket: "esoora-food-delivery.appspot.com"),
//   );
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]);
//   HttpOverrides.global = MyHttpOverrides();
//   runApp(const MyApp());
// }

// these was the update part of code
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: Auth(),
              ),
              ChangeNotifierProvider.value(
                value: Fetch(),
              ),
            ],
            child: Consumer(
              builder: (ctx, auth, _) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Urban Restaurant',
                theme: ThemeData(
                    primaryColor: AppColors.primary,
                    primarySwatch: Colors.orange),
                home: const SplashScreen(),
                routes: {
                  LoginScreen.routeName: (ctx) => LoginScreen(),
                  Home.routeName: (ctx) => const Home(),
                  SplashScreen.routeName: (ctx) => const SplashScreen(),
                  BottomNav2.routeName: (ctx) => BottomNav2(),
                },
              ),
            ),
          );
        });
  }
}
