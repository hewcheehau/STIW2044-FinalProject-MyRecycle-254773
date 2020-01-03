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
import 'package:myrecycle/userpoint.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:myrecycle/payment1.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

String urlgetUser = "http://lawlietaini.com/myrecycle_user/php/get_user.php";
String urluploadImage =
    "http://lawlietaini.com/myrecycle_user/php/uploadimage_profile.php";
String urlupdate =
    "http://lawlietaini.com/myrecycle_user/php/update_profile.php";

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
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    Size media = MediaQuery.of(context).size;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          body: SafeArea(
            top: false,
            child: ListView.builder(
                padding: EdgeInsets.only(top: 0),
                //Step 6: Count the data
                itemCount: 5,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                              alignment: Alignment.topCenter,
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Container(
                                    height: media.height * 0.25,
                                    width: media.width,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF69F0AE),
                                            Color(0xFF00BFA5),
                                          ],
                                          begin:
                                              const FractionalOffset(1.0, 1.0),
                                          end: const FractionalOffset(0.2, 0.2),
                                          tileMode: TileMode.clamp),
                                    ),
                                  ),
                                ]),
                                Positioned(
                                  top: 100,
                                  child: Stack(children: <Widget>[
                                    GestureDetector(
                                      onTap: _chooseCamera,
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
                                  ]),
                                ),
                                Positioned(
                                  top: 220,
                                  right: 130,
                                  width: 45,
                                  child: FloatingActionButton(
                                    onPressed: _takePicture,
                                    child: const Icon(Icons.camera_enhance),
                                    backgroundColor: Colors.grey[700],
                                  ),
                                ),
                                Column(children: <Widget>[
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 60.0),
                                      child: Text("MyRecycle",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[200])),
                                    ),
                                  ),
                                ]),
                              ]),
                          SizedBox(
                            height: 75,
                          ),
                      

                          Container(
                            padding: EdgeInsets.only(top: 10),
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
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        //  crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(Icons.rate_review),
                                          RatingBar(
                                              itemCount: 5,
                                              itemSize: 20,
                                              initialRating: double.parse(widget
                                                      .user.rating
                                                      .toString() ??
                                                  0.0),
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 2.0),
                                              itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.teal[600],
                                                  ))
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        //  crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(Icons.phone),
                                          Text(widget.user.phone ??
                                              'not registered'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.credit_card),
                                          Text("You have " +
                                                  widget.user.credit +
                                                  " Credit" ??
                                              "You have 0 Credit"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.location_on),
                                          Expanded(
                                              child: Text(_currentAddress)),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            thickness: 0.5,
                            indent: 00,
                            endIndent: 0,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Center(
                                    child: Text("Settings ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[850])),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (index == 1) {
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  highlightColor: Colors.white.withAlpha(50),
                                  onTap: _onchangeName,
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.person,
                                        color: Colors.lime[600],
                                      ),
                                      Text(
                                        'Change Username',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: _changePassword,
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.vpn_key,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        'Change Password',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: _onchangePhone,
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.phone_android,
                                        color: Colors.blueAccent,
                                      ),
                                      Text(
                                        'Change Phone No.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap:
                                      _loadPayment, //()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CreditPurchase())),
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.attach_money,
                                        color: Colors.tealAccent[700],
                                      ),
                                      Text(
                                        'Buy Credit',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserPoint(user: widget.user)));
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.redeem,
                                        color: Colors.deepOrange,
                                      ),
                                      Text(
                                        'MyRecycle Points',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: _logout,
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.exit_to_app,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.redAccent),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }
                }),
          ),
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
    if (widget.user.email == 'user@noregister.com') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Please Login"),
              content: Text(
                  'You are required to Login or Register as registered user'),
              actions: <Widget>[
                FlatButton(
                    child: Text(
                      'Register New Account',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterForm()));
                    }),
                FlatButton(
                    child: Text(
                      'Sign In Now',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    })
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Log Out'),
              titlePadding: EdgeInsets.only(left: 120, top: 20),
              content: Text('Are you sure want to logout of MyRecycle?'),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                    child: Text(
                      'Yes, Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('email', '');
                      await prefs.setString('pass', '');
                      print("LOGOUT");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen()));
                    }),
              ],
            );
          });
    }
  }

  

  void _changePassword() {
    TextEditingController passController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
   if (widget.user.email=="user@noregister.com") {
      Toast.show("You haven't logined yet, Please Login", context,
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
    if (widget.user.email=="user@noregister.com") {
      Toast.show("You haven't logined yet, Please Login", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            
            title: new Text("Purchase Credits"),
            content: Container(
              height: 300,
              
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
                          builder: (context) => PaymentScreen1(
                              user: widget.user,
                              orderid: formatted,
                              val: _value)));
                },
              ),
              new FlatButton(
                child: new Text(
                  'No',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  
  void _chooseCamera() {
       if (widget.user.name == "Not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showModalBottomSheet(
        elevation: 1,
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.black,
                    ),
                    title: Text('View Profile Picture'),
                    /*qwjekqw*/
                    onTap: () async {
                      Navigator.pop(context);
                      Hero(
                        tag: 'Profile Picture',
                        child: Image.network(
                            "http://lawlietaini.com/myrecycle_user/profile/${widget.user.email}.jpg?dummy=${(number)}'"),
                      );

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(user: widget.user)));
                      setState(() {});
                    }),
                Divider(
                  thickness: 0,
                  color: Colors.grey[400],
                  indent: 0,
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.black),
                  title: Text('Camera'),
                  onTap: () async {
                    if (widget.user.name == "not register") {
                      Toast.show("Not allowed", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      return;
                    }
                    String base64Image;
                    try {
                      Navigator.of(context).pop();
                      _image = await ImagePicker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 60,
                          maxWidth: double.infinity,
                          maxHeight: 450);

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

                    /* _image = await ImagePicker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 60,
                        maxWidth: 300,
                        maxHeight: 300);
                    setState(() {});*/
                  },
                ),
                Divider(
                  thickness: 0,
                  color: Colors.grey[400],
                  indent: 0,
                ),
                ListTile(
                  leading: Icon(Icons.photo_album, color: Colors.black),
                  title: Text('Gallery'),
                  onTap: () async {
                    if (widget.user.name == "not register") {
                      Toast.show("Not allowed", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      return;
                    }
                    String base64Image;
                    try {
                      Navigator.of(context).pop();
                      _image = await ImagePicker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 80,
                          maxWidth: double.infinity,
                          maxHeight: 450);

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
                )
              ],
            ),
          );
        });
  }

  void _onlogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', '');
    await prefs.setString('pass', '');
    print("LOGOUT");
    if (widget.user.email != null) {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "Log out",
        desc: "Are you sure want to logout of MyRecycle?",
        buttons: [
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            gradient: LinearGradient(
                colors: [Colors.lightBlue, Colors.lightBlue[200]]),
          ),
          DialogButton(
            child: Text(
              "Yes, Logout",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('email', '');
              await prefs.setString('pass', '');
              print("LOGOUT");
              Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => SplashScreen()));
            },
            gradient:
                LinearGradient(colors: [Colors.red[600], Colors.red[400]]),
          )
        ],
      ).show();
    }
  }
  

  void _onchangeName() {

    TextEditingController nameController = TextEditingController();
    // flutter defined function

   if (widget.user.email=="user@noregister.com") {
      Toast.show("You haven't logined yet, Please Login", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    }
    Alert(
        context: context,
        title: "Change Username",
        content: Column(
          children: <Widget>[
            Text(
              'Your old name : ${widget.user.name}',
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.tealAccent,
                ),
                labelText: 'Enter your new name',
              ),
              controller: nameController,
            ),
          ],
        ),
        buttons: [
          DialogButton(
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
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.red,
          )
        ]).show();
  }

  void _onchangePassword() {
    TextEditingController passController = TextEditingController();
    TextEditingController pass2Controller = TextEditingController();
    // flutter defined function

    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    Alert(
        context: context,
        title: "Change Passwords",
        content: Column(
          children: <Widget>[
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.https,
                  color: Colors.blue[900],
                ),
                labelText: 'Enter your new password',
              ),
              controller: passController,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.https,
                  color: Colors.blue[900],
                ),
                labelText: 'Enter your new password again',
              ),
              controller: pass2Controller,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              if (passController.text.length < 5) {
                Toast.show(
                    "Password should be more than 5 characters long", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              }
              if (passController.text != pass2Controller.text) {
                Toast.show('Password not match', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
                } else {
                  print(dres);
                  Toast.show('Failed to change', context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
              }).catchError((err) {
                print(err);
              });
            },
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.red,
          )
        ]).show();
  }

  void _onchangePhone() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function

    if (widget.user.email=="user@noregister.com") {
      Toast.show("You haven't logined yet, Please Login", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    }
    Alert(
        context: context,
        title: "Change Phone Number",
        content: Column(
          children: <Widget>[
            Text(
              'Your old phone no. : ${widget.user.phone}',
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                icon: Icon(
                  Icons.phone,
                  color: Colors.tealAccent,
                ),
                labelText: 'Enter your new phone number',
              ),
              controller: phoneController,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              if (phoneController.text.length < 5) {
                Toast.show(
                    "Phone number should be more than 5 numbers", context,
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
                    //  Navigator.of(context).pop();
                    return;
                  });
                } else {}
              }).catchError((err) {
                print(err);
              });
              Navigator.of(context).pop();
            },
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.red,
          )
        ]).show();
  }
}

