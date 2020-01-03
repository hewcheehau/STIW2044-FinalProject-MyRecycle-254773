import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrecycle/mainscreen.dart';
import 'package:myrecycle/tabscreen/tabscreen.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'reward.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

String urlRedeem = 'http://lawlietaini.com/myrecycle_user/php/redeem.php';
String urlgetuser = "http://lawlietaini.com/myrecycle_user/php/get_user.php";

class RewardDetail extends StatefulWidget {
  final User user;
  final Reward reward;
  RewardDetail({Key key, this.user, this.reward}) : super(key: key);

  @override
  _RewardDetailState createState() => _RewardDetailState();
}

class _RewardDetailState extends State<RewardDetail> {
  List rewards = new List();
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
//SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
//SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      
        body: SafeArea(
      top: false,
      child: SingleChildScrollView(
              child: Column(
          
          children: <Widget>[
            
            Stack(
              children: <Widget>[
               
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "http://lawlietaini.com/myrecycle_user/images/${widget.reward.rewardimage}.jpg")),
                  ),
                  height: 300.0,
                ),
               
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xCC000000),
                        const Color(0x00000000),
                        const Color(0x00000000),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  left: 0.0,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Points',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      VerticalDivider(color: Colors.black),
                      Text('Valid Date Until',
                          style: TextStyle(fontSize: 18, color: Colors.black54)),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(widget.reward.rewardpoint,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.greenAccent[700],
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 10,
                          ),
                          _printWord(),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            widget.reward.rewarddataend,
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.black54,
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Highlight',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.reward.rewarddesc,
                              style:
                                  TextStyle(color: Colors.black54, fontSize: 17),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Term and Conditions',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '- This voucher only valid for the MyRecycle user\n- All the decision right will follow by MyRecycle',
                              style:
                                  TextStyle(color: Colors.black54, fontSize: 17),
                            )
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0.0, 7.0),
                          blurRadius: 10.0,
                        )
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Column(
                     
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: MaterialButton(
                            height: 50,
                            minWidth: 400,
                            child: Text(
                              'Redeem',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.greenAccent[700],
                            onPressed: _redeemPoint,
                            splashColor: Colors.green[200],
                          ),
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
    ));
  }

  _printWord() {
    const text = Text(
      'points',
      style: TextStyle(fontSize: 19),
    );
    return text;
  }

  _redeemPoint()  {
    
    print(widget.reward.rewardid);

      ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Redeem-ing");
    pr.show();
    
      http.post(urlRedeem, body: {
     
      "email": widget.user.email,
      "points": widget.user.points,
      "itempoint":widget.reward.rewardpoint,
      "itemid":widget.reward.rewardid

    }).then((res) {
      print(urlRedeem);
      print(widget.user.email);
      print(widget.reward.rewardpoint);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        
        
        pr.dismiss();
        print(widget.user.email);
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
                title: Text('Your Redeem Code'),
                content: Text("${widget.reward.rewardcode}",style: TextStyle(color: Colors.blue[900],fontSize: 20,fontWeight: FontWeight.bold),),
                actions: <Widget>[
                  FlatButton(
                    onPressed: (){
                        setState(() {

                        });
                      
                        _onLogin(widget.user.email, context);
                    //    Navigator.pop(context);
                      //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(user: widget.user,)));
                    },
                    child: Text('Ok'),
                  )
                ],
            );
          }
        );
        
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

  void _loadCode(){

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
            points: dres[4],
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
