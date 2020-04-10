import 'package:expiry_remainder/helpers/crud.dart';
import 'package:expiry_remainder/helpers/onTap-productdetail.dart';
import 'package:expiry_remainder/pages/add-product.page.dart';
import 'package:expiry_remainder/pages/grocery-products.page.dart';
import 'package:expiry_remainder/pages/other-products.page.dart';
import 'package:expiry_remainder/pages/signin.page.dart';
import 'package:expiry_remainder/widgets/app-bar.dart';
import 'package:expiry_remainder/widgets/fab.dart';
import 'package:expiry_remainder/widgets/share-widget.dart';
import 'package:expiry_remainder/widgets/streambuilder.widget.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:url_launcher/url_launcher.dart';
import 'helpers/admob.dart';

class HomePage extends StatefulWidget {
  final userName;
  final userEmail;
  final userPhoto;
  HomePage({this.userName, this.userEmail, this.userPhoto});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  Firestore _firestore = Firestore.instance;
  CRUDMethods crudObj = new CRUDMethods();
  var medicalproducts;
  var welcomeMessage;

  _launchRateUs() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.vktech.expiry_remainder';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _logout() async {
    _googleSignIn.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', null);
    setState(() {
      UserInfo.useremail = '';
      IsLogged.name = '';
      IsLogged.isloggedin = false;
    });

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
  }

  Future<void> _onRefresh() async {
    crudObj
        .getData(useremail: widget.userEmail, category: "medical")
        .then((results) {
      setState(() {
        medicalproducts = results;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    

    crudObj
        .getData(useremail: widget.userEmail, category: "medical")
        .then((results) {
      setState(() {
        medicalproducts = results;
      });
    });
    Firestore.instance
        .collection("Assets")
        .document("welcomemessage")
        .get()
        .then((data) {
      setState(() {
        welcomeMessage = data["message"];
      });
    });
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-8559543158044506/7874859398")
        .then((response) {
      myBanner
        ..load()
        ..show();
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    final addMedicalProduct = () => {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => AddProductPage(
                    category: "medical",
                    useremail: widget.userEmail,
                  )))
        };
    return Scaffold(
      appBar: appBar(title: "Expiry Reminder App"),
      drawer: new Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                            widget.userPhoto != null ? widget.userPhoto : ""))),
              ),
              accountEmail: Text("${widget.userEmail}"),
              accountName: Text("${widget.userName}".toUpperCase()),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              color: Colors.deepPurple.shade500,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: new ListTile(
                title: Text(
                  "Hi " +
                      widget.userName.toString().split(" ")[0] +
                      " 😃,\n$welcomeMessage",
                  style: new TextStyle(fontSize: 13.0, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Divider(
                  color: Colors.black54,
                ),
              ),
            ),
            Expanded(
                flex: 45,
                child: ListView(
                  children: <Widget>[
                    new ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GroceryProductsPage()));
                        },
                        title: Text("Add Grocery Products",
                            style: TextStyle(fontSize: 15.0)),
                        leading: new Icon(
                          Icons.local_grocery_store,
                          color: Colors.deepPurple,
                        )),
                    new ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OtherProductsPage()));
                        },
                        title: Text("Add Other Products",
                            style: TextStyle(fontSize: 15.0)),
                        leading: new Icon(Icons.add_shopping_cart,
                            color: Colors.deepPurple)),
                    new ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        _launchRateUs();
                      },
                      leading: Icon(Icons.star, color: Colors.deepPurple),
                      title: Text(
                        "Rate Us",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    new ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        share();
                      },
                      leading: Icon(Icons.share, color: Colors.deepPurple),
                      title: Text(
                        "Share",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    new ListTile(
                        onTap: () {
                          _logout();
                        },
                        title: Text("Logout", style: TextStyle(fontSize: 15.0)),
                        leading: new Icon(Icons.power_settings_new,
                            color: Colors.deepPurple)),
                  ],
                )),
          ],
        ),
      ),
      body: RefreshIndicator(child: _medicalDataList(), onRefresh: _onRefresh),
      floatingActionButton: FAB(onPressed: addMedicalProduct),
    );
  }

  Widget _medicalDataList() {
    if (medicalproducts != null) {
      return Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: stremBuilderWidget(
                context: context, category: "medical", stream: medicalproducts),
          ),
          new SizedBox(
            height: 60.0,
          ),
        ],
      );
    } else {
      return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new SizedBox(
            height: MediaQuery.of(context).size.height / 5,
          ),
          new Center(
            child: Container(
              decoration: new BoxDecoration(),
              width: 280.0,
              height: 250.0,
              child: Opacity(
                opacity: 0.8,
                child:
                    new Image(image: AssetImage("assets/images/medical.png")),
              ),
            ),
          ),
          new Text(
            "Click the '+' button to Add your Medical Products",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
                fontWeight: FontWeight.w600),
          ),
        ],
      );
    }
  }
}
