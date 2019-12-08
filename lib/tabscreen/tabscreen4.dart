import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrecycle/tabscreen/tabscreen.dart';
import 'dart:io';
import 'package:myrecycle/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:myrecycle/login.dart';
import 'package:myrecycle/splashscreen.dart';
import 'dart:convert';
import 'package:myrecycle/registerform.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:myrecycle/payment.dart';

String urlgetUser = "http://lawlietaini.com/myrecycle_user/php/get_user.php";
String urluploadImage =
    "http://lawlietaini.com/myrecycle_user/php/uploadimage_profile.php";
String urlupdate;

File _image;
int number = 0;
String _value;

class TabScreen4 extends StatefulWidget {
  final User user;

  TabScreen4({this.user});

  @override
  _TabScreen4State createState() => _TabScreen4State();
}

class _TabScreen4State extends State<TabScreen4> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  GlobalKey<RefreshIndicatorState> refreshKey;

  Position _currentPosition;
  String _currentAddress = "Searching current location";

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.green[900]),
    );
    Size media = MediaQuery.of(context).size;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          body: ListView.builder(
              //Step 6: Count the data
              itemCount: 5,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Stack(
                            alignment: Alignment.topCenter,
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Row(children: <Widget>[
                                Container(
                                  height: media.height * 0.20,
                                  width: media.width,
                                  child: Image.asset(
                                    "assets/images/green0.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ]),
                              Positioned(
                                top: 50,
                                child: GestureDetector(
                                  onTap: _takePicture,
                                  child: Container(
                                    height: 170,
                                    width: 170,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "http://lawlietaini.com/myrecycle_user/profile/${widget.user.email}.jpg?dummy=${(number)}'")),
                                      border: Border.all(
                                          color: Colors.white, width: 5.0),
                                    ),
                                  ),
                                ),
                              ),
                              Column(children: <Widget>[
                                Center(
                                  child: Text("MyHelper",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[200])),
                                ),
                              ]),
                            ]),
                        SizedBox(
                          height: 75,
                        ),
                        /*     GestureDetector(
                                onTap: _takePicture,
                                child: Container(
                                    width: 150.0,
                                    height: 150.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(width:5,color: Colors.white),

                                       image: new DecorationImage(
                                            fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(Colors.blue, BlendMode.modulate),
                                           image: new NetworkImage(
                                                "http://lawlietaini.com/myrecycle_user/profile/${widget.user.email}.jpg?dummy=${(number)}'")
                                                ),
                                                
                                                ),
                                                
                                                ),
                              ),  */

                        Container(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            widget.user.name?.toUpperCase() ?? 'Not register',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Icon(
                                    Icons.verified_user,
                                    color: Colors.blue[900],
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    widget.user.email,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Icon(
                                Icons.rate_review,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: RatingBar(
                                itemCount: 5,
                                itemSize: 20,
                                initialRating: double.parse(
                                    widget.user.rating.toString() ?? 0.0),
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.teal[600],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.phone,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child:
                                  Text(widget.user.phone ?? 'not registered'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Icon(
                              Icons.credit_card,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                                "You have " + widget.user.credit + " Credit" ??
                                    "You have 0 Credit"),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.location_on,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(_currentAddress),
                          ),
                        ]),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          color: Colors.tealAccent[400],
                          child: Center(
                            child: Text("My Profile ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[850])),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (index == 1) {
                  return Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        MaterialButton(
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          onPressed: _changeName,
                          child: Text("CHANGE NAME"),
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          color: Colors.grey,
                        ),
                        MaterialButton(
                          onPressed: _changePassword,
                          child: Text("CHANGE PASSWORD"),
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          color: Colors.grey,
                        ),
                        MaterialButton(
                          onPressed: _changePhone,
                          child: Text("CHANGE PHONE"),
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          color: Colors.grey,
                        ),
                        MaterialButton(
                          onPressed: _loadPayment,
                          child: Text("BUY CREDIT"),
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          color: Colors.grey,
                        ),
                        MaterialButton(
                          onPressed: _registerAccount,
                          child: Text("REGISTER"),
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          color: Colors.grey,
                        ),
                        MaterialButton(
                          onPressed: _gotologinPage,
                          child: Text("LOG IN"),
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          color: Colors.grey,
                        ),
                        MaterialButton(
                          onPressed: _logout,
                          child: Text(
                            "LOG OUT",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  );
                }
              }),
        ));
  }

  void _takePicture() async {
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Take new profile picture?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                String base64Image;
                try {
                  Navigator.of(context).pop();
                  _image =
                      await ImagePicker.pickImage(source: ImageSource.camera);

                  base64Image = base64Encode(_image.readAsBytesSync());
                } catch (e) {
                  print(e);
                }
                http.post(urluploadImage, body: {
                  "encoded_string": base64Image,
                  "email": widget.user.email,
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    setState(() {
                      number = new Random().nextInt(100);
                      print(number);
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _getCurrentLocation() async {
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

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', '');
    await prefs.setString('pass', '');
    print("LOGOUT");
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => SplashScreen()));
  }

  void _changeName() {
    TextEditingController nameController = TextEditingController();
    // flutter defined function

    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change " + widget.user.name),
          content: new TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                icon: Icon(Icons.person),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (nameController.text.length < 5) {
                  Toast.show(
                      "Name should be more than 5 characters long", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "name": nameController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.user.name = dres[1];
                      if (dres[0] == "success") {
                        print("in setstate");
                        widget.user.name = dres[1];
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changePassword() {
    TextEditingController passController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change Password for " + widget.user.name),
          content: new TextField(
            controller: passController,
            decoration: InputDecoration(
              labelText: 'New Password',
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (passController.text.length < 5) {
                  Toast.show("Password too short", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "password": passController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.user.name = dres[1];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        savepref(passController.text);
                        Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changePhone() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change phone for" + widget.user.name),
          content: new TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'phone',
                icon: Icon(Icons.phone),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (phoneController.text.length < 5) {
                  Toast.show("Please enter correct phone number", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "phone": phoneController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.user.phone = dres[3];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  }
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerAccount() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Register new account?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RegisterForm()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _gotologinPage() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Go to login page?" + widget.user.name),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void savepref(String pass) async {
    print('Inside savepref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pass', pass);
  }

  void _loadPayment() async {
    if (widget.user.name == 'not register') {
      Toast.show("You haven't logined yet, Please Login", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
          
            title: new Text("Purchase Credit?"),
            content: Container(
              
              height: 100,
              child: DropdownExample(),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Yes"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var now = new DateTime.now();
                  var formatter = new DateFormat('ddMMyyyyhhmmss-');
                  String formatted =
                      formatter.format(now) + randomAlphaNumeric(10);
                  print(formatted);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                              user: widget.user,
                              orderid: formatted,
                              val: _value)));
                },
              ),
              new FlatButton(
                child: new Text('No',style: TextStyle(color: Colors.red),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            child: Text('50 HCredit : RM10'),
            value: '10',
          ),
          DropdownMenuItem<String>(
            child: Text('105 HCredit : RM20'),
            value: '20',
          ),
          DropdownMenuItem<String>(
            child: Text('165 HCredit : RM30'),
            value: '30',
          ),
        ],
        onChanged: (String value) {
          setState(() {
            _value = value;
          });
        },
        hint: Text('Select Credit'),
        value: _value,
      ),
    );
  }
}
