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

class TabScreen2 extends StatefulWidget {
  final User user;
  TabScreen2({Key key, this.user}) : super(key: key);
  @override
  _TabScreen2State createState() => _TabScreen2State();
}

class _TabScreen2State extends State<TabScreen2>
    with SingleTickerProviderStateMixin {
  GlobalKey<RefreshIndicatorState> refreshKey;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";
  int _selectedIndex = 0;

  List<IconData> _icons = [
    Icons.search,
    FontAwesomeIcons.plane,
    Icons.fastfood,

    FontAwesomeIcons.shoppingCart,
    Icons.local_drink,
    
  ];
  Widget _buildIcon(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          color: _selectedIndex == index ? Colors.teal[100] : Color(0xFFE7EBEE),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Icon(
          _icons[index],
          size: 25.0,
          color: Colors.cyan,
        ),
      ),
    );
  }

  List rw = new List();
  List rewards = new List();
  TabController tabController;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    tabController = TabController(vsync: this, length: 5);
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            top: false,
            child: RefreshIndicator(
              key: refreshKey,
              color: Colors.pinkAccent,
              onRefresh: () async {
                await refreshList();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 180,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                _buildIcon(0),
                                _buildIcon(1),
                                _buildIcon(2),
                                _buildIcon(3),
                                _buildIcon(4),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AppBar(
                        brightness: Brightness.light,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        title: Text(
                          'My Recycle Points',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  _selectedIndex == 0
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: rewards == null ? 1 : rewards.length + 1,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: 0, right: 15, left: 15, bottom: 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Today's Deals",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[900]),
                                          ),
                                          Text(
                                            "${widget.user.points} points",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }

                              if (index == rewards.length && perpage > 1) {
                                return Container(
                                  padding: EdgeInsets.all(15),
                                  width: 250,
                                  color: Colors.white,
                                  child: MaterialButton(
                                    child: Text(
                                      "Load more",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {},
                                  ),
                                );
                              }

                              index -= 1;
                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 15, top: 15),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[300],
                                            offset: Offset(0, 0),
                                            blurRadius: 5)
                                      ]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Material(
                                      child: InkWell(
                                        highlightColor:
                                            Colors.white.withAlpha(50),
                                        onTap: () => onRewardDetail(
                                            rewards[index]['itemid'],
                                            rewards[index]['itemname'],
                                            rewards[index]['itemdesc'],
                                            rewards[index]['itempoint'],
                                            rewards[index]['itemimage'],
                                            rewards[index]['itemtype'],
                                            rewards[index]['itemcode'],
                                            rewards[index]['itemtime']),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                child: Image.network(
                                                    "http://lawlietaini.com/myrecycle_user/images/${rewards[index]['itemimage']}.jpg")),
                                            Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        rewards[index]
                                                            ['itemname'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      //  SizedBox(width: 50,),
                                                      Container(
                                                          height: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 5,
                                                            right: 5,
                                                          ),
                                                          child: Container(
                                                              child: Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .card_giftcard,
                                                                color: Colors
                                                                    .grey[700],
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "${rewards[index]['itempoint']}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .green[
                                                                        700]),
                                                              ),
                                                              Text(" Points"),
                                                            ],
                                                          )))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Flexible(
                                                        flex: 3,
                                                        fit: FlexFit.tight,
                                                        child: Text(
                                                            rewards[index]
                                                                ['itemdesc']),
                                                      ),
                                                      Icon(Icons.chevron_right)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : _rewardType(_selectedIndex-1)
                ],
              ),
            ),
          )),
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  Future<String> makeRequest() async {
    String urlLoadItems =
        "http://lawlietaini.com/myrecycle_user/php/load-redeem.php";

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Loading');
    pr.show();
    http.post(urlLoadItems, body: {
      //"email": widget.user.email ?? "notvail",
    }).then((res) {
      print("enter");
      print(res.body);
      setState(() {
        var extractdata = json.decode(res.body);
        rewards = extractdata["redeem"];
        perpage = (rewards.length / 10);
        print("enter point");
        print(rewards);
        // Toast.show(res.body, context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.name},${place.locality},${place.postalCode},${place.country}";

        //load data from database into list array 'data'
        init();
      });
    } catch (e) {
      print(e);
    }
  }

  Future init() async {
    this.makeRequest();
    //_getCurrentLocation();
  }

  void _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  void onRewardDetail(String rewardid, rewardname, rewarddesc, rewardpoint,
      rewardimage, rewardtype, rewardcode, rewarddateend) {
    Reward reward = new Reward(
        rewardid: rewardid,
        rewardname: rewardname,
        rewarddesc: rewarddesc,
        rewardpoint: rewardpoint,
        rewardimage: rewardimage,
        rewardtype: rewardtype,
        rewardcode: rewardcode,
        rewarddataend: rewarddateend);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RewardDetail(
                  reward: reward,
                  user: widget.user,
                )));
  }

  Widget _rewardType(int index) {
    var a = 0;
    List la;
    print(index);
     print(rewards[index]['itemtype']);
    
    print(index);
    for(int i=index+1; i<rewards.length; i++){
      print(i);
    if (rewards[index]['itemtype'] == 'FOOD') {
      a = 1;
      index = 1;
      
      break;
      
    }}
     // index = a;
      print("this is ${index}");
        return Expanded(
            child: Padding(
          padding: EdgeInsets.only(top: 0, right: 15, left: 15, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Today's Deals",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900]),
                  ),
                  Text(
                    "${widget.user.points} points",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  margin: EdgeInsets.only(bottom: 15, top: 15),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[300],
                            offset: Offset(0, 0),
                            blurRadius: 5)
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      child: InkWell(
                        highlightColor: Colors.white.withAlpha(50),
                        onTap: () => onRewardDetail(
                            rewards[index]['itemid'],
                            rewards[index]['itemname'],
                            rewards[index]['itemdesc'],
                            rewards[index]['itempoint'],
                            rewards[index]['itemimage'],
                            rewards[index]['itemtype'],
                            rewards[index]['itemcode'],
                            rewards[index]['itemtime']),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Image.network(
                                    "http://lawlietaini.com/myrecycle_user/images/${rewards[index]['itemimage']}.jpg")),
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                                                              child: Text(
                                          rewards[index]['itemname'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      //  SizedBox(width: 50,),
                                      Container(
                                          height: 25,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                          ),
                                          child: Container(
                                              child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.card_giftcard,
                                                color: Colors.grey[700],
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "${rewards[index]['itempoint']}",
                                                style: TextStyle(
                                                    color: Colors.green[700]),
                                              ),
                                              Text(" Points"),
                                            ],
                                          )))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 3,
                                        fit: FlexFit.tight,
                                        child: Text(rewards[index]['itemdesc']),
                                      ),
                                      Icon(Icons.chevron_right)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
      
    
    
  }
}
