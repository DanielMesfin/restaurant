import 'package:urban_restaurant/screens/search_dialogue.dart';
import 'package:urban_restaurant/style/colors.dart';
import 'package:flutter/material.dart';

import '../style/style.dart';

class ChipsWidget extends StatefulWidget {
  List<String> list;
  final VoidCallback? refresh;
  final bool? detailPage;
  ChipsWidget({Key? key, required this.list, this.refresh, this.detailPage})
      : super(key: key);

  @override
  State<ChipsWidget> createState() => _ChipsWidgetState();
}

class _ChipsWidgetState extends State<ChipsWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (widget.detailPage!) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return SearchDialogue(
                      searchString: widget.list[index],
                    );
                  }));
                },
                child: Chip(
                  backgroundColor: AppColors.secondary,
                  label: DescriptionFont(text: widget.list[index]),
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InputChip(
              onDeleted: () {
                setState(() {
                  widget.list.removeAt(index);
                  widget.refresh!();
                });
              },
              deleteIcon: const Icon(Icons.cancel),
              deleteIconColor: AppColors.secondary,
              backgroundColor: AppColors.primary,
              // avatar: CircleAvatar(
              //   child: Text("C"),
              //   backgroundColor: Colors.white,
              // ),
              label: DescriptionFont(
                text: widget.list[index],
                color: AppColors.white,
              ),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount: widget.list.length,
        // shrinkWrap: true,
      ),
    );
  }
}
