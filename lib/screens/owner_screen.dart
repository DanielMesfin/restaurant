import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OwnerScreen extends StatefulWidget {
  @override
  _OwnerScreenState createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
  ScrollController _scrollController = ScrollController();
  bool isAppBarExpanded = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          isAppBarExpanded) {
        setState(() {
          isAppBarExpanded = false;
        });
      }
      if (_scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          !isAppBarExpanded) {
        setState(() {
          isAppBarExpanded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'List of Orders',
                style: TextStyle(color: Colors.black),
              ),
              background: Image(
                image: AssetImage("assets/esoora_logo.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFillRemaining(
            child: ListOfOrders(), // Replace with your map widget
          ),
        ],
      ),
    );
  }
}

class ListOfOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: [
        SizedBox(
          height: 30,
        ),
        Card(
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.red[200],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.red[200],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.red[200],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.red[200],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.red[200],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.red[200],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.red[200],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.red[200],
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
