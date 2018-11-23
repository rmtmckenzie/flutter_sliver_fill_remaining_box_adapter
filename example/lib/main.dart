import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sliver_fill_remaining_box_adapter/sliver_fill_remaining_box_adapter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int numItems = 3;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Fill remaining with $numItems boxes"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                print("Added!\n\n\n\n");
                setState(() => numItems += 1);
              },
            ),
            IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                print("Removed!\n\n\n\n");
                setState(() => numItems = numItems > 0 ? numItems - 1 : numItems);
              },
            )
          ],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, val) => Container(
                      height: 300,
                      color: Color(0xFF000000 | math.Random(val + 12234443).nextInt(0xFFFFFF)),
                      alignment: Alignment.center,
                      child: Text("Item number $val"),
                    ),
                childCount: numItems,
              ),
            ),
            SliverFillRemainingBoxAdapter(
              child: Container(
                color: Colors.black,
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(
                    "This is filling the remaining or using\nits child's height if no remaining.",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
