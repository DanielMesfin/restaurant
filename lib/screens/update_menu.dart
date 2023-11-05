// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:another_flushbar/flushbar.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:urban_restaurant/models/add_menu_model.dart';
// import 'package:urban_restaurant/models/get_menu_foods_model.dart';
// import 'package:urban_restaurant/widgets/button_widget.dart';
// import 'package:urban_restaurant/widgets/shimmer_loading.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as pa;
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import '../helpers/firebase_api.dart';
// import '../providers/fetch_and_post.dart';
// import '../style/colors.dart';
// import '../style/style.dart';
// import '../widgets/image_view.dart';

// class UpdateMenu extends StatefulWidget {
//   static const routeName = '/updateMenu';
//   final int menuId;
//   final String menuName;
//   final String menuDesc;
//   final int restaurantId;
//   final String restaurantName;
//   const UpdateMenu(
//       {Key? key,
//       required this.menuId,
//       required this.menuName,
//       required this.menuDesc,
//       required this.restaurantId,
//       required this.restaurantName})
//       : super(key: key);

//   @override
//   State<UpdateMenu> createState() => _UpdateMenuState();
// }

// class _UpdateMenuState extends State<UpdateMenu> {
//   List<FoodImageEntity> imageUrls = [];
//   List<FoodImageEntity> updatedFoodImage = [];
//   List<dynamic> updatedFoodImagesId = [];
//   List<dynamic> updatedFoodImagesUrl = [];
//   UploadTask? task;
//   File? file;
//   List<int> foodIdsCollection = [];
//   // List<GetMenuFoods> menuFoodDetail;
//   bool _isFirstLoadRunning = false;
//   double foodQuantity = 0;
//   bool updated = false; // going to work on updated button disabled or enabled
//   List<GetMenuFoods> _posts = [];
//   int timeout = 10;
//   bool startedTyping = false;
//   String backendUrl = 'https://esoora-backend-prod-qiymu.ondigitalocean.app';

//   final _formKey = GlobalKey<FormState>();
//   final _formKey1 = GlobalKey<FormState>();
//   final _formKey2 = GlobalKey<FormState>();

//   TextEditingController menuNameController = TextEditingController();
//   TextEditingController menuDescriptionController = TextEditingController();
//   TextEditingController foodNameController = TextEditingController();
//   TextEditingController updatedFoodNameController = TextEditingController();
//   TextEditingController foodDescriptionController = TextEditingController();
//   TextEditingController updatedFoodDescriptionController =
//       TextEditingController();
//   TextEditingController foodPriceController = TextEditingController();
//   TextEditingController updatedFoodPriceController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     menuNameController.text = widget.menuName;
//     menuDescriptionController.text = widget.menuDesc;
//     fetchMenuFoodsList();
//   }

//   onRefresh() {
//     fetchMenuFoodsList();
//     setState(() {});
//   }

//   Future fetchMenuFoodsList() async {
//     setState(() {
//       _isFirstLoadRunning = true;
//     });

//     try {
//       final url = Uri.parse('$backendUrl/public/menu/${widget.menuId}');
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       ).timeout(Duration(seconds: timeout));
//       if (response.statusCode == 200) {
//         setState(() {
//           List jsonResponse = json.decode(response.body)['foods'];
//           _posts =
//               jsonResponse.map((data) => GetMenuFoods.fromJson(data)).toList();
//         });
//       } else {
//         throw ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           behavior: SnackBarBehavior.floating,
//           content: Text('Error Occured!'),
//           backgroundColor: Colors.red,
//         ));
//       }
//     } on TimeoutException {
//       Provider.of<Fetch>(context, listen: false).scaffoldMessage(
//           context, 'Network is timedout! please try again.', Colors.red);
//     } on SocketException {
//       Provider.of<Fetch>(context, listen: false).scaffoldMessage(
//           context,
//           'Network is unreachable! Please check your internet connection.',
//           Colors.red);
//     } on Error {
//       Provider.of<Fetch>(context, listen: false)
//           .scaffoldMessage(context, 'Error Occured!', Colors.red);
//     }

//     setState(() {
//       _isFirstLoadRunning = false;
//     });
//   }

//   // onGoBack(dynamic value) {
//   //   menuFoodDetail = Provider.of<Fetch>(context, listen: false)
//   //       .fetchMenuFoodsList(widget.menuId, context);
//   //   setState(() {});
//   // }

//   Future newFoodAddUpdate() async {
//     final url = Uri.parse('$backendUrl/menu/${widget.restaurantId}');

//     final jsonBody = json.encode(UpdateMenuModel(
//         widget.menuId,
//         // menuNameController.text,
//         widget.menuName,
//         // [...newAddedFoodId],
//         foodIdsCollection,
//         // menuDescriptionController.text,
//         widget.menuDesc,
//         widget.restaurantId));
//     final response = await http.post(
//       url,
//       body: jsonBody,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization':
//             ' Bearer ${Provider.of<Fetch>(context, listen: false).token}',
//         // ${Provider.of<Auth>(context, listen: false).token}',
//         'pid': '${Provider.of<Fetch>(context, listen: false).pid}',
//         // '${Provider.of<Auth>(context, listen: false).pid}',
//       },
//     );
//     final responseData = json.decode(response.body);

//     if (responseData['error'] != null) {
//       throw HttpException(responseData['error']['message']);
//     }
//     if (response.statusCode == 200) {
//       Flushbar(
//         maxWidth: MediaQuery.of(context).size.width * 0.90,
//         backgroundColor: Colors.green,
//         flushbarPosition: FlushbarPosition.TOP,
//         title: 'Food Added!',
//         message: 'Food Added successfully!',
//         duration: const Duration(seconds: 2),
//       ).show(context);
//       // Navigator.of(context).pop();
//       // Navigator.pop(context);
//       // Navigator.of(context)
//       //     .pushReplacementNamed(RestaurantDetailScreen.routeName);
//     } else {
//       dialogue('We are not able to process your request at this time!');
//     }
//   }

