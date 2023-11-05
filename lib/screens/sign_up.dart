import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_restaurant/screens/login.dart';
import 'package:urban_restaurant/style/colors.dart';
import 'package:urban_restaurant/style/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/auth.dart';
import '../providers/fetch_and_post.dart';

class SignUp extends StatefulWidget {
  final String confirmedEmail;
  const SignUp({Key? key, required this.confirmedEmail}) : super(key: key);

  static const routeName = '/signup';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool _obscureText = true;
  String backendUrl = '';
  // String backendUrl = 'https://esoora-backend-prod-qiymu.ondigitalocean.app';

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> signup(
    context,
  ) async {
    Provider.of<Auth>(context, listen: false).loadingDialogue(context);
    int timeout = 10;
    final url = Uri.parse('$backendUrl/public/createUser');

    try {
      final jsonBody = json.encode(
        {
          "firstName": fNameController.text,
          "lastName": lNameController.text,
          "email": widget.confirmedEmail.replaceAll(' ', ''),
          "userPassword": passwordController.text,
          "phoneNumber": phoneController.text,
          "address": {
            "street": streetController.text,
            "city": cityController.text,
          },
        },
      );
      final response = await http.post(
        url,
        body: jsonBody,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: timeout));
      print(response.statusCode);

      final responseData = json.decode(response.body);
      print('$responseData');
      if (responseData['Phone'] == 'Email is used') {
        Navigator.of(context).pop();
        Provider.of<Fetch>(context, listen: false).scaffoldMessage(
            context, 'This email is already in use', Colors.red);
      }
      if (responseData['Phone is required'] ==
          'Phone number should be at least 10 digit') {
        Navigator.of(context).pop();
        Provider.of<Fetch>(context, listen: false).scaffoldMessage(
            context, 'This email is already in use', Colors.red);
      }
      // if (responseData['Phone'] == 'Phone number is used') {
      //   Navigator.of(context).pop();
      //   Provider.of<Fetch>(context, listen: false).scaffoldMessage(
      //       context, 'This phone number is already in use', Colors.red);
      // }

      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.of(context).pop();
        Provider.of<Auth>(context, listen: false)
            .loginEnforceDialogue(context, 'Signup Successful!', true);
      } else if (response.statusCode == 406) {
        print(widget.confirmedEmail);
        Navigator.of(context).pop();
        Provider.of<Fetch>(context, listen: false).scaffoldMessage(
            context, 'This phone number is already in use.', Colors.red);
      }

      //notify and set prefs
    } on TimeoutException {
      Navigator.of(context).pop();
      Provider.of<Auth>(context, listen: false).scaffoldMessage(
          context, 'Network is timedout please try again later', Colors.red);
    } on SocketException {
      Navigator.of(context).pop();
      Provider.of<Auth>(context, listen: false).scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        Provider.of<Fetch>(context, listen: false).willPopDialogue(context);
        return willLeave;
      },
      child: Stack(
        children: [
          // Image.asset(
          //   "assets/delivery_background.png",
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   fit: BoxFit.cover,
          // ),
          Scaffold(
            //backgroundColor: AppColors.transparent,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: AppColors.transparent,
              elevation: 0,
              title: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 30.w),
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
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    // color: Colors.orange.withOpacity(0.7),
                    borderRadius: BorderRadius.all(Radius.circular(18))),
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Info3Font(
                          //text: 'Registering with ${widget.confirmedEmail}',
                          text: "Register Here",
                          size: 18,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          maxLength: 20,
                          textCapitalization: TextCapitalization.sentences,
                          controller: fNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            // suffixIcon: Icon(Icons.person),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelText: 'First Name',
                          ),
                          validator: (val) {
                            if (val.toString().isEmpty) {
                              return 'First name is required';
                            }

                            if (!(RegExp(r"^[a-zA-Z ]*$")
                                .hasMatch(val.toString()))) {
                              return 'Invalid Name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            fNameController.text = value.toString();
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          maxLength: 20,
                          textCapitalization: TextCapitalization.sentences,
                          controller: lNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            // suffixIcon: Icon(Icons.person),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelText: 'Last Name',
                          ),
                          validator: (val) {
                            if (val.toString().isEmpty) {
                              return 'Last name is required';
                            }
                            if (!(RegExp(r"^[a-zA-Z ]*$")
                                .hasMatch(val.toString()))) {
                              return 'Invalid Name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            lNameController.text = value.toString();
                          },
                        ),
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
                        height: 8.h,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelText: 'Phone',
                            // prefixIcon: Icon(Icons.phone_android, size: 20)
                          ),
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val.toString().isEmpty) {
                              return 'Phone number is required';
                            }
                            if (!RegExp(r"^(?:[+0]9)?[0-9]{10}$")
                                .hasMatch(val.toString())) {
                              return 'invalid phone number'; //find another consistent way
                            }
                            return null;
                          },
                          onSaved: (val) {
                            phoneController.text = val.toString();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          maxLength: 30,
                          textCapitalization: TextCapitalization.sentences,
                          controller: streetController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelText: 'Street',
                            // prefixIcon: Icon(Icons.add_road_rounded, size: 20),
                          ),
                          validator: (val) {
                            if (val.toString().isEmpty) {
                              return 'Street is required';
                            }
                            if (!(RegExp(r"^[a-zA-Z 0-9]*$")
                                .hasMatch(val.toString()))) {
                              return 'Invalid Street';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            streetController.text = value.toString();
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          maxLength: 20,
                          textCapitalization: TextCapitalization.sentences,
                          controller: cityController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelText: 'City',
                            // prefixIcon: Icon(Icons.location_city, size: 20),
                          ),
                          validator: (val) {
                            if (val.toString().isEmpty) {
                              return 'City is required';
                            }
                            if (!(RegExp(r"^[a-zA-Z 0-9]*$")
                                .hasMatch(val.toString()))) {
                              return 'Invalid City';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            cityController.text = value.toString();
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          obscureText: _obscureText,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                                onPressed: _toggle,
                                icon: _obscureText
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off)),
                            // suffixIcon: Icon(Icons.lock),
                            enabledBorder: const OutlineInputBorder(
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
                        height: 8.h,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          obscureText: _obscureText,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            // suffixIcon: Icon(Icons.lock),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelText: 'Confirm Password',
                          ),
                          validator: (value) {
                            if (value != passwordController.text) {
                              return 'Passwords do not match!';
                            } else if (value!.isEmpty) {
                              return 'Confirm Password can\'t be empty!';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary),
                              child: const InfoFont(
                                text: 'Sign Up',
                                size: 20,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  signup(context);
                                }
                              })),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Info2Font(text: 'Already have an account?'),
                          TextButton(
                            child: const Poppins(
                              text: 'Login',
                              color: AppColors.tertiary,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
