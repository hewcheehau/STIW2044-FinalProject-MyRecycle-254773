import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'dart:async';

String pathAsset = 'assets/images/profile.png';
String urlUpload = 'http://lawlietaini.com/myrecycle_user/php/register.php';
File _image;
final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emcontroller = TextEditingController();
final TextEditingController _pwcontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();
final TextEditingController _radiuscontroller = TextEditingController();

String _name, _email, _password, _phone;
bool _validate = false;

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
  const RegisterForm({Key key, File image}):super(key:key);
}

class _RegisterFormState extends State<RegisterForm> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.green.shade800,
          title: Text("Sign up now"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: RegisterWidget(),
          ),
        ),
      ),
    
   );
  }




  Future<bool> _onBackPressAppBar() async {
    _image = null;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 50, right: 50, top: 5),
              child: Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: _image == null
                          ? AssetImage(pathAsset)
                          : FileImage(_image),
                      fit: BoxFit.fill),
                ),
              ),
            ),
            Positioned(
              right: 50.0,
              bottom: 0.0,
              child: new FloatingActionButton(
                child: const Icon(Icons.camera_alt),
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
          controller: _namecontroller,
          decoration: InputDecoration(
            labelText: 'Username',

            // icon: Icon(Icons.person_add),
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
          controller: _emcontroller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(borderSide: BorderSide()),
          ),
          style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
        ),
        SizedBox(
          height: 13,
        ),
        TextFormField(
          obscureText: true,
          controller: _pwcontroller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
        ),
        SizedBox(
          height: 13,
        ),
        TextFormField(
          controller: _phcontroller,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone number',
            border: OutlineInputBorder(),
          ),
          style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: MaterialButton(
            child: Text(
              'Sign up',
              style: TextStyle(
                  color: Colors.white, fontSize: 20, letterSpacing: 0.8),
            ),
            minWidth: 350,
            height: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: _uploadData,
            color: Colors.greenAccent[700],
          ),
        ),
        SizedBox(
          height: 13,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Divider(),
            ),
            GestureDetector(
              onTap: _goBack,
              child: Text(
                'Already have account',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Divider(),
            )
          ],
        )
      ],
    );
  }

  void _choose() async {
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

    //selection==null?_image = await ImagePicker.pickImage(source: ImageSource.camera):await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _goBack() {
    _image = null;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void _uploadData() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _pwcontroller.text;
    _phone = _phcontroller.text;

    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_phone.length > 5) &&
        (_image != null)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();
      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUpload, body: {
        "encoded_string": base64Image,
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _image = null;
        _namecontroller.text = "";
        _emcontroller.text = "";
        _pwcontroller.text = "";
        _phcontroller.text = "";

        pr.dismiss();
        if (res.body == "failed") {
          print('enter fail area');
          _showDialog();
        } else {
          _showSuccessRegister();
          /*  Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen())); */
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void _showDialog() {
    print('Enter show dialog');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email has already been taken!'),
            content:
                const Text('Your entered email has been registered by other'),
            actions: <Widget>[
              FlatButton(
                child: Text('Try another'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Already have account?'),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              )
            ],
          );
        });
  }

  void _showSuccessRegister() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thanks for your registration'),
            content: const Text('Please get verify account from your email'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Ok',
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen()));
                },
              )
            ],
          );
        });
  }
}