//   Future updateMenu() async {
//     if (menuNameController.text.isNotEmpty &&
//         menuDescriptionController.text.isNotEmpty) {
//       final url = Uri.parse('$backendUrl/menu/${widget.restaurantId}');
//       try {
//         final jsonBody = json.encode(UpdateMenuModel(
//             widget.menuId,
//             menuNameController.text,
//             [...foodIdsCollection],
//             menuDescriptionController.text,
//             widget.restaurantId));
//         final response = await http.post(
//           url,
//           body: jsonBody,
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization':
//                 ' Bearer ${Provider.of<Fetch>(context, listen: false).token}',
//             // ${Provider.of<Auth>(context, listen: false).token}',
//             'pid': '${Provider.of<Fetch>(context, listen: false).pid}',
//             // '${Provider.of<Auth>(context, listen: false).pid}',
//           },
//         );
//         final responseData = json.decode(response.body);

//         if (responseData['error'] != null) {
//           throw HttpException(responseData['error']['message']);
//         }
//         if (response.statusCode == 200) {
//           Navigator.pop(context);
//           Flushbar(
//             maxWidth: MediaQuery.of(context).size.width * 0.90,
//             backgroundColor: Colors.green,
//             flushbarPosition: FlushbarPosition.TOP,
//             title: 'Update Successful!',
//             message: 'You Updated ${menuNameController.text} successfully!',
//             duration: const Duration(seconds: 3),
//           ).show(context);

//           // Navigator.of(context)
//           //     .pushReplacementNamed(RestaurantDetailScreen.routeName);
//         } else {
//           dialogue('We are not able to process your request at this time!');
//         }
//       } on TimeoutException {
//         Provider.of<Fetch>(context, listen: false).scaffoldMessage(
//             context, 'Network is timedout! please try again.', Colors.red);
//       } on SocketException {
//         Provider.of<Fetch>(context, listen: false).scaffoldMessage(
//             context,
//             'Network is unreachable! Please check your internet connection.',
//             Colors.red);
//       } on Error {
//         Provider.of<Fetch>(context, listen: false)
//             .scaffoldMessage(context, 'Error Occured!', Colors.red);
//       }
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Empty Fields!')));
//     }
//   }

//   Future addFood() async {
//     Provider.of<Fetch>(context, listen: false).checkLogin();
//     if (foodNameController.text.isNotEmpty &&
//         foodDescriptionController.text.isNotEmpty &&
//         imageUrls.isNotEmpty) {
//       final url = Uri.parse('$backendUrl/food/${widget.restaurantId}');
//       double price = double.parse(foodPriceController.text);
//       try {
//         final jsonBody = json.encode(GetMenuFoods(
//           name: foodNameController.text,
//           foodImageEntities: imageUrls,
//           description: foodDescriptionController.text,
//           price: price,
//           restaurantId: widget.restaurantId,
//         ));
//         final response = await http.post(
//           url,
//           body: jsonBody,
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization':
//                 ' Bearer ${Provider.of<Fetch>(context, listen: false).token}',
//             'pid': '${Provider.of<Fetch>(context, listen: false).pid}',
//           },
//         );
//         final responseData = json.decode(response.body);

//         if (responseData['error'] != null) {
//           throw HttpException(responseData['error']['message']);
//         }

//         if (response.statusCode == 200) {
//           foodIdsCollection.add(responseData['id']);
//           Navigator.of(context).pop();
//           _formKey1.currentState!.reset();
//           foodNameController.clear();
//           foodDescriptionController.clear();
//           foodPriceController.clear();
//           imageUrls.clear();
//           await newFoodAddUpdate(); //needs to send new food Id and update the menu
//           onRefresh();
//           // print('new ID $newAddedFoodId');
//           // Navigator.pop(context);
//           // onGoBack;

//           //     .pushReplacementNamed(RestaurantDetailScreen.routeName);
//         } else {
//           dialogue('We are not able to process your request at this time!');
//         }
//       } on TimeoutException {
//         Provider.of<Fetch>(context, listen: false).scaffoldMessage(
//             context, 'Network is timedout! please try again.', Colors.red);
//       } on SocketException {
//         Provider.of<Fetch>(context, listen: false).scaffoldMessage(
//             context,
//             'Network is unreachable! Please check your internet connection.',
//             Colors.red);
//       } on Error {
//         Provider.of<Fetch>(context, listen: false)
//             .scaffoldMessage(context, 'Error Occured!', Colors.red);
//       }
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Empty Fields!')));
//     }
//   }

//   Future updateFood(int foodId) async {
//     double price = double.parse(updatedFoodPriceController.text);
//     final url = Uri.parse('$backendUrl/food/${widget.restaurantId}');

//     final jsonBody = json.encode(GetMenuFoods(
//       id: foodId,
//       name: updatedFoodNameController.text,
//       foodImageEntities: updatedFoodImage,
//       description: updatedFoodDescriptionController.text,
//       price: price,
//       restaurantId: widget.restaurantId,
//     ));
//     final response = await http.post(
//       url,
//       body: jsonBody,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization':
//             ' Bearer ${Provider.of<Fetch>(context, listen: false).token}',
//         'pid': '${Provider.of<Fetch>(context, listen: false).pid}',
//       },
//     );
//     final responseData = json.decode(response.body);

