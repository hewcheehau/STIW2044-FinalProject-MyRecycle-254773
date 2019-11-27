import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:myrecycle/user.dart';
import 'package:myrecycle/mainscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:place_picker/place_picker.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

String pickLocation = "";
File _image;
String pathAsset = 'assets/images/upload1.png';
String urlUpload = "http://lawlietaini.com/myrecycle_user/php/upload_item.php";
String urlgetuser = "http://lawlietaini.com/myrecycle_user/php/get_user.php";

final TextEditingController _itemcontroller = TextEditingController();
final TextEditingController _desccontroller = TextEditingController();
//final TextEditingController _pricecontroller = TextEditingController();
final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
Position _currentPosition;
String _currentAddress = "Searching your current location...";

class NewItem extends StatefulWidget {
  final User user;

  const NewItem({Key key, this.user}) : super(key: key);

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Recycle Items'),
          centerTitle: true,
          backgroundColor: Colors.greenAccent[700],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: CreateNewItem(widget.user),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (context) => MainScreen(user: widget.user)));

    return Future.value(false);
  }
}

class CreateNewItem extends StatefulWidget {
  final User user;
  CreateNewItem(this.user);

  @override
  _CreateNewItemState createState() => _CreateNewItemState();
}

class _CreateNewItemState extends State<CreateNewItem> {
  String defaultValue = "Pickup";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 35, right: 35, top: 5),
              child: Container(
                height: 200,
                width: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: _image == null
                          ? AssetImage(pathAsset)
                          : FileImage(_image),
                      fit: BoxFit.fill),
                ),
              ),
            ),
            Positioned(
              right: 30.0,
              bottom: 0.0,
              child: new FloatingActionButton(
                child: const Icon(Icons.add),
                backgroundColor: Colors.green.shade800,
                onPressed: _choose,
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: _itemcontroller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Item Name',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
          validator: (value) {
            if (value.length == 0) {
              return 'Cannot be empty';
            } else {
              return null;
            }
          },
          style: TextStyle(fontFamily: "Poppins", fontSize: 15),
        ),
        SizedBox(
          height: 13,
        ),
        TextFormField(
          controller: _desccontroller,
          keyboardType: TextInputType.text,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Item Description',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
          validator: (value) {
            if (value.length == 0) {
              return 'Cannot be empty';
            } else {
              return null;
            }
          },
          style: TextStyle(fontFamily: "Poppins", fontSize: 15),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: _loadmap,
          child: Container(
            padding: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            alignment: Alignment.topLeft,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Pickup Location " + pickLocation,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Icon(Icons.location_searching),
            SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 5,
              fit: FlexFit.tight,
              child: Container(
                height: 15,
                child: Text(
                  _currentAddress,
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: MaterialButton(
            child: Text(
              'Submit',
              style: TextStyle(
                  color: Colors.white, fontSize: 20, letterSpacing: 0.8),
            ),
            minWidth: 350,
            height: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: _onAddItem,
            color: Colors.greenAccent[700],
          ),
        ),
        SizedBox(
          height: 13,
        ),
      ],
    );
  }

  void _choose() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(40),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () async {
                    _image =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text('Gallery'),
                  onTap: () async {
                    _image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    setState(() {});
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  void _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        // print(_getCurrentLocation);
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  void _loadmap() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyCjm6b7WXTEmdfw529DnrKL3OTl4Wq0_5Q")));

    // Handle the result in your way
    print("MAP SHOW");
    print(result);

    String f = result.toString();
    pickLocation = f;
  }

  void _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  void _onAddItem() {
    if (_image == null) {
      Toast.show("Please take picture of your recycle trashes", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_itemcontroller.text.isEmpty) {
      Toast.show("Please enter item type", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Requesting");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    print(_currentPosition.latitude.toString() +
        "/" +
        _currentPosition.longitude.toString());

    http.post(urlUpload, body: {
      "encoded_string": base64Image,
      "email": widget.user.email,
      "itemtitle": _itemcontroller.text,
      "itemdesc": _desccontroller.text,
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
      "credit": widget.user.credit,
      "rating": widget.user.rating
    }).then((res) {
      print(urlUpload);
      print(widget.user.email);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        _image = null;
        _itemcontroller.text = "";
        _desccontroller.text = "";
        pr.dismiss();
        print(widget.user.email);

        _onLogin(widget.user.email, context);
      } else {
        pr.dismiss();
        Toast.show(res.body + ". Please reload", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  void _onLogin(String email, BuildContext context) {
    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == 'success') {
        User user = new User(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            radius: dres[4],
            credit: dres[5],
            rating: dres[6]);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainScreen(user: user)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}
