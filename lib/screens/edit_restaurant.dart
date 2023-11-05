// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:another_flushbar/flushbar.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:urban_restaurant/screens/google_map.dart';
// import 'package:urban_restaurant/widgets/button_widget.dart';
// import 'package:urban_restaurant/widgets/chips.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:location/location.dart';
// import 'package:more_loading_gif/more_loading_gif.dart';
// import 'package:provider/provider.dart';
// import 'package:path/path.dart' as pa;
// import 'package:http/http.dart' as http;
// import '../helpers/firebase_api.dart';
// import '../models/post_res_models.dart';
// import '../providers/fetch_and_post.dart';
// import '../style/colors.dart';
// import '../style/style.dart';

// class EditRestaurant extends StatefulWidget {
//   // final int restaurantId;
//   // final String restaurantName;
//   // final String? ownerPid;
//   final Restaurant restaurantData;
//   // List<String> tags = [];

//   EditRestaurant({
//     Key? key,
//     required this.restaurantData,
//     // required this.restaurantId,
//     // required this.restaurantName,
//     // this.ownerPid,
//     // required this.tags
//   }) : super(key: key);

//   @override
//   State<EditRestaurant> createState() => _EditRestaurantState();
// }

// class _EditRestaurantState extends State<EditRestaurant> {
//   final GlobalKey<FormState> _formKey = GlobalKey();

//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController tagsController = TextEditingController();
//   TextEditingController streetAddressController = TextEditingController();
//   TextEditingController cityController = TextEditingController();
//   TextEditingController poboxController = TextEditingController();
//   TextEditingController latitudeController = TextEditingController();
//   TextEditingController longitudeController = TextEditingController();
//   TextEditingController profileNameController = TextEditingController();

//   Location currentLocation = Location();
//   String? pid;
//   double? restaurantLatitude, restaurantLongitude;
//   UploadTask? task;
//   File? file;
//   bool startedTyping = false;
//   bool _isLoading = false;

//   Map<String, dynamic> openHoursData = {'openHours': []};
//   List<OpenHour> _businessHourss = [];
//   List<RestaurantImageEntity> imageUrls = [];
//   List<Address> address = [];
//   List<String> days = [
//         "Monday",
//         "Tuesday",
//         "Wednesday",
//         "Thursday",
//         "Friday",
//         "Saturday",
//         "Sunday"
//       ],
//       tags = [];
//   String _from = '7:00 AM';
//   String _to = '8:00 PM';
//   Future<Restaurant>? restaurantDetail;

//   LatLng? locationFromMap;
//   double? locationFromMapLat, locationFromMapLon;

//   String? _selectedDay;

//   String backendUrl = 'https://esoora-backend-prod-qiymu.ondigitalocean.app';

//   @override
//   void initState() {
//     super.initState();
//     nameController.text = widget.restaurantData.name;
//     emailController.text = widget.restaurantData.address[0].email;
//     phoneController.text = widget.restaurantData.phoneNumber;
//     streetAddressController.text = widget.restaurantData.address[0].street;
//     cityController.text = widget.restaurantData.address[0].city;
//     descriptionController.text = widget.restaurantData.description;
//     imageUrls = widget.restaurantData.restaurantImageEntities;
//     latitudeController.text = widget.restaurantData.latitude.toString();
//     longitudeController.text = widget.restaurantData.longitude.toString();
//     _businessHourss = widget.restaurantData.openHours;
//     if (locationFromMapLat != null) {
//       latitudeController.text = locationFromMapLat!.toStringAsFixed(5);
//     }
//     if (locationFromMapLon != null) {
//       longitudeController.text = locationFromMapLon!.toStringAsFixed(5);
//     }
//     List<String> stringList = widget.restaurantData.tag.split(",");
//     List<String> list = [];
//     tags.addAll(stringList);
//     // Provider.of<Fetch>(context, listen: false).checkLogin();
//     restaurantDetail = Provider.of<Fetch>(context, listen: false)
//         .fetchRestaurantDetail(widget.restaurantData.id, context);
//     tags.addAll(list);
//   }