//     if (responseData['error'] != null) {
//       throw HttpException(responseData['error']['message']);
//     }
//     if (response.statusCode == 200) {
//       foodIdsCollection.add(responseData['id']);
//       Navigator.of(context).pop();
//       _formKey2.currentState!.reset();
//       updatedFoodNameController.clear();
//       updatedFoodDescriptionController.clear();
//       updatedFoodNameController.clear();
//       // imageUrls.clear();
//       await newFoodAddUpdate(); //needs to send new food Id and update the menu
//       onRefresh();
//       updatedFoodImage.clear();
//       Flushbar(
//         maxWidth: MediaQuery.of(context).size.width * 0.90,
//         backgroundColor: Colors.green,
//         flushbarPosition: FlushbarPosition.TOP,
//         title: 'Food Edited!',
//         message: 'Food Edited successfully!',
//         duration: const Duration(seconds: 2),
//       ).show(context);
//     } else {
//       dialogue('We are not able to process your request at this time!');
//     }
//   }

//   void dialogue(String message) {
//     AwesomeDialog(
//       context: context,
//       animType: AnimType.TOPSLIDE,
//       headerAnimationLoop: false,
//       dialogType: DialogType.ERROR,
//       showCloseIcon: true,
//       title: 'Menu Registration Error!',
//       desc: message,
//       btnOkOnPress: () {
//         Navigator.of(context).pop();
//       },
//       btnOkIcon: Icons.check_circle,
//       btnOkText: 'Ok',
//       // btnCancelOnPress: () {},
//       // btnCancelIcon: Icons.cancel,
//       onDissmissCallback: (type) {
//         debugPrint('Dialog Dissmiss from callback $type');
//       },
//     ).show();
//   }

//   void confirmationDialogue(String title, desc, int id) {
//     AwesomeDialog(
//       context: context,
//       animType: AnimType.TOPSLIDE,
//       headerAnimationLoop: false,
//       dialogType: DialogType.WARNING,
//       showCloseIcon: true,
//       title: title,
//       desc: desc,
//       btnOkOnPress: () {
//         Provider.of<Fetch>(context, listen: false)
//             .deleteFoodHandler(id, context, onRefresh);
//       },
//       btnOkIcon: Icons.check_circle,
//       btnOkText: 'Ok',
//       btnCancelOnPress: () {
//         // Navigator.of(context).pop();
//         // Navigator.pop(context);
//       },
//       btnCancelIcon: Icons.cancel,
//       onDissmissCallback: (type) {
//         debugPrint('Dialog Dissmiss from callback $type');
//       },
//     ).show();
//   }

//   Future selectFile(setState) async {
//     final result =
//         await ImagePicker.platform.pickImage(source: ImageSource.gallery);

//     if (result == null) return;
//     final path = result.path;

//     setState(() => file = File(path));
//     uploadFile(setState);
//   }

//   Future selectFileAndUpdate(setState) async {
//     final result =
//         await ImagePicker.platform.pickImage(source: ImageSource.gallery);

//     if (result == null) return;
//     final path = result.path;

//     setState(() => file = File(path));
//     uploadFileAndUpdate(setState);
//   }

//   Future uploadFile(setState) async {
//     if (file == null) return;

//     final fileName = pa.basename(file!.path);
//     final destination = 'files/$fileName';

//     task = FirebaseApi.uploadFile(destination, file!);
//     this.setState(() {});

//     if (task == null) return;

//     final snapshot = await task!.whenComplete(() {});
//     final _downloadURL = await snapshot.ref.getDownloadURL();

//     setState(() {
//       // urlDownload.add(_downloadURL);
//       imageUrls.add(FoodImageEntity(
//         url: _downloadURL,
//       ));
//     });
//   }

//   Future uploadFileAndUpdate(setState) async {
//     if (file == null) return;

//     final fileName = pa.basename(file!.path);
//     final destination = 'files/$fileName';

//     task = FirebaseApi.uploadFile(destination, file!);
//     this.setState(() {});

//     if (task == null) return;

//     final snapshot = await task!.whenComplete(() {});
//     final _downloadURL = await snapshot.ref.getDownloadURL();

//     setState(() {
//       // urlDownload.add(_downloadURL);
//       // imageUrls.add(FoodImage(_downloadURL));
//       updatedFoodImagesUrl.add(_downloadURL);
//       updatedFoodImage.add(FoodImageEntity(url: _downloadURL));
//     });
//   }

//   Future<void> _removeImage(int index, setState) async {
//     //this only deletes the last uploaded image needs fixing
//     setState(() {
//       imageUrls.removeAt(index);
//     });
//     // if (file == null) return;

//     // final fileName = pa.basename(file!.path);
//     // final destination = 'files/$fileName';
//     // task = FirebaseApi.uploadFile(destination, file!);
//     // final snapshot = await task!.whenComplete(() {});
//     // await snapshot.ref.delete();
//     // print(FoodImage);
//   }

//   Future<void> _removeImageAndUpdate(int index, setState) async {
//     setState(() {
//       updatedFoodImage.removeAt(index);
//     });
//   }

//   Widget imageindex(String url, int index, setState) {
//     return GestureDetector(
//         child: Stack(children: [
//       Container(
//         // margin: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
//         padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
//             // color:
//             //     selectedFoodCard == index ? AppColors.primary : AppColors.white,
//             boxShadow: const [
//               BoxShadow(
//                 color: AppColors.lightGray,
//                 blurRadius: 15,
//               )
//             ]),
//         child: Image.network(url, fit: BoxFit.contain),
//       ),
//       IconButton(
//         onPressed: () => {_removeImage(index, setState)},
//         icon: const Icon(Icons.delete_outline),
//         color: Colors.red,
//       )
//     ]));
//   }

