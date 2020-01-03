import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrecycle/tabscreen/tabscreen3.dart';
import 'package:place_picker/place_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myrecycle/user.dart';
//import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loadmore/loadmore.dart';
import 'package:myrecycle/rewarddetail.dart';
import 'package:myrecycle/reward.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

double perpage = 1;

class TabScreen3 extends StatefulWidget {
  User user;
  TabScreen3({Key key,this.user}):super(key:key);

  @override
  _TabScreen3State createState() => _TabScreen3State();
}

class _TabScreen3State extends State<TabScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              titleSpacing: 20,
              automaticallyImplyLeading: false,
              title: Text('Notification',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
              backgroundColor: Colors.transparent,
              centerTitle: false,
         
              actions: <Widget>[
                
                
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [   
                    ListTile(
                      title: Text('Your item is already been approved. Please take a look.'),
                      
                    ),
                    Divider(color: Colors.black38,)
                ]
              ),
            )
          ],
        ),
    );
  }
}