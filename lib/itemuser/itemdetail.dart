import 'package:flutter/material.dart';
import 'package:myrecycle/mainscreen.dart';
import 'item.dart';
import 'package:myrecycle/user.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';


class ItemDetail extends StatefulWidget {

  final Item item;
  final User user;

  const ItemDetail({Key key, this.item,this.user}): super(key:key);

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
              appBar: AppBar(
                title: Text("ITEM DETAILS"),
                centerTitle: true,
                backgroundColor: Colors.greenAccent[700],
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: DetailInterface(
                    item: widget.item,
                    user:widget.user
                  ),
                ),
              ),
            ),
          );
        }
      
        Future<bool> _onBackPressAppBar() {
          Navigator.pop(
            context, MaterialPageRoute(
              builder: (context)=>MainScreen(user:widget.user)
            )
          );
          return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {

  final Item item;
  final User user;
  DetailInterface({this.item,this.user});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  Completer<GoogleMapController>_controller = Completer();
  CameraPosition _myLocation;

  @override
  void initState() {
    super.initState();
    _myLocation = CameraPosition(
      target: LatLng(
        double.parse(widget.item.itemlatitude),double.parse(widget.item.itemlongitude)),
        zoom: 17
      
    );
    print(_myLocation.toString());

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(),
        Container(
          width: 280,
          height: 200,
          child: Image.network(
            "http://lawlietaini.com/myrecycle_user/images/${widget.item.itempicture}.jpg",
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(height: 10,),
        Text(widget.item.itemtitle.toUpperCase(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5,),
              Table(children: [
                TableRow(
                  children:[
                Text("Item Description",style: TextStyle(fontWeight: FontWeight.bold),),
                Text(widget.item.itemdesc)
              ])
              ],)
            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(
          height: 120,
          width: 340,
          child: GoogleMap(
            initialCameraPosition: _myLocation,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
            },
          ),
        )
      ],
      
    );
  }
}