//   Widget imageUpdate(String url, int index, setState) {
//     return GestureDetector(
//         child: Stack(children: [
//       Container(
//         // margin: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
//         padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
//             // color:
//             //     selectedFoodCard == index ? AppColors.primary : AppColors.white,
//             boxShadow: const [
//               BoxShadow(
//                 color: AppColors.lightGray,
//                 blurRadius: 15,
//               )
//             ]),
//         child: Image.network(url, fit: BoxFit.contain),
//       ),
//       IconButton(
//         onPressed: () => {_removeImageAndUpdate(index, setState)},
//         icon: const Icon(Icons.delete_outline),
//         color: Colors.red,
//       )
//     ]));
//   }

//   Widget _buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
//         stream: task.snapshotEvents,
//         builder: (context, snapshot) {
//           // print(urlDownload);
//           if (snapshot.hasData) {
//             final snap = snapshot.data!;
//             final progress = snap.bytesTransferred / snap.totalBytes;
//             final percentage = (progress * 100).toStringAsFixed(2);
//             return Text(
//               percentage == '100.00' || imageUrls.isNotEmpty
//                   ? 'Image added'
//                   : 'Adding image: $percentage %',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             );
//           } else {
//             return Container();
//           }
//         },
//       );

//   void infoModal() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return const AlertDialog(
//             title: TitleFont(text: 'How to add food?'),
//             content: DescriptionFont(
//               color: AppColors.grey,
//               size: 15,
//               text:
//                   'Tap Add food button then enter the food name you want to add then enter the food description after that enter the food price and food image preferably more than two images then tap Save botton. You can edit or update your existing food from the update menu screen.',
//             ),
//           );
//         });
//   }

//   void addFoodModal(BuildContext ctx) async {
//     await showModalBottomSheet(
//         isScrollControlled: true,
//         isDismissible: true,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
//         ),
//         context: ctx,
//         builder: (ctx) {
//           return StatefulBuilder(
//             builder: (context, setState) {
//               return SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.75,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.05,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(),
//                             // SizedBox(
//                             //   width: MediaQuery.of(context).size.width * 0.25,
//                             // ),
//                             IconButton(
//                               icon: const Icon(Icons.close),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             )
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.584,
//                         child: Form(
//                             key: _formKey1,
//                             child: ListView(
//                               children: [
//                                 Container(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                                   child: TextFormField(
//                                     maxLength: 30,
//                                     textCapitalization:
//                                         TextCapitalization.sentences,
//                                     controller: foodNameController,
//                                     decoration: const InputDecoration(
//                                       // suffixIcon: Icon(Icons.business),
//                                       enabledBorder: UnderlineInputBorder(
//                                           borderSide:
//                                               BorderSide(color: Colors.black)),
//                                       labelText: 'Food Name',
//                                     ),
//                                     onChanged: (val) {
//                                       startedTyping = true;
//                                     },
//                                     validator: (val) {
//                                       if (val.toString().isEmpty) {
//                                         return 'Food name is required';
//                                       }

