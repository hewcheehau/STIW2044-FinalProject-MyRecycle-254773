import 'package:flutter/material.dart';
import 'package:myrecycle/mainscreen.dart';
import 'item.dart';
import 'package:myrecycle/user.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class ItemDetail extends StatefulWidget {
  final Item item;
  final User user;

  const ItemDetail({Key key, this.item, this.user}) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    AppBar(
                      title: Text('Your Recycle Item',
                          style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.tealAccent[700],
                      centerTitle: true,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                  child: DetailInterface(item: widget.item, user: widget.user),
                ),
              ],
            ),
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

class DetailInterface extends StatefulWidget {
  final Item item;
  final User user;
  DetailInterface({this.item, this.user});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _myLocation;
  String urlDelete = "http://lawlietaini.com/myrecycle_user/php/deleteitem.php";

  @override
  void initState() {
    super.initState();
    _myLocation = CameraPosition(
        target: LatLng(double.parse(widget.item.itemlatitude),
            double.parse(widget.item.itemlongitude)),
        zoom: 17);
    print(_myLocation.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailScreen(item:widget.item,))),
                  child: Container(
            width: double.infinity,
            height: 200,
            child: Image.network(
              "http://lawlietaini.com/myrecycle_user/images/${widget.item.itempicture}.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.item.itemtitle.toUpperCase(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Icon(
              FontAwesomeIcons.recycle,
              color: Colors.green,
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Card(
          child: Container(
            height: 100,
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Table(
                  children: [
                    TableRow(children: [
                      Text(
                        "Item Description",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                      Text(widget.item.itemdesc)
                    ])
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 120,
          width: 340,
          child: GoogleMap(
            initialCameraPosition: _myLocation,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 2,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              color: Colors.tealAccent[700],
                            ),
                            Text(
                              'Date added: ',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                        Text(widget.item.picktime, style: TextStyle(fontSize: 15))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.account_box,
                              color: Colors.tealAccent[700],
                            ),
                            Text(
                              'Status: ',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                        widget.item.itemapprove == '0'
                            ? Text('Pending',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.red))
                            : Text('Approve',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.green)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: _onItemDelete,
              color: Colors.red[700],
              child: Text('Delete Item',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }

  void _onItemDelete() {
    print('Enter delete');
    print('this is ${widget.item.itemid}');
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
          onPressed: () {
            ProgressDialog pr = new ProgressDialog(context,
                type: ProgressDialogType.Normal, isDismissible: false);
            pr.style(message: "Deleting");
            pr.show();
            http.post(urlDelete, body: {
              "itemid": widget.item.itemid,
            }).then((res) {
              print(widget.item.itemid);
              if (res.body == 'success') {
                Navigator.pop(context);
                pr.dismiss();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Item Deleted',
                            style: TextStyle(fontSize: 20)),
                        content: Text('The item is deleted successfully.'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainScreen(
                                          user: widget.user,
                                        ))),
                            child: Text('Ok'),
                          ),
                        ],
                      );
                    });
              } else {
                Toast.show(res.body, context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                pr.dismiss();
              }
            });
          },
          color: Colors.red,
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
}

class DetailScreen extends StatefulWidget {
  final  Item item;
  const DetailScreen({Key key, this.item}) : super(key: key);

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
        title: Text('Item Picture'),
      ),
      body: Container(
        child: Center(
          child: Hero(
            tag: 'Item Picture',
            child: Image.network(
                "http://lawlietaini.com/myrecycle_user/images/${widget.item.itempicture}.jpg",width: double.infinity,),
          ),
        ),
      ),
    );
  }
}