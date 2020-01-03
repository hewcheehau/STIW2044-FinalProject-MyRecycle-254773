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
import 'package:myrecycle/curve_clipper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:empty_widget/empty_widget.dart';

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
    return "Not Register user";
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
    Size media = MediaQuery.of(context).size;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          foregroundColor: Colors.white,
          backgroundColor: Colors.tealAccent[700],
          elevation: 2.0,
          onPressed: _onNewItems,
          tooltip: 'Add new item',
        ),
        body: SafeArea(
          top: false,
          child: RefreshIndicator(
            key: refreshKey,
            color: Colors.pinkAccent,
            onRefresh: () async {
              await refreshList();
            },
            child: data==null ? SingleChildScrollView(
                          child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: media.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    height: 230,
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent[700],
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(30),
                                      ),
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF69F0AE),
                                            Color(0xFF00BFA5),
                                          ],
                                          begin: const FractionalOffset(1.0, 1.0),
                                          end: const FractionalOffset(0.2, 0.2),
                                          tileMode: TileMode.clamp),
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                20,
                                      ),
                                      Row(children: <Widget>[
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 15, top: 10),
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 5, top: 10),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              greeting(widget.user.name),
                                              style: TextStyle(
                                                  color: Colors.grey[200],
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
                                              fontFamily: "Lobster"),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        width: 350,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
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
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Colors.redAccent,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                      child:
                                                          Text(_currentAddress),
                                                    ),
                                                  ],
                                                ),
                                               Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.credit_card,
                                                      color:
                                                          Colors.blueAccent[100],
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                          "You have ${widget.user.credit} Credits."),
                                                    ),
                                                  ],
                                                ),
                                                          Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      FontAwesomeIcons.gift,
                                                      color:
                                                          Colors.deepOrange,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                          "You have ${widget.user.points} points."),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Center(
                                        child: Text(
                                          "Your Recycle Listings",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[850]),
                                        ),
                                      ),
                                    ),
                                  ),
                                 
                                   

                                ],
                              ),
                               
                                  Center(
                                    child: Column(
                                      children: <Widget>[

                                      /*  Container(
                                          height: 350,
                                          width: double.infinity,
                                          child: EmptyListWidget(
                                            title: 'No Recycle Item',
                                            subTitle: "No Recycle Item in your Listing",
                                          ),
                                        ),*/
                                       Container(
                                         height: 350,
                                         width: double.infinity,
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(30),
                                           image: DecorationImage(

                                             image: AssetImage('assets/images/sunny.jpg'),
                                             fit: BoxFit.fill
                                           ),
                                           shape: BoxShape.rectangle
                                           
                                          
                                         ),
                                         child: Column(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: <Widget>[
                                             Icon(
                                               FontAwesomeIcons.trashRestoreAlt,
                                               size: 80,
                                               color: Colors.black38,
                                             ),
                                             SizedBox(height: 15,),
                                             
                                               Container(
                                          child: Text('No Recycle Item',style: TextStyle(fontSize:20,fontWeight: FontWeight.bold,color: Colors.black54),),
                                        ),
                                        SizedBox(height: 10,),
                                         Container(
                                           color: Colors.grey[200],
                                          
                                          child: MaterialButton(
                                            elevation: 2,
                                            
                                            child: Text('Add Your Recycle Item',style: TextStyle(color: Colors.black),),
                                            onPressed: ()=>widget.user.email=='user@noregister.com'?_showDialog():Navigator.push(context, MaterialPageRoute(builder: (context)=>NewItem(user:widget.user))),
                                          )
                                        ),
                                           ],
                                         ),
                                       ),
                                       
                                      ],
                                    ),
                                  )
                            ],
                          ),
                        ),
                      ],
                    ),
            ):ListView.builder(
              padding: EdgeInsets.only(top: 0),
              //step 6: count the data
              itemCount: data == null ? 1 : data.length + 1,
              itemBuilder: (context, index) {
                 
               
                if (index == 0) {
                
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: media.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent[700],
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                    ),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF69F0AE),
                                          Color(0xFF00BFA5),
                                        ],
                                        begin: const FractionalOffset(1.0, 1.0),
                                        end: const FractionalOffset(0.2, 0.2),
                                        tileMode: TileMode.clamp),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              20,
                                    ),
                                    Row(children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 15, top: 10),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 5, top: 10),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            greeting(widget.user.name),
                                            style: TextStyle(
                                                color: Colors.grey[200],
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
                                            fontFamily: "Lobster"),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      width: 350,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Colors.redAccent,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Flexible(
                                                    child:
                                                        Text(_currentAddress),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.credit_card,
                                                    color:
                                                        Colors.blueAccent[100],
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                        "You have ${widget.user.credit} Credits."),
                                                  ),
                                                ],
                                              ),
                                                   Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      FontAwesomeIcons.gift,
                                                      color:
                                                          Colors.deepOrange,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                          "You have ${widget.user.points} points."),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Center(
                                      child: Text(
                                        "Your Recycle Listings",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[850]),
                                      ),
                                    ),
                                  ),
                                ),
                                 

                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
                      margin: const EdgeInsets.all(15),
                      elevation: 4,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(23))),
                      
                      child: InkWell(
                        onTap: () => _onRecycleTrash(
                           data[index]['itemid'],
                            data[index]['itemimage'],
                            data[index]['itemtime'],
                            data[index]['itemdesc'],
                            data[index]['itemtitle'],
                            data[index]['itemowner'],
                            data[index]['itemphone'],
                            data[index]['itemlatitude'],
                            data[index]['itemlongitude'],
                            data[index]['itemapprove'],
                            
                            widget.user.points,
                            widget.user.name,
                            widget.user.credit),
                        onLongPress: _onItemDelete,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                child: Image.network(
                                  
                                  "http://lawlietaini.com/myrecycle_user/images/${data[index]['itemimage']}.jpg",height: 150,fit: BoxFit.fitWidth,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                          Text(data[index]['itemtitle'].toString().toUpperCase(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                                          SizedBox(height: 10,),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.phone,color: Colors.lightBlueAccent[400],),
                                              SizedBox(width: 5,),
                                              Text(data[index]['itemphone']),
                                              
                                            ],
                                          ),
                                           Row(
                                            children: <Widget>[
                                              Icon(Icons.timer,color: Colors.grey,),
                                              SizedBox(width: 5,),
                                              Text(data[index]['itemtime'],textAlign: TextAlign.right,),
                                              
                                            ],
                                          ),

                                      ],

                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: <Widget>[
                                        data[index]['itemapprove']=='0' ? Text('Pending',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.red)):Text('Approve',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.green))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 100,
                                    child: VerticalDivider(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: <Widget>[
                                          Icon(
                                            Icons.chevron_right,
                                            size: 45,
                                            color: Colors.black45,
                                          ),
                                      ],
                                    ),
                                  )
                                 /* Container(
                                    height: 130,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(color: Colors.white),
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                "http://lawlietaini.com/myrecycle_user/images/${data[index]['itemimage']}.jpg"))),
                                  ),*/
                                /*  Expanded(
                                    flex: 2,
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
                                              initialRating: double.parse(
                                                  data[index]['itemrating']
                                                      .toString()),
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 2.0),
                                              itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.teal[700],
                                                  )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Icon(Icons.phone),
                                          Text(data[index]['itemphone']),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(data[index]['itemtime']),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.chevron_right,
                                            size: 45,
                                            color: Colors.black45,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )*/
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              },
            ),
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
      "points": widget.user.points ?? "10",
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
      String itemid,
      String itempicture,
      String picktime,
      String itemdesc,
      String itemtitle,
      String itemowner,
      String itemphone,
      String itemlatitude,
      String itemlongitude,
      String itemapprove,
    
      String itempoint,
      
      
      String name,
      String credit) {
    Item item = new Item(
      itemid: itemid,
      itempicture: itempicture,
      picktime: picktime,
      itemdesc: itemdesc,
      itemtitle: itemtitle,
      itemowner: itemowner,
      itemphone: itemphone,
      itemlatitude: itemlatitude,
      itemlongitude: itemlongitude,
      itemapprove: itemapprove,
      
    );
    print(itemid);
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

  void _onItemDelete() {
    print('Enter delete');
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Delete Recycle Item",
      desc: "Are you sure want to delete your items from the list?",
      buttons: [
        DialogButton(
          child: Text(
            "Yes, Delete.",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: (){

          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();

  }

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
