import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:urban_restaurant/style/colors.dart';
import 'package:urban_restaurant/style/style.dart';
import 'package:urban_restaurant/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_info_model.dart';
import '../providers/fetch_and_post.dart';

// ignore: must_be_immutable
class EditUserDetails extends StatefulWidget {
  String userPublicId,
      firstName,
      lastName,
      phoneNumber,
      userPassword,
      email,
      street,
      city;
  int? addressId;
  EditUserDetails(
      {Key? key,
      required this.userPublicId,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.userPassword,
      required this.email,
      required this.street,
      required this.city,
      required this.addressId})
      : super(key: key);

  @override
  State<EditUserDetails> createState() => _EditUserDetailsState();
}

class _EditUserDetailsState extends State<EditUserDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKey1 = GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController phoneController = TextEditingController();
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  Address? address;
  String? savedPassword;
  bool _obscureText = true, disabledButton = true;
  String backendUrl = 'https://esoora-backend-prod-qiymu.ondigitalocean.app';

  @override
  void initState() {
    _retreavePassword();
    super.initState();
    nameController.text = widget.firstName;
    lNameController.text = widget.lastName;
    // phoneController.text = widget.phoneNumber
    streetAddressController.text = widget.street;
    cityController.text = widget.city;
  }

  onRefresh() {
    _retreavePassword();
    nameController.text = widget.firstName;
    lNameController.text = widget.lastName;
    // phoneController.text = widget.phoneNumber
    streetAddressController.text = widget.street;
    cityController.text = widget.city;
    setState(() {});
  }

  Future _retreavePassword() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    savedPassword = pref.getString('savedPassword');
  }

  Future editProfile() async {
    final url = Uri.parse('$backendUrl/user');

    try {
      final jsonBody = json.encode(UserInfoModel(
          userPublicId: widget.userPublicId,
          firstName: nameController.text,
          lastName: lNameController.text,
          phoneNumber: widget.phoneNumber,
          userPassword: widget.userPassword,
          email: widget.email,
          address: Address(
              id: widget.addressId,
              street: streetAddressController.text,
              city: cityController.text)));
      final response = await http.post(
        url,
        body: jsonBody,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              ' Bearer ${Provider.of<Fetch>(context, listen: false).token}',
          'pid': '${Provider.of<Fetch>(context, listen: false).pid}',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Provider.of<Fetch>(context, listen: false).scaffoldMessage(
            context, 'Profile updated successfully!', Colors.green);
      } else {
        Provider.of<Fetch>(context, listen: false).scaffoldMessage(
            context,
            'We are not able to process your request at this time!',
            Colors.red);
      }
    } on TimeoutException {
      Provider.of<Fetch>(context, listen: false).scaffoldMessage(
          context, 'Network is timedout! please try again.', Colors.red);
    } on SocketException {
      Provider.of<Fetch>(context, listen: false).scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          Colors.red);
    } on Error {
      Provider.of<Fetch>(context, listen: false)
          .scaffoldMessage(context, 'Error Occured!', Colors.red);
    }
  }

  dynamic _toggle(setState) {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  changePasswordModal() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return AlertDialog(
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.39,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey1,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: TextFormField(
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      _toggle(setState);
                                    },
                                    icon: _obscureText
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off)),
                                // suffixIcon: Icon(Icons.lock),
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                labelText: 'Enter Current Password',
                              ),
                              validator: (value) {
                                if (value!.isEmpty || value.length < 6) {
                                  return 'Password is too short!';
                                } else if (value != savedPassword) {
                                  return 'Your current password is not correct!';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: TextFormField(
                              obscureText: _obscureText,
                              // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              controller: newPasswordController,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      _toggle(setState);
                                    },
                                    icon: _obscureText
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off)),
                                // suffixIcon: Icon(Icons.lock),
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                labelText: 'New Password',
                              ),
                              validator: (value) {
                                if (value!.isEmpty || value.length < 6) {
                                  return 'Password is too short!';
                                } else if (value == savedPassword) {
                                  return 'New password can not be the same as the old';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                newPasswordController.text = value.toString();
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: TextFormField(
                              obscureText: _obscureText,
                              decoration: const InputDecoration(
                                // suffixIcon: Icon(Icons.lock),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                labelText: 'Confirm New Password',
                              ),
                              validator: (value) {
                                if (value != newPasswordController.text) {
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
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: FractionallySizedBox(
                              widthFactor: 1,
                              child: ButtonWidget(
                                  text: 'Change Password',
                                  onClicked: () {
                                    if (_formKey1.currentState!.validate()) {
                                      Provider.of<Fetch>(context, listen: false)
                                          .changeUserPassword(
                                              context,
                                              widget.email,
                                              newPasswordController.text);
                                    }
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
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
            backgroundColor: AppColors.transparent,
            elevation: 0,
            leading: const BackButton(),
            title: const TitleFont(text: 'Edit Profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: TextFormField(
                        maxLength: 20,
                        controller: nameController,
                        decoration: const InputDecoration(
                          // suffixIcon: Icon(Icons.business),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: 'Name',
                        ),
                        validator: (val) {
                          if (val.toString().isEmpty) {
                            return 'Name is required';
                          }

                          if (!(RegExp(r"^[a-zA-Z 1-9 ',]*$")
                              .hasMatch(val.toString()))) {
                            return 'Invalid Name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          nameController.text = value.toString();
                        },
                        onChanged: (value) {
                          setState(() {
                            disabledButton = false;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: TextFormField(
                        maxLength: 20,
                        controller: lNameController,
                        decoration: const InputDecoration(
                          // suffixIcon: Icon(Icons.business),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: 'Last Name',
                        ),
                        validator: (val) {
                          if (val.toString().isEmpty) {
                            return 'Last Name is required';
                          }

                          if (!(RegExp(r"^[a-zA-Z 1-9 ',]*$")
                              .hasMatch(val.toString()))) {
                            return 'Invalid last name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          lNameController.text = value.toString();
                        },
                        onChanged: (value) {
                          setState(() {
                            disabledButton = false;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: TextFormField(
                        maxLength: 30,
                        controller: streetAddressController,
                        decoration: const InputDecoration(
                          // suffixIcon: Icon(Icons.add_road_rounded),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: 'Street address',
                        ),
                        validator: (val) {
                          if (val.toString().isEmpty) {
                            return 'Street address is required';
                          }

                          if (!(RegExp(r"^[a-zA-Z 0-9 ,']*$")
                              .hasMatch(val.toString()))) {
                            return 'Invalid Address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          streetAddressController.text = value.toString();
                        },
                        onChanged: (value) {
                          setState(() {
                            disabledButton = false;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: TextFormField(
                        maxLength: 20,
                        controller: cityController,
                        decoration: const InputDecoration(
                          // suffixIcon: Icon(Icons.location_city),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: 'City',
                        ),
                        validator: (val) {
                          if (val.toString().isEmpty) {
                            return 'City is required';
                          }

                          if (!(RegExp(r"^[a-zA-Z 0-9 ]*$")
                              .hasMatch(val.toString()))) {
                            return 'Invalid city name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          cityController.text = value.toString();
                        },
                        onChanged: (value) {
                          setState(() {
                            disabledButton = false;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextButton(
                          onPressed: () {
                            changePasswordModal();
                          },
                          child: const TitleFont(
                            text: 'Change Password',
                            size: 20,
                            color: AppColors.primary,
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary),
                              onPressed: disabledButton
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        // address!.id = widget.addressId;
                                        // address!.street = streetAddressController.text;
                                        editProfile();
                                      }
                                      // registerRestaurant();
                                    },
                              child: Text(
                                'Done',
                                style: TextStyle(
                                    color: disabledButton
                                        ? AppColors.grey
                                        : AppColors.white),
                              )
                              // _submit,
                              ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
