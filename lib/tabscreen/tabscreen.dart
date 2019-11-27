import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrecycle/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myrecycle/itemuser/item.dart';
import "package:myrecycle/SlideRightRoute.dart";
import 'package:myrecycle/itemuser/itemdetail.dart';
import 'package:toast/toast.dart';
import 'package:myrecycle/itemuser/newitem.dart';
import 'package:myrecycle/registerform.dart';
import 'package:place_picker/place_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myrecycle/login.dart';

double perpage = 1;

String greeting(String name) {
  var time = DateTime.now().hour;

  if (name != "Not register") {
    if (time < 12) {
      return "Morning, " + name;
    } else if (time < 17) {
      return "Afternoon, " + name;
    } else {
      return "Evening, " + name;
    }
  } else {
    return "No Register user";
  }
}

class TabScreen extends StatefulWidget {
  final User user;

  TabScreen({Key key, this.user}) : super(key: key);
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";
  List data;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    // SystemUiOverlayStyle(statusBarColor: Colors.pinkAccent);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.greenAccent[400],
          elevation: 2.0,
          onPressed: _onNewItems,
          tooltip: 'Add new item',
        ),
        body: RefreshIndicator(
          key: refreshKey,
          color: Colors.pinkAccent,
          onRefresh: () async {
            await refreshList();
          },
          child: ListView.builder(
            //step 6: count the data
            itemCount: data == null ? 1 : data.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent[700],
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                              ),
                            ),
                          ),
                          /*
                           Image.asset(
                            "assets/images/green3.png",
                            width: 700,
                            height: 200,
                            fit: BoxFit.cover,
                          ), */
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Row(children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      greeting(widget.user.name),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5),
                                    ),
                                  ),
                                ),
                              ]),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                              
                                child: Text(
                                  "MyRecycle",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: "Lobster"
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: 300,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0, 15.0),
                                        blurRadius: 15.0,
                                      ),
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0, -10.0),
                                        blurRadius: 10.0,
                                      )
                                    ]),
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.location_on),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Flexible(
                                              child: Text(_currentAddress),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.credit_card),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Flexible(
                                              child: Text(
                                                  "You have ${widget.user.credit} Credits."),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Colors.lightGreenAccent[700],
                        child: Center(
                          child: Text(
                            "Your Pick-up order ",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (index == data.length && perpage > 1) {
                return Container(
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
                  padding: EdgeInsets.all(2.0),
                  child: Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () => _onRecycleTrash(
                          data[index]['itemimage'],
                          data[index]['itemtime'],
                          data[index]['itemdesc'],
                          data[index]['itemtitle'],
                          data[index]['itemowner'],
                          data[index]['itemlatitude'],
                          data[index]['itemlongitude'],
                          widget.user.radius,
                          widget.user.name,
                          widget.user.credit),
                      onLongPress: _onJobDelete,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          "http://lawlietaini.com/myrecycle_user/images/${data[index]['itemimage']}.jpg"))),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                        data[index]['itemtitle']
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    RatingBar(
                                        itemCount: 5,
                                        itemSize: 12,
                                        initialRating: double.parse(data[index]
                                                ['itemrating']
                                            .toString()),
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.yellowAccent,
                                            )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(data[index]['itemtime']),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          ),
        ),
      ),
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  Future<String> makeRequest() async {
    String urlLoadItems =
        "http://lawlietaini.com/myrecycle_user/php/load_items.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Loading items');
    pr.show();
    http.post(urlLoadItems, body: {
      "email": widget.user.email ?? "notvail",
      "latitude": _currentPosition.latitude.toString() ?? "notvail",
      "longitude": _currentPosition.longitude.toString() ?? "notvail",
      "radius": widget.user.radius ?? "10",
    }).then((res) {
      print("enter");
      print(res.body);
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["items"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        // Toast.show(res.body, context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
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

  void _onRecycleTrash(
      String itempicture,
      String picktime,
      String itemdesc,
      String itemtitle,
      String itemowner,
      String itemlatitude,
      String itemlongitude,
      String radius,
      String name,
      String credit) {
    Item item = new Item(
      itempicture: itempicture,
      picktime: picktime,
      itemdesc: itemdesc,
      itemtitle: itemtitle,
      itemowner: itemowner,
      itemlatitude: itemlatitude,
      itemlongitude: itemlongitude,
    );
    Navigator.push(context,
        SlideRightRoute(page: ItemDetail(item: item, user: widget.user)));
  }

  void _onNewItems() async {
    print(widget.user.email);
    if (widget.user.email != "user@noregister.com") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => NewItem(
                    user: widget.user,
                  )));
    } else {
      Toast.show("Please Register/Login first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      _showDialog();
    }
  }

  void _onJobDelete() {}

  void _showDialog() {
    print('Enter show dialog');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Register/Login Request'),
            content: const Text('Please login first/register an account.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Already have account'),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen()));
                },
              ),
              FlatButton(
                child: Text('Register new'),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => RegisterForm()));
                },
              )
            ],
          );
        });
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
}
