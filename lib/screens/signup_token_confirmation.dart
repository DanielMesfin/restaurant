import 'dart:async';
import 'dart:io';

import 'package:urban_restaurant/screens/sign_up.dart';
import 'package:urban_restaurant/style/colors.dart';
import 'package:urban_restaurant/style/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class SignUpTokenConfirmationScreen extends StatefulWidget {
  final String email;
  const SignUpTokenConfirmationScreen({Key? key, required this.email})
      : super(key: key);
  static const routeName = '/signuptokenconfirmation';

  @override
  State<SignUpTokenConfirmationScreen> createState() =>
      _SignUpTokenConfirmationScreen();
}

class _SignUpTokenConfirmationScreen
    extends State<SignUpTokenConfirmationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController tokenController = TextEditingController();
  String backendUrl = 'https://esoora-backend-prod-qiymu.ondigitalocean.app';

  Future<void> emailTokenCheck(context) async {
    int timeout = 10;
    final url = Uri.parse(
        '$backendUrl/public/check-token?token=${tokenController.text}&email=${widget.email}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: timeout));

      // final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        Provider.of<Auth>(context, listen: false)
            .scaffoldMessage(context, 'Email Confirmed!', Colors.green);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => SignUp(
                  confirmedEmail: widget.email,
                )));
      }
      if (response.statusCode == 400) {
        Provider.of<Auth>(context, listen: false).scaffoldMessage(
            context, 'Token is incorrect! Please try again', Colors.red);
      }

      //notify and set prefs
    } on TimeoutException {
      Provider.of<Auth>(context, listen: false).scaffoldMessage(
          context, 'Network is timedout please try again later', Colors.red);
    } on SocketException {
      Provider.of<Auth>(context, listen: false).scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/delivery_background.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: AppColors.transparent,
          appBar: AppBar(
            backgroundColor: AppColors.transparent,
            elevation: 0,
            leading: const BackButton(),
          ),
          body: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    const SizedBox(
                      height: 40,
                    ),
                    // Container(
                    //     alignment: Alignment.center,
                    //     padding: const EdgeInsets.all(10),
                    //     child: const Text(
                    //       'Email confirmation required!',
                    //       style: TextStyle(fontSize: 15),
                    //     )),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const TitleFont(
                          text: 'Please enter the code you recieved!',
                          size: 20,
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: tokenController,
                        decoration: const InputDecoration(
                          // suffixIcon: Icon(Icons.mail),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: 'Code',
                        ),
                        // validator: (value) {
                        //   if (value!.isEmpty ||
                        //       !(RegExp(
                        //               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        //           .hasMatch(value.toString()))) {
                        //     return 'Invalid email address';
                        //   }
                        //   return null;
                        // },
                        onSaved: (value) {
                          tokenController.text = value.toString();
                        },
                      ),
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary),
                            child: const Text(
                              'Confirm',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                emailTokenCheck(context);
                              }
                            }
                            //  _submit,
                            )),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
