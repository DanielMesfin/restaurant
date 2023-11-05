import 'package:urban_restaurant/providers/auth.dart';
import 'package:urban_restaurant/screens/pre_signup_validation.dart';
import 'package:urban_restaurant/style/colors.dart';
import 'package:urban_restaurant/style/style.dart';
import 'package:urban_restaurant/widgets/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/bottom_nav_2.dart';
import 'forgot_password.dart';
import 'sign_up.dart';
import 'user_screen.dart';
import 'owner_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  bool? restaurantRegister = false;
  LoginScreen({Key? key, this.restaurantRegister}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  String? _selectedRole = '';
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void privacyDialogue() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: SizedBox(
                // width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.80,
                child: const PrivacyPolicy(),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // Image.asset(
        //   deviceWidth > 380
        //       ? "assets/esoora_background.png"
        //       : 'assets/delivery_background.png',
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   fit: BoxFit.cover,
        // ),
        Scaffold(
          //backgroundColor: AppColors.transparent,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const CircleAvatar(
              backgroundColor: AppColors.transparent,
              backgroundImage: AssetImage('assets/ethioclickslogo.png'),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Row(
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     privacyDialogue();
                  //   },
                  //   child: Info3Font(
                  //     text: 'Privacy policy',
                  //     size: 10.w,
                  //     color: AppColors.secondary,
                  //   ),
                  // )
                ],
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(10.w),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.only(top: 30.h),
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const TitleFont(
                      text: 'Urban Restaurant',
                      shadows: [
                        Shadow(
                          color: Colors.red,
                          offset: Offset(2, 2),
                          blurRadius: 3,
                        ),
                        Shadow(
                          color: Colors.orange,
                          offset: Offset(-2, 2),
                          blurRadius: 3,
                        ),
                        Shadow(
                          color: AppColors.primary,
                          offset: Offset(2, -2),
                          blurRadius: 3,
                        ),
                      ],
                      size: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Info3Font(
                      //text: 'Registering with ${widget.confirmedEmail}',
                      text: "Log In Here",
                      size: 18,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !(RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value.toString()))) {
                          return 'Invalid email address!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        emailController.text = value.toString();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      obscureText: _obscureText,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: _toggle,
                            icon: _obscureText
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off)),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Password is too short!';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        passwordController.text = value.toString();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: RadioListTile(
                          title:
                              Text('Owner', style: TextStyle(fontSize: 16.sp)),
                          value: 'Owner',
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: Text('Customer',
                              style: TextStyle(fontSize: 16.sp)),
                          value: 'Customer',
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      _selectedRole != null ? "" : "Please Select your role",
                      style: const TextStyle(fontSize: 14.0, color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                      height: 50.h,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary),
                        child: const InfoFont(
                          text: 'Login',
                          size: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                        onPressed: () {
                          //    if (_formKey.currentState!.validate()) {
                          if (_formKey.currentState!.validate()) {
                            //    if (_formKey.currentState!.validate()) {
                            //   Provider.of<Auth>(context, listen: false).login(
                            //       context,
                            //       emailController.text,
                            //       passwordController.text,
                            //       widget.restaurantRegister);
                            // }
                            if (_selectedRole == 'Customer') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserScreen(),
                                ),
                              );
                            } else if (_selectedRole == 'Owner') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OwnerScreen(),
                                ),
                              );
                            } else {
                              setState(() {
                                _selectedRole = null;
                              });
                              print('Role is Mandatory');
                            }
                          }
                        },
                      )),
                  SizedBox(
                    height: 30.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {},
                        // onPressed: () => Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (context) => const ForgotPassword())),
                        child: const Poppins(
                          fontWeight: FontWeight.w500,
                          text: 'Forgot password',
                          color: AppColors.red,
                        ),
                      ),
                      Info2Font(
                        text: 'Do not have account?',
                        size: 10.sp,
                      ),
                      TextButton(
                        child: Poppins(
                          text: 'Sign Up',
                          color: AppColors.tertiary,
                          size: 18.sp,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              // builder: (context) => const PreSignupScreen(),
                              builder: (context) => SignUp(
                                  confirmedEmail: "danielmesfin331@gmail.com"),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.of(context)
                  //         .pushReplacementNamed(BottomNav2.routeName);
                  //   },
                  //   child: const Poppins(
                  //     text: 'Continue without an account',
                  //     color: AppColors.grey,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
