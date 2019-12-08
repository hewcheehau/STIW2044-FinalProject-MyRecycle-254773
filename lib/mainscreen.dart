import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrecycle/tabscreen/tabscreen.dart';
import 'package:myrecycle/tabscreen/tabscreen2.dart';
import 'package:myrecycle/tabscreen/tabscreen3.dart';
import 'package:myrecycle/tabscreen/tabscreen4.dart';
import 'user.dart';
import 'package:flutter/services.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabScreen(user: widget.user),
      TabScreen2(),
      TabScreen3(),
      TabScreen4(
        user: widget.user,
      ),
    ];
  }

  String $pagetitle = "My Recycle";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.greenAccent[700]
    ));
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: 
      tabs[currentTabIndex],
      /*bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBackgroundColor: Colors.green,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.black
        ),
        selectedIndex: currentTabIndex,
        onSelectTab: onTapped,
        items: [
          FFNavigationBarItem(
            iconData: Icons.home,
            label: 'Home',
          ),
          FFNavigationBarItem(
            iconData: Icons.calendar_view_day,
            label: 'Calender',
          ),
           FFNavigationBarItem(
            iconData: Icons.message,
            label: 'Message',
          ),
           FFNavigationBarItem(
            iconData: Icons.person_outline,
            label: 'Profile',
          ),
        ],
      ), */
      bottomNavigationBar: 
          BottomNavigationBar(
          onTap: onTapped,
          currentIndex: currentTabIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_day),
              title: Text('Calendar'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.message), title: Text('Inform')),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Me'),
            ),
          ]),
      );
  }
}