class DetailScreen extends StatefulWidget {
  final User user;
  const DetailScreen({Key key, this.user}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent[700],
        centerTitle: true,
        title: Text('Profile Picture'),
      ),
      body: Container(
        child: Center(
          child: Hero(
            tag: 'Profile Picture',
            child: Image.network(
                "http://lawlietaini.com/myrecycle_user/profile/${widget.user.email}.jpg?dummy=${(number)}'"),
          ),
        ),
      ),
    );
  }
}

class CreditPurchase extends StatefulWidget {


  CreditPurchase({Key key}) : super(key: key);

  @override
  _CreditPurchaseState createState() => _CreditPurchaseState();
}

class _CreditPurchaseState extends State<CreditPurchase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => TabScreen4())),
            ),
            title: Text(
              'Buy Credits',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            snap: true,
            floating: true,
          ),
        ],
      ),
    );
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
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Icon(FontAwesomeIcons.bitcoin,color: Colors.yellowAccent[700],size: 50,)),
          DropdownButton<String>(
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
            hint: Text('Select Credit',style: TextStyle(color: Colors.black87),),
            value: _value,
          ),
           Expanded(
             child: Text('By using MyRecycle Credit, you agree with our Terms of Services. Coins are not refundable and expire in one year, unless otherwise stated',style: TextStyle(color: Colors.black54),)),
        ],
      ),
    );
  }
}