//                                       if (!(RegExp(r"^[a-zA-Z ]*$")
//                                           .hasMatch(val.toString()))) {
//                                         return 'Invalid Food Name';
//                                       }
//                                       return null;
//                                     },
//                                     onSaved: (value) {
//                                       // foodNameController.text =
//                                       //     value.toString();
//                                       // widget.fName = value;
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                                   child: TextFormField(
//                                     maxLength: 250,
//                                     textCapitalization:
//                                         TextCapitalization.sentences,
//                                     controller: foodDescriptionController,
//                                     keyboardType: TextInputType.multiline,
//                                     maxLines: null,
//                                     decoration: const InputDecoration(
//                                       enabledBorder: UnderlineInputBorder(
//                                           borderSide:
//                                               BorderSide(color: Colors.black)),
//                                       labelText: 'Food Description',
//                                     ),
//                                     onChanged: (val) {
//                                       startedTyping = true;
//                                     },
//                                     validator: (val) {
//                                       if (val.toString().isEmpty) {
//                                         return 'Price is required';
//                                       }
//                                       if (val.toString().characters.length >
//                                           210) {
//                                         return 'No more than 250 characters';
//                                       }
//                                       return null;
//                                     },
//                                     onSaved: (value) {
//                                       // nameController.text = value.toString();
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                                   child: Padding(
//                                     padding: EdgeInsets.only(
//                                         bottom: MediaQuery.of(context)
//                                                 .viewInsets
//                                                 .bottom *
//                                             0.7),
//                                     child: TextFormField(
//                                       controller: foodPriceController,
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                         enabledBorder: UnderlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors.black)),
//                                         labelText: 'Price',
//                                       ),
//                                       onChanged: (val) {
//                                         startedTyping = true;
//                                       },
//                                       validator: (value) {
//                                         if (value.toString().isEmpty) {
//                                           return 'Price is required';
//                                         }
//                                         if (!RegExp(r"^.(?:)?[0-9]")
//                                             .hasMatch(value.toString())) {
//                                           return 'invalid price entered';
//                                         }
//                                         if (value!.length > 8) {
//                                           return 'Invalid price entered';
//                                         }
//                                         return null;
//                                       },
//                                       onSaved: (value) {
//                                         // phoneController.text = value.toString();
//                                         // }
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                                   child: imageUrls.isNotEmpty
//                                       ? Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             imageUrls.length >= 5
//                                                 ? Container()
//                                                 : ElevatedButton.icon(
//                                                     style: ElevatedButton
//                                                         .styleFrom(
//                                                             primary: AppColors
//                                                                 .primary),
//                                                     icon: const Icon(
//                                                       Icons.add,
//                                                       color: AppColors.white,
//                                                     ),
//                                                     onPressed: () {
//                                                       setState(() {
//                                                         selectFile(setState);
//                                                       });
//                                                     },
//                                                     label: const InfoFont(
//                                                       text: 'Add more',
//                                                       color: AppColors.white,
//                                                       size: 20,
//                                                     ),
//                                                   ),
//                                             const SizedBox(height: 8),
//                                             // Text(
//                                             //   imageUrls.isNotEmpty ? fileName : '',
//                                             //   style: const TextStyle(
//                                             //       fontSize: 16,
//                                             //       fontWeight: FontWeight.w500),
//                                             // ),
//                                             const SizedBox(height: 5),
//                                             SizedBox(
//                                               height: imageUrls.isNotEmpty
//                                                   ? 100
//                                                   : 5,
//                                               child: ListView.builder(
//                                                 primary: false,
//                                                 shrinkWrap: true,
//                                                 scrollDirection:
//                                                     Axis.horizontal,
//                                                 itemBuilder: (ctx, index) =>
//                                                     Padding(
//                                                         padding:
//                                                             EdgeInsets.only(
//                                                                 left: index == 0
//                                                                     ? 25
//                                                                     : 0),
//                                                         child: imageindex(
//                                                             imageUrls[index]
//                                                                 .url,
//                                                             index,
//                                                             setState)),
//                                                 itemCount: imageUrls.length,
//                                               ),
//                                             ),
//                                             task != null
//                                                 ? _buildUploadStatus(task!)
//                                                 : Container(),
//                                           ],
//                                         )
//                                       : ElevatedButton.icon(
//                                           style: ElevatedButton.styleFrom(
//                                               primary: AppColors.primary),
//                                           onPressed: () {
//                                             setState(() {
//                                               selectFile(setState);
//                                             });
//                                           },
//                                           icon: const Icon(
//                                             Icons.image,
//                                             color: Colors.white,
//                                           ),
//                                           label: const Text(
//                                             'Add Food Image',
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           )),
//                                 ),
//                               ],
//                             )),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.45,
//                             child: ElevatedButton.icon(
//                               style: ElevatedButton.styleFrom(
//                                   primary: AppColors.grey,
//                                   padding: const EdgeInsets.only(
//                                       top: 15, bottom: 15)),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               label: const InfoFont(
//                                 text: 'Cancel',
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColors.white,
//                               ),
//                               icon: const Icon(
//                                 Icons.cancel,
//                                 color: AppColors.white,
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.45,
//                             child: ElevatedButton.icon(
//                               style: ElevatedButton.styleFrom(
//                                   primary: AppColors.primary,
//                                   // minimumSize: const Size.fromHeight(5),
//                                   padding: const EdgeInsets.only(
//                                       top: 15, bottom: 15)),
//                               onPressed: () {
//                                 if (_formKey1.currentState!.validate()) {
//                                   // _formKey1.currentState!.save();
//                                   if (imageUrls.isEmpty) {
//                                     Flushbar(
//                                       maxWidth:
//                                           MediaQuery.of(context).size.width *
//                                               0.90,
//                                       backgroundColor: Colors.red,
//                                       flushbarPosition: FlushbarPosition.TOP,
//                                       title: 'Error',
//                                       message: 'Please add food image!',
//                                       duration: const Duration(seconds: 2),
//                                     ).show(context);
//                                   }
//                                   addFood();
//                                   // Navigator.of(context).pushReplacement(
//                                   //     MaterialPageRoute(
//                                   //         builder: (BuildContext context) =>
//                                   //             AddMenu(
//                                   //               fName: foodNameController.text,
//                                   //             )));
//                                 }
//                               },
//                               label: const InfoFont(
//                                 text: 'Save',
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColors.white,
//                               ),
//                               icon: const Icon(
//                                 Icons.save,
//                                 color: AppColors.white,
//                               ),
//                             ),
//                           ),
//                           // SizedBox(
//                           //   width: MediaQuery.of(context).size.width * 0.02,
//                           // ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         });
//     // setState(() {});
//   }

//   void foodUpdateDialogue(int id, String name, String description, double price,
//       List<FoodImageEntity> foodImage, int index) {
//     updatedFoodNameController.text = name;
//     updatedFoodDescriptionController.text = description;
//     int convertedPrice = price.toInt();
//     updatedFoodPriceController.text = convertedPrice.toString();

//     updatedFoodImage = foodImage;