//   onRefresh() {
//     locationFromMapLat = null;
//     locationFromMapLon = null;
//     locationFromMapLat = locationFromMap!.latitude;
//     locationFromMapLon = locationFromMap!.longitude;
//     if (locationFromMapLat != null) {
//       latitudeController.text = locationFromMapLat!.toStringAsFixed(5);
//     }
//     if (locationFromMapLon != null) {
//       longitudeController.text = locationFromMapLon!.toStringAsFixed(5);
//     }
//     setState(() {});
//   }

//   // hideKeyboard() {
//   //   FocusScope.of(context).requestFocus(FocusNode());
//   // }

//   Future selectFile() async {
//     final result =
//         await ImagePicker.platform.pickImage(source: ImageSource.gallery);

//     if (result == null) return;
//     final path = result.path;

//     setState(() => file = File(path));
//     uploadFile();
//   }

//   Future uploadFile() async {
//     if (file == null) return;

//     final fileName = pa.basename(file!.path);
//     final destination = 'files/$fileName';

//     //task = FirebaseApi.uploadFile(destination, file!);
//     setState(() {
//       _isLoading = true;
//     });

//     if (task == null) return;

//     final snapshot = await task!.whenComplete(() {});
//     final _downloadURL = await snapshot.ref.getDownloadURL();

//     setState(() {
//       // urlDownload.add(_downloadURL);
//       imageUrls.add(RestaurantImageEntity(url: _downloadURL));
//       _isLoading = false;
//     });
//   }

//   void _removeImage(int index) {
//     setState(() {
//       imageUrls.removeAt(index);
//     });
//   }

//   void _removeDate(int index) {
//     setState(() {
//       _businessHourss.removeAt(index);
//     });
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
//                   ? '${imageUrls.length} Images added!'
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

//   Widget imageindex(String url, int index) {
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
//       CircleAvatar(
//         // radius: 17,
//         backgroundColor: AppColors.white,
//         child: IconButton(
//           onPressed: () => {_removeImage(index)},
//           icon: const Icon(Icons.delete_outline),
//           color: Colors.red,
//         ),
//       )
//     ]));
//   }

//   Widget timePicker() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Container(
//             decoration: const BoxDecoration(
//                 color: Colors.greenAccent,
//                 border: Border(bottom: BorderSide())),
//             padding: const EdgeInsets.all(5),
//             child: const Text(
//               'From',
//               style: TextStyle(fontSize: 15),
//             )),
//         Container(
//           decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
//           padding: const EdgeInsets.all(5),
//           child: GestureDetector(
//             onTap: () async {
//               TimeOfDay? _newTime = await showTimePicker(
//                 context: context,
//                 initialTime: TimeOfDay.now(),
//                 builder: (context, child) {
//                   return MediaQuery(
//                     data: MediaQuery.of(context)
//                         .copyWith(alwaysUse24HourFormat: false),
//                     child: child ?? Container(),
//                   );
//                 },
//               );
//               if (_newTime != null) {
//                 setState(() {
//                   _from = _newTime.format(context);
//                 });
//               }
//             },
//             child: Text(
//               _from,
//               style: const TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(
//           width: 12,
//         ),
//         Container(
//             decoration: const BoxDecoration(
//                 border: Border(bottom: BorderSide()), color: Colors.redAccent),
//             padding: const EdgeInsets.all(5),
//             child: const Text(
//               'To',
//               style: TextStyle(fontSize: 15),
//             )),
//         Container(
//           decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
//           padding: const EdgeInsets.all(5),
//           child: GestureDetector(
//             onTap: () async {
//               TimeOfDay? _newTime = await showTimePicker(
//                 context: context,
//                 initialTime: TimeOfDay.now(),
//                 builder: (context, child) {
//                   return MediaQuery(
//                     data: MediaQuery.of(context)
//                         .copyWith(alwaysUse24HourFormat: false),
//                     child: child ?? Container(),
//                   );
//                 },
//               );
//               if (_newTime != null) {
//                 setState(() {
//                   _to = _newTime.format(context);
//                 });
//               }
//             },
//             child: Text(
//               _to,
//               style: const TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//         _businessHourss.length < 7
//             // &&
//             // _businessHours.every((element) =>
//             //     '$_selectedDay,${_from.hour}' !=
//             //     '$_selectedDay,${_from.hour}')
//             ? Container(
//                 width: 40,
//                 height: 40,
//                 decoration: const BoxDecoration(
//                     color: AppColors.primary,
//                     borderRadius: BorderRadius.all(Radius.circular(15))),
//                 child: IconButton(
//                     onPressed: () {
//                       setState(() {
//                         if (_businessHourss.any((element) =>
//                             element.openDays.contains(_selectedDay!))) {
//                           Provider.of<Fetch>(context, listen: false)
//                               .scaffoldMessage(
//                                   context, 'Day already added!', Colors.red);
//                         } else {
//                           _businessHourss.add(OpenHour(
//                             openDays: '$_selectedDay',
//                             startTime: _from,
//                             endTime: _to,
//                           ));
//                         }
//                       });
//                     },
//                     icon: const Icon(
//                       Icons.add,
//                       color: AppColors.white,
//                     )))
//             : const SizedBox(
//                 width: 40,
//                 height: 40,
//                 child: Text(
//                   'Enough\n dates\n added!',
//                   style: TextStyle(fontSize: 10),
//                 ),
//               ),
//       ],
//     );
//   }

