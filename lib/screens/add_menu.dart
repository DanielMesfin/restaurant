import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:urban_restaurant/models/add_food_model.dart';
import 'package:urban_restaurant/models/add_menu_model.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/fetch_and_post.dart';
import '../style/colors.dart';
import '../style/style.dart';

class AddMenu extends StatefulWidget {
  final int resId;
  const AddMenu({Key? key, required this.resId}) : super(key: key);

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  List<FoodImage> imageUrls = [];
  //UploadTask? task;
  File? file;
  // Map<MenuCategory>? menu;

  final _formKey = GlobalKey<FormState>();

  TextEditingController menuNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String backendUrl = 'https://esoora-backend-prod-qiymu.ondigitalocean.app';

  Future addMenu() async {
    if (menuNameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      final url = Uri.parse('$backendUrl/menu/${widget.resId}');
      try {
        final jsonBody = json.encode(AddMenuModel(menuNameController.text, [],
            descriptionController.text, widget.resId));
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
          Navigator.pop(context);
          Flushbar(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
            backgroundColor: Colors.green,
            flushbarPosition: FlushbarPosition.TOP,
            title: 'Registration Successful!',
            message: 'You registered ${menuNameController.text} successfully!',
            duration: const Duration(seconds: 3),
          ).show(context);
        } else {
          dialogue('We are not able to process your request at this time!');
        }
      } on HttpException catch (error) {
        dialogue(error.toString());
      } catch (error) {
        const errorMessage = 'Something went wrong! Please check your input!';
        dialogue(errorMessage);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Empty Fields!')));
    }
  }

  void dialogue(String message) {
    AwesomeDialog(
      context: context,
      animType: AnimType.TOPSLIDE,
      headerAnimationLoop: false,
      dialogType: DialogType.ERROR,
      showCloseIcon: true,
      title: 'Menu Registration Error!',
      desc: message,
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
      btnOkIcon: Icons.check_circle,
      btnOkText: 'Ok',
      // btnCancelOnPress: () {},
      // btnCancelIcon: Icons.cancel,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
        leading: const BackButton(),
        title: const TitleFont(text: 'Add Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextFormField(
                  maxLength: 30,
                  textCapitalization: TextCapitalization.sentences,
                  controller: menuNameController,
                  decoration: const InputDecoration(
                    // suffixIcon: Icon(Icons.business),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: 'Menu Name',
                  ),
                  validator: (val) {
                    if (val.toString().isEmpty) {
                      return 'Menu name is required';
                    }

                    if (!(RegExp(r"^[a-zA-Z ]*$").hasMatch(val.toString()))) {
                      return 'Invalid Name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    menuNameController.text = value.toString();
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextFormField(
                  maxLength: 250,
                  textCapitalization: TextCapitalization.sentences,
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: 'Menu Description',
                  ),
                  validator: (val) {
                    if (val.toString().isEmpty) {
                      return 'Menu description is required';
                    }
                    if (!(RegExp(r"^[a-zA-Z () 0-9 .,?]*$")
                        .hasMatch(val.toString()))) {
                      return 'Invalid Menu Description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    descriptionController.text = value.toString();
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
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addMenu();
                    }
                  },
                  child: const InfoFont(
                    text: 'Add menu',
                    size: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