//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return StatefulBuilder(
//             builder: (BuildContext context,
//                 void Function(void Function()) setState) {
//               return Dialog(
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(15)),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.63,
//                     child: Stack(
//                       children: <Widget>[
//                         Form(
//                             key: _formKey2,
//                             child: ListView(
//                               children: [
//                                 SizedBox(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.05,
//                                   child: Container(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         const Text(
//                                           'Edit Food',
//                                           style: TextStyle(fontSize: 20),
//                                         ),
//                                         // SizedBox(
//                                         //   width: MediaQuery.of(context).size.width * 0.25,
//                                         // ),
//                                         IconButton(
//                                           icon: const Icon(Icons.close),
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                             updatedFoodImagesId.clear();
//                                             updatedFoodImagesUrl.clear();
//                                           },
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                                   child: TextFormField(
//                                     maxLength: 30,
//                                     textCapitalization:
//                                         TextCapitalization.sentences,
//                                     // initialValue: widget.menuName,
//                                     controller: updatedFoodNameController,
//                                     decoration: const InputDecoration(
//                                       // suffixIcon: Icon(Icons.business),
//                                       enabledBorder: UnderlineInputBorder(
//                                           borderSide:
//                                               BorderSide(color: Colors.black)),
//                                       labelText: 'Food Name',
//                                     ),
//                                     onChanged: (val) {
//                                       startedTyping = true;
//                                     },
//                                     validator: (val) {
//                                       if (val.toString().isEmpty) {
//                                         return 'Food name is required';
//                                       }

//                                       if (!(RegExp(r"^[a-zA-Z ]*$")
//                                           .hasMatch(val.toString()))) {
//                                         return 'Invalid Name';
//                                       }
//                                       return null;
//                                     },
//                                     // onChanged: (value){
//                                     //   updated = true;
//                                     // },
//                                     onSaved: (value) {
//                                       updatedFoodNameController.text =
//                                           value.toString();
//                                       // nameController.text = value.toString();
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                                   child: TextFormField(
//                                     maxLength: 250,
//                                     textCapitalization:
//                                         TextCapitalization.sentences,
//                                     // initialValue: widget.menuDesc,
//                                     controller:
//                                         updatedFoodDescriptionController,
//                                     keyboardType: TextInputType.multiline,
//                                     maxLines: null,
//                                     decoration: const InputDecoration(
//                                       enabledBorder: UnderlineInputBorder(
//                                           borderSide:
//                                               BorderSide(color: Colors.black)),
//                                       labelText: 'Food Description',
//                                     ),
//                                     onChanged: (val) {
//                                       startedTyping = true;
//                                     },
//                                     validator: (val) {
//                                       if (val.toString().isEmpty) {
//                                         return 'Food description is required';
//                                       }
//                                       if (val.toString().characters.length >
//                                           210) {
//                                         return 'No more than 250 characters';
//                                       }
//                                       return null;
//                                     },
//                                     onSaved: (value) {
//                                       updatedFoodDescriptionController.text =
//                                           value.toString();
//                                       // nameController.text = value.toString();
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                                   child: Padding(
//                                     padding: EdgeInsets.only(
//                                         bottom: MediaQuery.of(context)
//                                                 .viewInsets
//                                                 .bottom *
//                                             0.7),
//                                     child: TextFormField(
//                                       keyboardType: TextInputType.number,
//                                       controller: updatedFoodPriceController,
//                                       decoration: const InputDecoration(
//                                         // suffixIcon: Icon(Icons.business),
//                                         enabledBorder: UnderlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors.black)),
//                                         labelText: 'Price',
//                                       ),
//                                       onChanged: (val) {
//                                         startedTyping = true;
//                                       },
//                                       validator: (val) {
//                                         if (val.toString().isEmpty) {
//                                           return 'Price is required';
//                                         }
//                                         if (!RegExp(r"^(?:)?[0-9]")
//                                             .hasMatch(val.toString())) {
//                                           return 'invalid price entered';
//                                         }
//                                         if (val!.length > 8) {
//                                           return 'Invalid price entered';
//                                         }
//                                         return null;
//                                       },
//                                       // onChanged: (value){
//                                       //   updated = true;
//                                       // },
//                                       onSaved: (value) {
//                                         updatedFoodPriceController.text =
//                                             value.toString();
//                                         // nameController.text = value.toString();
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                                   child: updatedFoodImage.isNotEmpty
//                                       ? Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             updatedFoodImage.length >= 5
//                                                 ? Container()
//                                                 : ElevatedButton.icon(
//                                                     style: ElevatedButton
//                                                         .styleFrom(
//                                                             primary: AppColors
//                                                                 .primary),
//                                                     icon: const Icon(
//                                                       Icons.add,
//                                                       color: AppColors.white,
//                                                     ),
//                                                     onPressed: () {
//                                                       setState(() {
//                                                         selectFileAndUpdate(
//                                                             setState);
//                                                       });
//                                                     },
//                                                     label: const InfoFont(
//                                                       text: 'Add more',
//                                                       color: AppColors.white,
//                                                       size: 20,
//                                                     ),
//                                                   ),
//                                             const SizedBox(height: 8),
//                                             // Text(
//                                             //   imageUrls.isNotEmpty ? fileName : '',
//                                             //   style: const TextStyle(
//                                             //       fontSize: 16,
//                                             //       fontWeight: FontWeight.w500),
//                                             // ),
//                                             const SizedBox(height: 5),
//                                             SizedBox(
//                                               height:
//                                                   updatedFoodImage.isNotEmpty
//                                                       ? 100
//                                                       : 5,
//                                               child: ListView.builder(
//                                                 primary: false,
//                                                 shrinkWrap: true,
//                                                 scrollDirection:
//                                                     Axis.horizontal,
//                                                 itemBuilder: (ctx, index) {
//                                                   updatedFoodImagesId
//                                                       .add(foodImage[index].id);
//                                                   updatedFoodImagesUrl.add(
//                                                       foodImage[index].url);
//                                                   return Padding(
//                                                       padding: EdgeInsets.only(
//                                                           left: index == 0
//                                                               ? 25
//                                                               : 0),
//                                                       child: imageUpdate(
//                                                           updatedFoodImage[
//                                                                   index]
//                                                               .url,
//                                                           index,
//                                                           setState));
//                                                 },
//                                                 itemCount:
//                                                     updatedFoodImage.length,
//                                               ),
//                                             ),
//                                             // task != null
//                                             //     ? _buildUploadStatus(task!)
//                                             //     : Container(),
//                                           ],
//                                         )
//                                       : ElevatedButton.icon(
//                                           style: ElevatedButton.styleFrom(
//                                               primary: AppColors.primary),
//                                           onPressed: () {
//                                             setState(() {
//                                               selectFileAndUpdate(setState);
//                                             });
//                                           },
//                                           icon: const Icon(
//                                             Icons.image,
//                                             color: AppColors.white,
//                                           ),
//                                           label: const InfoFont(
//                                             text: 'Add food image',
//                                             color: AppColors.white,
//                                             size: 20,
//                                           ),
//                                         ),
//                                 ),
//                                 SizedBox(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.05,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     SizedBox(
//                                       width: MediaQuery.of(context).size.width *
//                                           0.30,
//                                       child: ElevatedButton.icon(
//                                         style: ElevatedButton.styleFrom(
//                                             primary: AppColors.grey,
//                                             padding: const EdgeInsets.only(
//                                                 top: 10, bottom: 10)),
//                                         onPressed: () {
//                                           onRefresh();
//                                           Navigator.pop(context);
//                                           updatedFoodImagesId.clear();
//                                           updatedFoodImagesUrl.clear();
//                                           updatedFoodImage.clear();
//                                         },
//                                         label: const InfoFont(
//                                           text: 'Cancel',
//                                           color: AppColors.white,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                         icon: const Icon(
//                                           Icons.cancel,
//                                           color: AppColors.white,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: MediaQuery.of(context).size.width *
//                                           0.30,
//                                       child: ElevatedButton.icon(
//                                         style: ElevatedButton.styleFrom(
//                                             primary: AppColors.primary,
//                                             // minimumSize: const Size.fromHeight(5),
//                                             padding: const EdgeInsets.only(
//                                                 top: 10, bottom: 10)),
//                                         onPressed: () {
//                                           if (_formKey2.currentState!
//                                               .validate()) {
//                                             // onRefresh();

//                                             // Navigator.pop(context);
//                                             if (updatedFoodImage.isEmpty) {
//                                               Flushbar(
//                                                 maxWidth: MediaQuery.of(context)
//                                                         .size
//                                                         .width *
//                                                     0.90,
//                                                 backgroundColor: Colors.red,
//                                                 flushbarPosition:
//                                                     FlushbarPosition.TOP,
//                                                 title: 'Error',
//                                                 message:
//                                                     'Please add food image!',
//                                                 duration:
//                                                     const Duration(seconds: 2),
//                                               ).show(context);
//                                             } else {
//                                               updateFood(id);
//                                               onRefresh();
//                                             }

//                                             // updatedFoodImage.clear();
//                                           }
//                                         },
//                                         label: const InfoFont(
//                                           text: 'Update',
//                                           color: AppColors.white,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                         icon: const Icon(
//                                           Icons.update,
//                                           color: AppColors.white,
//                                         ),
//                                       ),
//                                     ),
//                                     // SizedBox(
//                                     //   width: MediaQuery.of(context).size.width * 0.02,
//                                     // ),
//                                   ],
//                                 )
//                               ],
//                             )),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         });
//   }

//   Widget foodListCard(data, int index) {
//     //need to accept only food id from menu and fetch public food and work from there
//     double priceToBeConverted = data[index].price;
//     int price = priceToBeConverted.toInt();
//     return Container(
//       margin: const EdgeInsets.only(right: 25, left: 20, top: 25),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(blurRadius: 10, color: AppColors.lightGray)
//         ],
//         color: AppColors.white,
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 4,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 25, left: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           // const Icon(
//                           //   Icons.star,
//                           //   color: AppColors.primary,
//                           //   size: 20,
//                           // ),
//                           // SizedBox(width: 5),
//                           SizedBox(
//                             width: 170,
//                             child: Poppins(
//                               color: AppColors.black,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               text: 'from ${widget.restaurantName}',
//                               size: 12,
//                             ),
//                           )
//                         ],
//                       ),
//                       const SizedBox(height: 15),
//                       Info2Font(
//                           maxLines: 1,
//                           color: AppColors.secondary,
//                           overflow: TextOverflow.ellipsis,
//                           text: data[index].name,
//                           size: 17,
//                           fontWeight: FontWeight.w700),
//                       Info2Font(
//                         color: AppColors.tertiary,
//                         text: '$price Birr',
//                         size: 18,
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 35,
//                 ),
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         foodUpdateDialogue(
//                             data[index].id,
//                             data[index].name,
//                             data[index].description,
//                             data[index].price,
//                             data[index].foodImageEntities,
//                             index);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 15),
//                         decoration: const BoxDecoration(
//                             color:
//                                 //  AppColors.primary,
//                                 Color.fromARGB(96, 150, 150, 150),
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(20),
//                               // topRight: Radius.circular(20),
//                             )),
//                         child: Column(
//                           children: const [
//                             Icon(Icons.edit, size: 25),
//                             Text(
//                               'Edit',
//                               style: TextStyle(fontSize: 10),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         confirmationDialogue('Delete?',
//                             'Delete ${data[index].name}', data[index].id);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 15),
//                         decoration: const BoxDecoration(
//                             color:
//                                 //  AppColors.primary,
//                                 Color.fromARGB(96, 150, 150, 150),
//                             borderRadius: BorderRadius.only(
//                               // bottomLeft: Radius.circular(20),
//                               topRight: Radius.circular(20),
//                             )),
//                         child: Column(
//                           children: const [
//                             Icon(
//                               Icons.delete,
//                               size: 25,
//                               color: Colors.red,
//                             ),
//                             Text('Delete',
//                                 style:
//                                     TextStyle(color: Colors.red, fontSize: 10))
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     // SizedBox(
//                     //   child: Row(
//                     //     children: [
//                     //       const Icon(Icons.star, size: 12),
//                     //       const SizedBox(width: 5),
//                     //       PrimaryText(
//                     //         text: 'star',
//                     //         size: 18,
//                     //         fontWeight: FontWeight.w600,
//                     //       )
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: GestureDetector(
//                 child: Container(
//                   transform: Matrix4.translationValues(-10, 0.0, 0.0),
//                   // constraints: BoxConstraints(
//                   //     maxHeight: MediaQuery.of(context).size.width * 0.75,
//                   //     maxWidth: double.infinity),
//                   child: CircleAvatar(
//                       radius: 100,
//                       backgroundColor: Colors.transparent,
//                       backgroundImage:
//                           NetworkImage(data[index].foodImageEntities[0].url)),
//                 ),
//                 onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (_) {
//                     return ImageView(
//                       img: data[index].foodImageEntities[0].url,
//                     );
//                   }));
//                 }),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget foodList() {
//     final deviceWidth = MediaQuery.of(context).size.width;
//     if (_isFirstLoadRunning) {
//       return const Center(
//           child: ShimmerLoading(
//         detail: false,
//         search: false,
//         foodCard: true,
//         profile: false,
//         favorite: false,
//         home: false,
//         homeA: false,
//       ));
//     } else {
//       return Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 3.0),
//                   child: Info2Font(
//                     text: _posts.isEmpty
//                         ? 'No foods available!'
//                         : '  Available foods (${_posts.length})',
//                     size: deviceWidth > 380 ? 20 : 15,
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 15,
//                     child: IconButton(
//                         onPressed: () {
//                           infoModal();
//                         },
//                         icon: const Icon(
//                           Icons.question_mark,
//                           size: 15,
//                         )),
//                   ),
//                   const SizedBox(
//                     width: 15,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: ElevatedButton.icon(
//                       style:
//                           ElevatedButton.styleFrom(primary: AppColors.primary),
//                       onPressed: _posts.length <= 6
//                           ? () {
//                               addFoodModal(context);
//                             }
//                           : null,
//                       icon: const Icon(
//                         Icons.add,
//                         color: AppColors.white,
//                       ),
//                       label: const InfoFont(
//                         text: 'Add food',
//                         color: AppColors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//           Column(
//               children: List.generate(_posts.length, (index) {
//             foodIdsCollection.add(_posts[index].id!);
//             return foodListCard(_posts, index);
//           })),
//         ],
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // bool willLeave = false;
//     return WillPopScope(
//       onWillPop: () async {
//         bool willLeave = false;
//         if (startedTyping) {
//           Provider.of<Fetch>(context, listen: false).willPopDialogue(context);
//           return willLeave;
//         }
//         Navigator.of(context).pop();
//         return willLeave;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color.fromARGB(0, 0, 0, 0),
//           elevation: 0,
//           leading: const BackButton(
//               // onPressed: () {
//               //   Navigator.of(context).pop;
//               // },
//               ),
//           title: const TitleFont(text: 'Update Menu'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Form(
//             key: _formKey,
//             child: ListView(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                   child: TextFormField(
//                     maxLength: 30,
//                     textCapitalization: TextCapitalization.sentences,
//                     // initialValue: widget.menuName,
//                     controller: menuNameController,
//                     decoration: const InputDecoration(
//                       // suffixIcon: Icon(Icons.business),
//                       enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black)),
//                       labelText: 'Menu Name',
//                     ),
//                     onChanged: (val) {
//                       startedTyping = true;
//                     },
//                     validator: (val) {
//                       if (val.toString().isEmpty) {
//                         return 'Menu name is required';
//                       }

//                       if (!(RegExp(r"^[a-zA-Z ]*$").hasMatch(val.toString()))) {
//                         return 'Invalid Name';
//                       }
//                       return null;
//                     },
//                     // onChanged: (value){
//                     //   updated = true;
//                     // },
//                     onSaved: (value) {
//                       menuNameController.text = value.toString();
//                       // nameController.text = value.toString();
//                     },
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                   child: TextFormField(
//                     maxLength: 250,
//                     textCapitalization: TextCapitalization.sentences,
//                     // initialValue: widget.menuDesc,
//                     controller: menuDescriptionController,
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     decoration: const InputDecoration(
//                       enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black)),
//                       labelText: 'Menu Description',
//                     ),
//                     onChanged: (val) {
//                       startedTyping = true;
//                     },
//                     validator: (val) {
//                       if (val.toString().isEmpty) {
//                         return 'Menu description is required';
//                       }
//                       if (val.toString().characters.length > 210) {
//                         return 'No more than 250 characters';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       menuDescriptionController.text = value.toString();
//                       // nameController.text = value.toString();
//                     },
//                   ),
//                 ),
//                 foodList(),
//                 // foodQuantity <= 2
//                 //     ? Container(
//                 //         child: Center(
//                 //           child: Text('please delete or add food'),
//                 //         ),
//                 //       )
//                 //     :
//                 Container(
//                     padding: const EdgeInsets.fromLTRB(10, 25, 10, 5),
//                     child: ButtonWidget(
//                         text: 'Update',
//                         onClicked: () {
//                           if (_formKey.currentState!.validate()) {
//                             updateMenu();
//                           }
//                         })
//                     // ElevatedButton(
//                     //   style: ElevatedButton.styleFrom(
//                     //       primary: AppColors.primary,
//                     //       padding: const EdgeInsets.only(top: 15, bottom: 15)),
//                     //   onPressed: () {
//                     //     if (_formKey.currentState!.validate()) {
//                     //       updateMenu();
//                     //     }
//                     //   },
//                     //   child: const InfoFont(
//                     //     text: 'Update',
//                     //     size: 20,
//                     //     fontWeight: FontWeight.w500,
//                     //     color: AppColors.white,
//                     //   ),
//                     // ),
//                     ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//     // );
//   }
// }