//   void confirmationDialogue() {
//     AwesomeDialog(
//       context: context,
//       animType: AnimType.TOPSLIDE,
//       headerAnimationLoop: false,
//       dialogType: DialogType.WARNING,
//       showCloseIcon: true,
//       title: 'Delete?',
//       desc: 'Are you sure you want to delete ${widget.restaurantData.name}?',
//       btnOkOnPress: () {
//         Provider.of<Fetch>(context, listen: false).deleteRestaurantHandler(
//             widget.restaurantData.id, widget.restaurantData.name, context);
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

//   void dialogue(String message) {
//     AwesomeDialog(
//       context: context,
//       animType: AnimType.TOPSLIDE,
//       headerAnimationLoop: false,
//       dialogType: DialogType.ERROR,
//       showCloseIcon: true,
//       title: 'Restaurant edite error!',
//       desc: message,
//       btnOkOnPress: () {
//         // Navigator.of(context).pop();
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

//   Future editRestaurant() async {
//     if (imageUrls.isNotEmpty) {
//       double latitude = double.parse(latitudeController.text);
//       double longitude = double.parse(longitudeController.text);
//       final url = Uri.parse('$backendUrl/restaurant');
//       String convertedTag =
//           tags.toString().replaceAll('[', '').replaceAll(']', '');
//       try {
//         final jsonBody = json.encode(Restaurant(
//             id: widget.restaurantData.id,
//             name: nameController.text,
//             tag: convertedTag,
//             address: address,
//             restaurantImageEntities: imageUrls,
//             description: descriptionController.text,
//             phoneNumber: phoneController.text,
//             openHours: _businessHourss,
//             latitude: latitude,
//             longitude: longitude,
//             menuId: []));
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
//           Navigator.of(context).pop();
//           Flushbar(
//             maxWidth: MediaQuery.of(context).size.width * 0.90,
//             backgroundColor: Colors.green,
//             flushbarPosition: FlushbarPosition.TOP,
//             title: 'Updated!',
//             message: 'You edited ${nameController.text} successfully!',
//             duration: const Duration(seconds: 2),
//           ).show(context);
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
//       Provider.of<Fetch>(context, listen: false)
//           .scaffoldMessage(context, 'Please add restaurant image', Colors.red);
//     }
//   }

