import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';

class TabScreen2 extends StatefulWidget {
  @override
  _TabScreen2State createState() => _TabScreen2State();
}

class _TabScreen2State extends State<TabScreen2> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('haha'),
        ),
        body: Center(
          child: GestureDetector(
            child: Text("Tap me"),
            onTap: () async {
              
              LocationResult result = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => PlacePicker(
                          "AIzaSyCjm6b7WXTEmdfw529DnrKL3OTl4Wq0_5Q")));

              // Handle the result in your way
              print(result);
            },
          ),
        ),
      ),
    );
  }
}
