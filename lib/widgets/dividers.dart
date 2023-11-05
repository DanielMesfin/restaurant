import 'package:urban_restaurant/style/style.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final String title;
  const DividerWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: const Divider(
              color: Colors.grey,
              height: 36,
            )),
      ),
      Info4Font(
        text: title,
        size: 20,
      ),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: const Divider(
              color: Colors.grey,
              height: 36,
            )),
      ),
    ]);
  }
}
