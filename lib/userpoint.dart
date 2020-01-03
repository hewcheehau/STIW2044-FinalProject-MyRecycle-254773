import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class UserPoint extends StatefulWidget {
  final User user;
  const UserPoint({Key key, this.user}) : super(key: key);
  @override
  _UserPointState createState() => _UserPointState();
}

class _UserPointState extends State<UserPoint> {
  List rewards = new List();

  GlobalKey<RefreshIndicatorState> refreshKey;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();

    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child:   ListView.builder(
                              itemCount: rewards==null?1:rewards.length+1,
                              itemBuilder: (context,index){
                                if(index==0){
                                return Container(
                             
                                    child:    Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                AppBar(
                  leading: IconButton(
                      onPressed: () => (Navigator.pop(context)),
                      icon: Icon(Icons.clear)),
                  title: Text(
                    'Redeem Point Info',
                    style: TextStyle(color: Colors.black54),
                  ),
                  brightness: Brightness.light,
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  iconTheme: IconThemeData(color: Colors.black54),
                ),
              ],
            ),
            Container(
              height: 350,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.all(15),
                    elevation: 10,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Your redeem points\n',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(widget.user.points,
                                        style: TextStyle(fontSize: 25))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 100,
                              child: VerticalDivider(
                                color: Colors.black54,
                              ),
                            ),
                            Expanded(
                                child: Image.asset('assets/images/logo2.png',
                                    width: 200, height: 200)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(15),
                    elevation: 5,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                'Your Redeem Code History\n',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
                                );}
                                
                                index-=1;
                                return Container(
                                    child: Card(
                                                                          child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(rewards[index]['pointid']),
                                              Text("Date: ${rewards[index]['pointdate']}")
                                            ],
                                          ),
                                          SizedBox(height: 5,)
                                        ],
                                      ),
                                    ),
                                );
                              },
                            )
     
      ),
    );
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

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  Future<String> makeRequest() async {
    String urlLoadItems =
        "http://lawlietaini.com/myrecycle_user/php/load-point.php";

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Loading');
    pr.show();
    http.post(urlLoadItems, body: {
      "email": widget.user.email ?? "notvail",
    }).then((res) {
      print("enter");
      print(res.body);
      setState(() {
        var extractdata = json.decode(res.body);
        rewards = extractdata["point"];
        // perpage = (rewards.length / 10);
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
}
