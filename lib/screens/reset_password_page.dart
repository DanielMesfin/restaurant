import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../style/colors.dart';
import '../style/style.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  const ResetPassword({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
              title: const Text('Reset Password'),
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
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const TitleFont(
                          text:
                              'Please enter the code we sent to your email and enter new password!',
                          size: 15,
                          fontWeight: FontWeight.w500,
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: codeController,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: 'Code',
                        ),
                        validator: (val) {
                          if (val.toString().isEmpty) {
                            return 'Code is required';
                          }

                          if (val.toString().characters.length < 6) {
                            return 'Characters should be more than five';
                          }

                          // if (!(RegExp(r"^[a-zA-Z 1-9]*$")
                          //     .hasMatch(val.toString()))) {
                          //   return 'Invalid pin';
                          // }
                          return null;
                        },
                        onSaved: (value) {
                          codeController.text = value.toString();
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        obscureText: _obscureText,
                        controller: passwordController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: _toggle,
                              icon: _obscureText
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off)),
                          enabledBorder: const UnderlineInputBorder(
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
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                          obscureText: _obscureText,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelText: 'Repeat Password',
                          ),
                          validator: (value) {
                            if (value != passwordController.text) {
                              return 'Passwords do not match!';
                            } else if (value!.isEmpty) {
                              return 'Confirm Password can\'t be empty!';
                            } else {
                              return null;
                            }
                          }),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Provider.of<Auth>(context, listen: false)
                                .resetPassword(
                                    context,
                                    widget.email,
                                    passwordController.text,
                                    codeController.text);
                          }
                        },
                        child: const InfoFont(
                          text: 'Done',
                          size: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
