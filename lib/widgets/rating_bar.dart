import 'package:urban_restaurant/style/colors.dart';
import 'package:urban_restaurant/style/style.dart';
import 'package:flutter/material.dart';

class RatingBarWidget extends StatelessWidget {
  final double rate;
  const RatingBarWidget({Key? key, required this.rate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stars = <Widget>[];

    for (var i = 1; i <= 5; i++) {
      Color color;
      if (i <= rate) {
        color = AppColors.primary;
      } else {
        color = Colors.black12;
      }
      var star = Icon(
        Icons.star,
        color: color,
        size: 15,
      );

      stars.add(star);
    }
    if (rate == 0.0) {
      return const Info4Font(
        text: 'Not Rated',
      );
    }
    return Row(children: stars);
  }
}
