import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:urban_restaurant/screens/signup_token_confirmation.dart';
import 'package:urban_restaurant/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../style/style.dart';

class PreSignupScreen extends StatefulWidget {
  const PreSignupScreen({Key? key}) : super(key: key);
  static const routeName = '/presignupscreen';

  @override
  State<PreSignupScreen> createState() => _PreSignupScreen();
}

class _PreSignupScreen extends State<PreSignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  String backendUrl = 'https://esoora-backend-prod-qiymu.ondigitalocean.app';

  Future<void> emailVerificationCodeRequest(context) async {
    int timeout = 10;
    final url = Uri.parse('$backendUrl/public/send-email-conformation');

    try {
      final jsonBody = json.encode(
        {
          "userName": emailController.text,
        },
      );
      final response = await http.post(
        url,
        body: jsonBody,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: timeout));

      // final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        Provider.of<Auth>(context, listen: false)
            .scaffoldMessage(context, 'Confirmation email sent!', Colors.green);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => SignUpTokenConfirmationScreen(
                  email: emailController.text,
                )));
      }
      if (response.statusCode == 409) {
        Provider.of<Auth>(context, listen: false).scaffoldMessage(
            context,
            'Your Email address already exists! Please use another email!',
            Colors.red);
      }

      //notify and set prefs
    } on TimeoutException {
      Provider.of<Auth>(context, listen: false).scaffoldMessage(
          context, 'Network is timedout please try again later!', Colors.red);
    } on SocketException {
      Provider.of<Auth>(context, listen: false).scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection!',
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
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const TitleFont(
                          text: 'Email confirmation required!',
                          size: 15,
                        )),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const TitleFont(
                          text: 'Please enter your email below',
                          size: 20,
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          // suffixIcon: Icon(Icons.mail),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value!.isEmpty ||
                              !(RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value.toString()))) {
                            return 'Invalid email address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          emailController.text = value.toString();
                        },
                      ),
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary),
                            child: const InfoFont(
                              text: 'Send request',
                              size: 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                emailVerificationCodeRequest(context);
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
