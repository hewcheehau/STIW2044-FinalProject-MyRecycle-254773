import 'dart:async';
import 'dart:ui' as prefix0;
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'mainscreen.dart';
import 'package:flutter/services.dart';

String _email, _pw;
String urlGetuser = "http://lawlietaini.com/myrecycle_user/php/get_user.php";

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ));

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo2.png',
              width: 250,
              height: 250,
            ),
            SizedBox(
              height: 18,
            ),
            new ProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
            loadpref(this.context);
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new CircularProgressIndicator(
        value: animation.value,
        backgroundColor: Colors.black,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.greenAccent[400]),
      ),
    );
  }
}

void loadpref(BuildContext ctx) async {
  print('Inside loadpref');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _email = (prefs.getString('email'));
  _pw = (prefs.getString('pass'));
  print("Splasj:Preference");
  print(_email);
  print(_pw);
  if (_isEmailValid(_email)) {
    //try login if got email;
    _onLogin(_email, _pw, ctx);
  } else {
    User user = new User(
      name: "Not register",
      email: "user@noregister.com",
      phone: "not register",
      radius: "15",
      credit: "0",
      rating: "0",
    );
    Navigator.pushReplacement(
        ctx,
        MaterialPageRoute(
            builder: (context) => MainScreen(
                  user: user,
                )));
  }
}

bool _isEmailValid(String email) {
  if (email == null) {
    return false;
  } else {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}

void _onLogin(String email, String pass, BuildContext ctx) {
  http.post(urlGetuser, body: {
    "email": _email,
    "password": _pw,
  }).then((res) {
    print(res.statusCode);
    var string = res.body;
    List dres = string.split(",");

    print("Splash:Loading");
    print(dres);
    if (dres[0] == "success") {
      User user = new User(
          name: dres[1],
          email: dres[2],
          phone: dres[3],
          radius: dres[4],
          credit: dres[5],
          rating: dres[6]);
      Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(
              builder: (context) => MainScreen(
                    user: user,
                  )));
    } else {
      //allow login as unregistered user
      print("No register");
      User user = new User(
          name: "Not register",
          email: "user@noregister",
          phone: "not register",
          radius: "15",
          credit: "0",
          rating: "0");
      Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(
              builder: (context) => MainScreen(
                    user: user,
                  )));
    }
  }).catchError((err) {
    print(err);
  });
}
