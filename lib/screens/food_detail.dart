import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:urban_restaurant/style/colors.dart';
import 'package:urban_restaurant/style/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:provider/provider.dart';
import '../providers/fetch_and_post.dart';
import '../widgets/image_view.dart';

class FoodDetail extends StatefulWidget {
  final List<dynamic> foodImage;
  final String name;
  final String? restaurantName;
  // final String? restaurantPhone;
  final String description;
  final int price;
  final int? restaurantId;
  const FoodDetail({
    Key? key,
    required this.foodImage,
    required this.name,
    this.restaurantName,
    required this.description,
    required this.price,
    required this.restaurantId,
  }) : super(key: key);

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  String? phoneNumber, restaurantName, street, city;
  String backendUrl = 'https://esoora-backend-prod-qiymu.ondigitalocean.app';

  @override
  void initState() {
    super.initState();
    fetchRestaurantDetail(context);
  }

  scaffoldMessage(context, String message, Color bkgrdClr) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      backgroundColor: bkgrdClr,
    ));
  }

  Future<void> fetchRestaurantDetail(context) async {
    int timeout = 10;
    final url =
        Uri.parse('$backendUrl/public/restaurant/${widget.restaurantId}');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: timeout));
      // rint('this is return$jsonResponse['phoneNumber']');
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          phoneNumber = jsonResponse['phoneNumber'];
          restaurantName = jsonResponse['name'];
          street = jsonResponse['address'][0]['street'];
          city = jsonResponse['address'][0]['city'];
        });
      }
      // else {
      //   throw ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     behavior: SnackBarBehavior.floating,
      //     content: Text('Error Occured!'),
      //     backgroundColor: Colors.red,
      //   ));
      // }
    } on TimeoutException {
      scaffoldMessage(
          context, 'Network is timedout please try again later', Colors.red);
    } on SocketException {
      scaffoldMessage(
          context,
          'Network is unreachable! Please check your internet connection.',
          Colors.red);
    }
    // on Error catch (e) {
    //   scaffoldMessage(context, 'Error Occured!', Colors.red);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
        leading: const BackButton(),
        // title: Text(widget.name),
        // actions: [
        //   Row(
        //     children: [
        //       CircleAvatar(
        //         backgroundColor: Colors.white,
        //         radius: 20,
        //         child: IconButton(
        //             onPressed: () {
        //               // confirmationDialogue();
        //             },
        //             icon: const Icon(
        //               Icons.delete,
        //               color: Colors.red,
        //             )),
        //       ),
        //       const Padding(padding: EdgeInsets.only(right: 5))
        //     ],
        //   )
        // ],
      ),
      floatingActionButton: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width - 40),
        child: ElevatedButton(
          onPressed: () => {
            //order page
            phoneNumber != null
                ? Provider.of<Fetch>(context, listen: false)
                    .callNow(phoneNumber!)
                : null
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              textStyle:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              phoneNumber != null
                  ? InfoFont(
                      text: 'Call to order $phoneNumber',
                      fontWeight: FontWeight.w600,
                      size: 20,
                      color: AppColors.white,
                    )
                  : const SizedBox(
                      width: 25,
                      height: 25,
                      child: MoreLoadingGif(type: MoreLoadingGifType.ellipsis),
                    ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.white,
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView(
        children: [
          // CustomAppBar(
          //   context: context,
          //   widget: Container(
          //     padding: const EdgeInsets.all(10),
          //     decoration: BoxDecoration(
          //       color: AppColors.primary,
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     child: const Icon(Icons.star, color: AppColors.white),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: widget.name,
                  size: 45,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SvgPicture.asset(
                    //   'assets/dollar.svg',
                    //   color: AppColors.tertiary,
                    //   width: 15,
                    // ),
                    const Text(
                      'Birr',
                      style: TextStyle(fontSize: 15, color: AppColors.tertiary),
                    ),
                    PrimaryText(
                      text: '${widget.price}',
                      size: 48,
                      fontWeight: FontWeight.w700,
                      color: AppColors.tertiary,
                      height: 1,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Info2Font(
                                text: 'From',
                                color: AppColors.grey,
                                size: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              restaurantName != null
                                  ? DescriptionFont(
                                      text: restaurantName!,
                                      size: 20,
                                      fontWeight: FontWeight.w600)
                                  : const MoreLoadingGif(
                                      size: 25,
                                      type: MoreLoadingGifType.ellipsis),
                              const SizedBox(
                                height: 15,
                              ),
                              const Info2Font(
                                text: 'Location',
                                color: AppColors.grey,
                                size: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              street != null
                                  ? DescriptionFont(
                                      text: '$street, $city',
                                      size: 20,
                                      fontWeight: FontWeight.w600)
                                  : const MoreLoadingGif(
                                      size: 25,
                                      type: MoreLoadingGifType.ellipsis),
                              const SizedBox(
                                height: 15,
                              ),
                              // PrimaryText(
                              //   text: 'Delivery in',
                              //   color: AppColors.lightGray,
                              //   size: 16,
                              //   fontWeight: FontWeight.w500,
                              // ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              // PrimaryText(
                              //     text: '30 min', fontWeight: FontWeight.w600),
                            ]),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Hero(
                        tag: widget.foodImage,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(color: Colors.grey, blurRadius: 30),
                            ],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          height: 200,
                          child: GestureDetector(
                              child: Container(
                                transform:
                                    Matrix4.translationValues(20, 0.0, 0.0),
                                // constraints: BoxConstraints(
                                //     maxHeight: MediaQuery.of(context).size.width * 0.75,
                                //     maxWidth: double.infinity),
                                child: CircleAvatar(
                                    radius: 100,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        NetworkImage(widget.foodImage[0].url)),
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return ImageView(
                                    img: widget.foodImage[0].url,
                                  );
                                }));
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                const Info2Font(
                    color: AppColors.grey,
                    text: 'Food Info',
                    fontWeight: FontWeight.w700,
                    size: 16),
                const SizedBox(
                  height: 15,
                ),
                DescriptionFont(
                  text: widget.description,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  size: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Info2Font(
                    color: AppColors.grey,
                    text: 'Food Pictures',
                    fontWeight: FontWeight.w700,
                    size: 16),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.foodImage.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: index == 0 ? 20 : 0),
                child: restaurantImageCard(widget.foodImage[index].url),
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  Container restaurantImageCard(String foodImage) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        margin: const EdgeInsets.only(
          right: 20,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.white,
            boxShadow: const [
              BoxShadow(blurRadius: 10, color: AppColors.lightGray),
            ]),
        child: GestureDetector(
          child: Image.network(
            foodImage,
            width: 90,
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ImageView(
                img: foodImage,
              );
            }));
          },
        ));
  }
}
