import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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
          const SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('List of Restaurant',
                  style: TextStyle(color: Colors.black)),
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
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("List of restaurant "), Icon(Icons.navigate_next)],
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: double.infinity,
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Card(
                color: Colors.green,
                child: Container(
                  width: 200,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Card(
                color: Colors.black,
                child: Container(
                  width: 200,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Card(
                color: Colors.green,
                child: Container(
                  width: 200,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Card(
                color: Colors.black,
                child: Container(
                  width: 200,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Near By restaurant "),
            Icon(Icons.navigation_rounded)
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.black12,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.green[200],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.orange[200],
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
            color: Colors.black12,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.green[200],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.orange[200],
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