//   void refresh() {
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final deviceWidth = MediaQuery.of(context).size.width;
//     // final fileName =
//     //     file != null ? pa.basename(file!.path) : 'No File Selected';

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
//       child: Stack(
//         children: [
//           Image.asset(
//             "assets/delivery_background.png",
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             fit: BoxFit.cover,
//           ),
//           Scaffold(
//               backgroundColor: AppColors.transparent,
//               appBar: AppBar(
//                 backgroundColor: AppColors.transparent,
//                 elevation: 0,
//                 leading: const BackButton(),
//                 title: const TitleFont(text: 'Edit Restaurant'),
//                 actions: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         backgroundColor: Colors.white,
//                         radius: 20,
//                         child: IconButton(
//                             onPressed: () {
//                               confirmationDialogue();
//                             },
//                             icon: const Icon(
//                               Icons.delete,
//                               color: Colors.red,
//                             )),
//                       ),
//                       const Padding(padding: EdgeInsets.only(right: 5))
//                     ],
//                   )
//                 ],
//               ),
//               body: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Form(
//                     key: _formKey,
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: <Widget>[
//                           // const SizedBox(
//                           //   height: 120,
//                           // ),
//                           Container(
//                             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                             child: TextFormField(
//                               maxLength: 30,
//                               textCapitalization: TextCapitalization.sentences,
//                               initialValue: widget.restaurantData.name,
//                               decoration: const InputDecoration(
//                                 enabledBorder: UnderlineInputBorder(
//                                     borderSide:
//                                         BorderSide(color: Colors.black)),
//                                 labelText: 'Restaurant Name',
//                               ),
//                               validator: (val) {
//                                 if (val.toString().isEmpty) {
//                                   return 'Restaurant name is required';
//                                 }

//                                 if (!(RegExp(r"^[a-zA-Z 1-9 ',]*$")
//                                     .hasMatch(val.toString()))) {
//                                   return 'Invalid restaurant name';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 nameController.text = value!;
//                               },
//                               onChanged: (value) {
//                                 nameController.text = value;
//                                 startedTyping = true;
//                               },
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                             child: TextFormField(
//                               keyboardType: TextInputType.emailAddress,
//                               initialValue:
//                                   widget.restaurantData.address[0].email,
//                               decoration: const InputDecoration(
//                                 enabledBorder: UnderlineInputBorder(
//                                     borderSide:
//                                         BorderSide(color: Colors.black)),
//                                 labelText: 'Email',
//                               ),
//                               validator: (value) {
//                                 if (value!.isEmpty ||
//                                     !(RegExp(
//                                             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                                         .hasMatch(value.toString()))) {
//                                   return 'Invalid email address';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 emailController.text = value!;
//                               },
//                               onChanged: (value) {
//                                 emailController.text = value;
//                                 startedTyping = true;
//                               },
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                             child: TextFormField(
//                               // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                               initialValue: widget.restaurantData.phoneNumber,
//                               keyboardType: TextInputType.number,
//                               decoration: const InputDecoration(
//                                 enabledBorder: UnderlineInputBorder(
//                                     borderSide:
//                                         BorderSide(color: Colors.black)),
//                                 labelText: 'Phone Number',
//                               ),
//                               validator: (value) {
//                                 if (value.toString().isEmpty) {
//                                   return 'Phone number is required';
//                                 }
//                                 if (!RegExp(r"^(?:[+0]9)?[0-9]{10}$")
//                                     .hasMatch(value.toString())) {
//                                   return 'invalid phone number';
//                                 }
//                                 // if (value.length > 9) {
//                                 //   return 'Invalid phone number entered';
//                                 // }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 phoneController.text = value!;
//                                 // }
//                               },
//                               onChanged: (value) {
//                                 phoneController.text = value;
//                                 startedTyping = true;
//                               },
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                             child: TextFormField(
//                               maxLength: 30,
//                               textCapitalization: TextCapitalization.sentences,
//                               initialValue:
//                                   widget.restaurantData.address[0].street,
//                               decoration: const InputDecoration(
//                                 enabledBorder: UnderlineInputBorder(
//                                     borderSide:
//                                         BorderSide(color: Colors.black)),
//                                 labelText: 'Street address',
//                               ),
//                               validator: (val) {
//                                 if (val.toString().isEmpty) {
//                                   return 'Street address is required';
//                                 }

//                                 if (!(RegExp(r"^[a-zA-Z 0-9 ,']*$")
//                                     .hasMatch(val.toString()))) {
//                                   return 'Invalid Address';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 streetAddressController.text = value!;
//                               },
//                               onChanged: (value) {
//                                 streetAddressController.text = value;
//                                 startedTyping = true;
//                               },
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                             child: TextFormField(
//                               maxLength: 20,
//                               textCapitalization: TextCapitalization.sentences,
//                               initialValue:
//                                   widget.restaurantData.address[0].city,
//                               decoration: const InputDecoration(
//                                 enabledBorder: UnderlineInputBorder(
//                                     borderSide:
//                                         BorderSide(color: Colors.black)),
//                                 labelText: 'City',
//                               ),
//                               validator: (val) {
//                                 if (val.toString().isEmpty) {
//                                   return 'City is required';
//                                 }

//                                 if (!(RegExp(r"^[a-zA-Z 0-9 ]*$")
//                                     .hasMatch(val.toString()))) {
//                                   return 'Invalid City';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 cityController.text = value!;
//                               },
//                               onChanged: (value) {
//                                 cityController.text = value;
//                                 startedTyping = true;
//                               },
//                             ),
//                           ),
//                           if (tags.length < 5)
//                             Container(
//                               padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                               child: TextFormField(
//                                 maxLength: 20,
//                                 textCapitalization:
//                                     TextCapitalization.sentences,
//                                 // initialValue: widget.restaurantData.tag,
//                                 controller: tagsController,
//                                 decoration: const InputDecoration(
//                                   enabledBorder: UnderlineInputBorder(
//                                       borderSide:
//                                           BorderSide(color: Colors.black)),
//                                   labelText: 'Tags',
//                                 ),
//                                 validator: (val) {
//                                   if (tags.isEmpty && val!.isEmpty) {
//                                     return 'Tags is required';
//                                   }
//                                   if (tags.isEmpty && val!.isNotEmpty) {
//                                     return 'Please save your input on this field';
//                                   }

//                                   if (val.toString().characters.length > 20) {
//                                     return 'No more than 20 characters';
//                                   }
//                                   return null;
//                                 },
//                                 onFieldSubmitted: (value) {
//                                   if (value.isNotEmpty &&
//                                       value != ' ' &&
//                                       value != '  ' &&
//                                       value != '   ' &&
//                                       value != '    ' &&
//                                       value != '     ') {
//                                     setState(() {
//                                       tags.add(value);
//                                       tagsController.clear();
//                                     });
//                                   }
//                                   return;
//                                 },
//                                 onSaved: (value) {
//                                   tagsController.text = value!;
//                                 },
//                                 onChanged: (val) {
//                                   startedTyping = true;
//                                 },
//                               ),
//                             ),
//                           if (tags.isNotEmpty)
//                             ChipsWidget(
//                               list: tags,
//                               refresh: refresh,
//                               detailPage: false,
//                             ),
//                           Container(
//                             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                             child: TextFormField(
//                               maxLength: 250,
//                               textCapitalization: TextCapitalization.sentences,
//                               initialValue: widget.restaurantData.description,
//                               maxLines: null,
//                               decoration: const InputDecoration(
//                                 enabledBorder: UnderlineInputBorder(
//                                     borderSide:
//                                         BorderSide(color: Colors.black)),
//                                 labelText: 'Restaurant Description',
//                               ),
//                               validator: (val) {
//                                 if (val.toString().isEmpty) {
//                                   return 'Restaurant Description is required';
//                                 }

//                                 if (val.toString().characters.length > 250) {
//                                   return 'No more than 250 characters';
//                                 }

//                                 // if (!(RegExp(
//                                 //         r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
//                                 //     .hasMatch(val.toString()))) {
//                                 //   return 'Invalid Description';
//                                 // }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 descriptionController.text = value!;
//                               },
//                               onChanged: (value) {
//                                 descriptionController.text = value;
//                                 startedTyping = true;
//                               },
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           FractionallySizedBox(
//                             widthFactor: 1,
//                             child: Container(
//                               padding: const EdgeInsets.only(left: 10),
//                               child: const Text(
//                                 'Location',
//                                 style: TextStyle(fontSize: 16),
//                                 textAlign: TextAlign.start,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                     child: SizedBox(
//                                       height: 100,
//                                       width: MediaQuery.of(context).size.width *
//                                           0.3,
//                                       child: TextFormField(
//                                         maxLength: 10,
//                                         // initialValue: widget.restaurantData.latitude.toString(),
//                                         controller: latitudeController,
//                                         keyboardType: TextInputType.number,
//                                         decoration: const InputDecoration(
//                                           // suffixIcon: Icon(Icons.numbers),
//                                           enabledBorder: UnderlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: Colors.black)),
//                                           labelText: 'Latitude',
//                                         ),
//                                         validator: (value) {
//                                           if (value.toString().isEmpty) {
//                                             return 'Latitude is required';
//                                           }
//                                           if (!RegExp(
//                                                   '^-?([1-8]?[1-9]|[1-9]0)\\.{1}\\d{1,6}')
//                                               .hasMatch(value.toString())) {
//                                             return 'invalid latitude';
//                                           }
//                                           // if (value.length > 9) {
//                                           //   return 'Invalid phone number entered';
//                                           // }
//                                           return null;
//                                         },
//                                         onSaved: (value) {
//                                           latitudeController.text = value!;
//                                           // }
//                                         },
//                                         onChanged: (value) {
//                                           latitudeController.text = value;
//                                           startedTyping = true;
//                                         },
//                                       ),
//                                     )),
//                                 GestureDetector(
//                                   onTap: () async {
//                                     final result = await Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => GoogleMapScreen(
//                                                 latitude: widget
//                                                     .restaurantData.latitude,
//                                                 longitude: widget
//                                                     .restaurantData.longitude,
//                                                 restaurantName:
//                                                     widget.restaurantData.name,
//                                               )),
//                                     );

//                                     // After the Selection Screen returns a result, hide any previous snackbars
//                                     // and show the new result.
//                                     // ScaffoldMessenger.of(context)
//                                     //   ..removeCurrentSnackBar()
//                                     //   ..showSnackBar(
//                                     //       SnackBar(content: Text('$result')));
//                                     locationFromMap = result;
//                                     onRefresh();
//                                   },
//                                   child: Column(
//                                     children: const [
//                                       CircleAvatar(
//                                         radius: 30,
//                                         backgroundColor: AppColors.primary,
//                                         child: Icon(
//                                           Icons.pin_drop,
//                                           size: 40,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 2,
//                                       ),
//                                       TitleFont(
//                                         text: 'Pick on map',
//                                         size: 12,
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                     child: SizedBox(
//                                       height: 100,
//                                       width: MediaQuery.of(context).size.width *
//                                           0.3,
//                                       child: TextFormField(
//                                         maxLength: 10,
//                                         // initialValue: widget.restaurantData.longitude.toString(),
//                                         controller: longitudeController,
//                                         keyboardType: TextInputType.number,
//                                         decoration: const InputDecoration(
//                                           // suffixIcon: Icon(Icons.numbers),
//                                           enabledBorder: UnderlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: Colors.black)),
//                                           labelText: 'Longitude',
//                                         ),
//                                         validator: (value) {
//                                           if (value.toString().isEmpty) {
//                                             return 'Longitude is required';
//                                           }
//                                           if (!RegExp(
//                                                   '^-?([1-8]?[1-9]|[1-9]0)\\.{1}\\d{1,6}')
//                                               .hasMatch(value.toString())) {
//                                             return 'invalid longitude';
//                                           }
//                                           // if (value.length > 9) {
//                                           //   return 'Invalid phone number entered';
//                                           // }
//                                           return null;
//                                         },
//                                         onSaved: (value) {
//                                           longitudeController.text = value!;
//                                           // }
//                                         },
//                                         onChanged: (value) {
//                                           longitudeController.text = value;
//                                           startedTyping = true;
//                                         },
//                                       ),
//                                     ))
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Container(
//                               padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
//                               child:
//                                   //  imageUrls.isNotEmpty
//                                   //     ?
//                                   Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   // imageUrls.length >= 5
//                                   //     ? Container()
//                                   //     : ElevatedButton.icon(
//                                   //         style: ElevatedButton.styleFrom(
//                                   //             primary: AppColors.primary),
//                                   //         icon: const Icon(
//                                   //           Icons.add,
//                                   //           color: AppColors.white,
//                                   //         ),
//                                   //         onPressed: selectFile,
//                                   //         label: const InfoFont(
//                                   //           text: 'Add more',
//                                   //           color: AppColors.white,
//                                   //           size: 20,
//                                   //         ),
//                                   //       ),
//                                   // const SizedBox(height: 8),
//                                   // Text(
//                                   //   imageUrls.isNotEmpty ? fileName : '',
//                                   //   style: const TextStyle(
//                                   //       fontSize: 16,
//                                   //       fontWeight: FontWeight.w500),
//                                   // ),
//                                   // SizedBox(height: 48),
//                                   // ButtonWidget(
//                                   //   text: 'Upload File',
//                                   //   icon: Icons.cloud_upload_outlined,
//                                   //   onClicked: uploadFile,
//                                   // ),
//                                   // const SizedBox(height: 20),
//                                   SizedBox(
//                                     height: 150,
//                                     // imageUrls.isNotEmpty ? 190 : 5,
//                                     child: Row(
//                                       children: [
//                                         Expanded(
//                                           flex: deviceWidth > 380 ? 15 : 10,
//                                           child: ListView.builder(
//                                             primary: false,
//                                             shrinkWrap: true,
//                                             scrollDirection: Axis.horizontal,
//                                             itemBuilder: (ctx, index) =>
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: index == 0
//                                                             ? 25
//                                                             : 0),
//                                                     child: imageindex(
//                                                         imageUrls[index].url,
//                                                         index)),
//                                             itemCount: imageUrls.length,
//                                           ),
//                                         ),
//                                         // if (_isLoading)
//                                         // CustomShimmer.rectangular(
//                                         //   height: MediaQuery.of(context)
//                                         //           .size
//                                         //           .height *
//                                         //       0.3,
//                                         //   width: MediaQuery.of(context)
//                                         //           .size
//                                         //           .width *
//                                         //       0.22,
//                                         // ),
//                                         const SizedBox(
//                                           width: 2,
//                                         ),
//                                         if (imageUrls.length < 5)
//                                           Expanded(
//                                             flex: 5,
//                                             child: GestureDetector(
//                                               onTap: _isLoading
//                                                   ? null
//                                                   : () {
//                                                       selectFile();
//                                                       startedTyping = true;
//                                                     },
//                                               child: Container(
//                                                 // width: deviceWidth > 380
//                                                 //     ? deviceWidth * 0.22
//                                                 //     : deviceWidth * 0.5,
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             20),
//                                                     border: Border.all(
//                                                         color:
//                                                             AppColors.black)),
//                                                 child: Center(
//                                                   child: _isLoading
//                                                       ? MoreLoadingGif(
//                                                           type:
//                                                               MoreLoadingGifType
//                                                                   .ripple)
//                                                       : Row(
//                                                           mainAxisSize:
//                                                               MainAxisSize.min,
//                                                           children: [
//                                                             const Icon(
//                                                                 Icons.add),
//                                                             DescriptionFont(
//                                                                 text: imageUrls
//                                                                         .isEmpty
//                                                                     ? 'Add Images'
//                                                                     : 'Add More'),
//                                                           ],
//                                                         ),
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                       ],
//                                     ),
//                                   ),
//                                   task != null
//                                       ? _buildUploadStatus(task!)
//                                       : Container(),
//                                 ],
//                               )
//                               // : ElevatedButton.icon(
//                               //     style: ElevatedButton.styleFrom(
//                               //         primary: AppColors.primary),
//                               //     onPressed: () => {selectFile()},
//                               //     icon: const Icon(
//                               //       Icons.image,
//                               //       color: AppColors.white,
//                               //     ),
//                               //     label: const InfoFont(
//                               //       text: 'Add Image',
//                               //       color: AppColors.white,
//                               //       size: 20,
//                               //     )),
//                               // : GestureDetector(
//                               //     onTap: () => {selectFile()},
//                               //     child: Text(
//                               //       'Add Image',
//                               //       style: TextStyle(fontSize: 16),
//                               //     ),
//                               //   ),
//                               ),
//                           const SizedBox(height: 20),
//                           FractionallySizedBox(
//                             widthFactor: 1,
//                             child: Container(
//                               padding: const EdgeInsets.only(left: 10),
//                               child: const Text(
//                                 'Business Hours',
//                                 style: TextStyle(fontSize: 16),
//                                 textAlign: TextAlign.start,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                             child: Column(
//                               // mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 DropdownButtonFormField<String>(
//                                   hint: const Text('Select working days'),
//                                   onChanged: (String? newValue) {
//                                     setState(() {
//                                       _selectedDay = newValue!;
//                                     });
//                                   },
//                                   isExpanded: true,
//                                   items: days.map<DropdownMenuItem<String>>(
//                                       (String value) {
//                                     return DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(value),
//                                     );
//                                   }).toList(),
//                                   validator: (value) {
//                                     if (_businessHourss.isEmpty) {
//                                       return 'Please specify working days';
//                                     }
//                                     return null;
//                                   },
//                                   value: _selectedDay,
//                                 ),
//                                 // DropDown('Day *', _days, false, false, true)),
//                                 const SizedBox(height: 15),
//                                 _selectedDay != null
//                                     ? Container(child: timePicker())
//                                     : Container(),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 _businessHourss.isEmpty
//                                     //&& openDays.length == 0 &&
//                                     // startTime.length == 0 &&
//                                     // endTime.length == 0
//                                     ? Container()
//                                     : Column(
//                                         children: [
//                                           const SizedBox(height: 8.0),
//                                           const Info2Font(
//                                             text: 'Added Business Hours',
//                                             size: 20,
//                                           ),
//                                           ListView.builder(
//                                               primary: false,
//                                               shrinkWrap: true,
//                                               itemBuilder: (ctx, index) {
//                                                 return Container(
//                                                     // padding: EdgeInsets.all(5.0),
//                                                     margin: const EdgeInsets
//                                                             .symmetric(
//                                                         vertical: 3.0),
//                                                     color: const Color.fromARGB(
//                                                         97, 136, 126, 126),
//                                                     // width: MediaQuery.of(context)
//                                                     //         .size
//                                                     //         .width *
//                                                     //     0.3,
//                                                     child: ListTile(
//                                                       trailing: IconButton(
//                                                         icon: const Icon(
//                                                           Icons.delete,
//                                                           color: Colors.red,
//                                                         ),
//                                                         onPressed: () {
//                                                           _removeDate(index);
//                                                         },
//                                                       ),
//                                                       title: DescriptionFont(
//                                                         text:
//                                                             "${_businessHourss[index].openDays} from ${_businessHourss[index].startTime} to ${_businessHourss[index].endTime}",
//                                                         size: deviceWidth > 380
//                                                             ? 15
//                                                             : 12,
//                                                       ),
//                                                     ));
//                                               },
//                                               itemCount:
//                                                   _businessHourss.length),
//                                         ],
//                                       ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 30,
//                           ),
//                           FractionallySizedBox(
//                               widthFactor: 1,
//                               child: ButtonWidget(
//                                   text: 'Done',
//                                   onClicked: () {
//                                     if (_formKey.currentState!.validate()) {
//                                       address.add(Address(
//                                           street: streetAddressController.text,
//                                           city: cityController.text,
//                                           email: emailController.text));
//                                       editRestaurant();
//                                     }
//                                   })),
//                         ],
//                       ),
//                     ),
//                   ))),
//         ],
//       ),
//     );
//   }
// }
