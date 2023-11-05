import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'image_view.dart';

class CarouselWidget extends StatefulWidget {
  final dynamic imagesList;
  const CarouselWidget({Key? key, required this.imagesList}) : super(key: key);

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
    if (widget.imagesList.length == 1) {
      return GestureDetector(
        child: Hero(
          tag: getRandomString(5),
          child: Image(
            image: NetworkImage(widget.imagesList[0].url),
            fit: BoxFit.cover,
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ImageView(
              img: widget.imagesList[0].url,
            );
          }));
        },
      );
    }
    return CarouselSlider.builder(
      itemCount: widget.imagesList.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return GestureDetector(
          child: Hero(
            tag: getRandomString(6),
            child: Image(
              image: NetworkImage(widget.imagesList[index].url),
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ImageView(
                img: widget.imagesList[index].url,
              );
            }));
          },
        );
      },

      //Slider Container properties
      options: CarouselOptions(
        // height: 180.0,
        enlargeCenterPage: true,
        autoPlay: true,
        // aspectRatio: 16 / 9,
        autoPlayCurve: Curves.linearToEaseOut,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
        viewportFraction: 0.65,
      ),
    );
  }
}
