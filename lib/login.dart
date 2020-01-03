import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart';
import 'registerform.dart';
import 'resetpass.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';
import 'user.dart';

String urlLogin = "http://lawlietaini.com/myrecycle_user/php/loginuser.php";
String urlGetuser = "http://lawlietaini.com/myrecycle_user/php/get_user.php";
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pwcontroller = TextEditingController();
  String _email = "";
  String _password = "";
  bool _checkBoxValue = false;
  int countE = 0;
  var passKey = GlobalKey<FormFieldState>();
  int _radio = 1;

  @override
  void initState() {
    print(_email.length);
    loadpref();
    print('Init: $_email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: SafeArea(
            top: false,
            child: Container(
              child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: GestureDetector(
                            onTap: (){
                                    User user = new User(
                                        name: "Not register",
                                        email: "user@noregister.com",
                                        phone: "not register",
                                        points: "5",
                                        credit: "0",
                                        rating: "0");
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainScreen(
                                                  user: user,
                                                )));
                                  },
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Skip',
                                  style: TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                IconButton(
                                  // padding: EdgeInsets.only(top:35),
                                  onPressed: () {
                                    User user = new User(
                                        name: "No register",
                                        email: "user@noregister.com",
                                        phone: "not register",
                                        points: "5",
                                        credit: "0",
                                        rating: "0");
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainScreen(
                                                  user: user,
                                                )));
                                  },
                                  alignment: Alignment.topRight,
                                  iconSize: 35,
                                  icon: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Image.asset(
                        'assets/images/logo2.png',
                        scale: 1.5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Container(
                          child: Column(children: <Widget>[
                        TextField(
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins-Bold",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.tealAccent)),
                            labelText: 'Email',
                          ),
                          controller: _emcontroller,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextField(
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins-Bold",
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.tealAccent)),
                            labelText: 'Password',
                          ),
                          controller: _pwcontroller,
                        ),
                      ])),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 8, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: _checkBoxValue,
                            onChanged: (bool newValue) {
                              setState(() {
                                _checkBoxValue = newValue;
                                saveperf(newValue);
                              });
                            },
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: MaterialButton(
                        child: Text(
                          'Log in',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 0.6),
                        ),
                        minWidth: 350,
                        height: 50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: _onLogin,
                        color: Colors.tealAccent[700],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResetAcc()));
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'OR',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Don't have account? ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          GestureDetector(
                            onTap: _Register,
                            child: Text(
                              'Sign up now.',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontFamily: "Helvetica, Arial, sans-serif",
                                  letterSpacing: 0.7,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }

  void saveperf(bool newValue) async {
    print('Inside saveperf');
    _email = _emcontroller.text;
    _password = _pwcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (newValue) {
      if (_isEmailValid(_email) && (_password.length > 5)) {
        await prefs.setString('email', _email);
        await prefs.setString('pass', _password);
        print('Save pref $_email');
        print('Save pref $_password');

        prefs.setInt('count', countE);
        Toast.show('Preferences have been saved', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        print('No email');
        setState(() {
          _checkBoxValue = false;
        });
        Toast.show('Check your credentials', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emcontroller.text = '';
        _pwcontroller.text = '';
        _checkBoxValue = false;
      });
      print('Remove pref');
      Toast.show('Preferences have been removed', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void loadpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _password = (prefs.getString('pass'));
    print(_email);
    print(_password);
    if (_email != null) {
      if (_email.length > 1) {
        _emcontroller.text = _email;
        _pwcontroller.text = _password;
        setState(() {
          _checkBoxValue = true;
        });
      } else {
        print('No pref');
        setState(() {
          _checkBoxValue = false;
        });
      }
    }
    setState(() {
      _checkBoxValue = false;
    });
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }

  _Register() {
    print('Go to Registerpage');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterForm()));
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void _onLogin() {
    _email = _emcontroller.text;
    _password = _pwcontroller.text;
    if (_isEmailValid(_email) && (_password.length > 4)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login in");

      pr.show();
      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        print("Go to user data");
        // _onGetUser(_email);
        // pr.dismiss();
        var string = res.body;
        List dres = string.split(",");

        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          pr.dismiss();
          print("Radius:");
          print(dres[0]);

          User user = new User(
              name: dres[1],
              email: dres[2],
              phone: dres[3],
              points: dres[4],
              credit: dres[5],
              rating: dres[6]);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MainScreen(user: user)));
        } else {
          pr.dismiss();
        }
      }).catchError((err) {
        pr.dismiss();
        print(err);
      });
    } else {}
  }

  void _onGetUser(String email) {
    http.post(urlGetuser, body: {"email": _email, "password": _password}).then(
        (res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(',');
      Toast.show(dres[0], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (dres[0] == 'success') {
        User user = new User(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            points: dres[4],
            credit: dres[5],
            rating: dres[6]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreen(
                      user: user,
                    )));
      } else {
        print('fail');
      }
    }).catchError((err) {
      print(err);
    });
  }
}
