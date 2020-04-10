import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiry_remainder/helpers/crud.dart';
import 'package:expiry_remainder/helpers/onTap-productdetail.dart';
import 'package:expiry_remainder/pages/signin.page.dart';
import 'package:expiry_remainder/widgets/app-bar.dart';
import 'package:expiry_remainder/widgets/fab.dart';
import 'package:expiry_remainder/widgets/streambuilder.widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'add-product.page.dart';

class GroceryProductsPage extends StatefulWidget {
  @override
  _GroceryProductsPageState createState() => _GroceryProductsPageState();
}

class _GroceryProductsPageState extends State<GroceryProductsPage> {
  var groceryproducts;
  CRUDMethods crudObj = new CRUDMethods();
  Future<void> _onRefresh() async {
    crudObj
        .getData(useremail: UserInfo.useremail, category: "grocery")
        .then((results) {
      setState(() {
        groceryproducts = results;
      });
    });
  }

  @override
  void initState() {
    crudObj
        .getData(useremail: UserInfo.useremail, category: "grocery")
        .then((results) {
      setState(() {
        groceryproducts = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addGroceryProduct = () => {
          debugPrint("User Email:" + UserInfo.useremail.toString()),
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => AddProductPage(
                    category: "grocery",
                    useremail: UserInfo.useremail,
                  )))
        };
    return Scaffold(
      appBar: appBar(title: "Grocery Products"),
      body: new RefreshIndicator(
          child: _groceryDataList(), onRefresh: _onRefresh),
      floatingActionButton: FAB(onPressed: addGroceryProduct),
    );
  }

  Widget _groceryDataList() {
    if (groceryproducts != null) {
      return Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: stremBuilderWidget(
                context: context, category: "grocery", stream: groceryproducts),
          ),
          new SizedBox(
            height: 60.0,
          ),
        ],
      );
    } else {
      return new Column(
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
                    new Image(image: AssetImage("assets/images/grocery.png")),
              ),
            ),
          ),
          new Text(
            "Click the '+' button to Add your Grocery Products",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
                fontWeight: FontWeight.w600),
          ),
        ],
      );
    }
  }
}
