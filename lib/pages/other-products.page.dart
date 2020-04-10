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

class OtherProductsPage extends StatefulWidget {
  @override
  _OtherProductsPageState createState() => _OtherProductsPageState();
}

class _OtherProductsPageState extends State<OtherProductsPage> {
  var otherproducts;
  CRUDMethods crudObj = new CRUDMethods();
  Future<void> _onRefresh() async {
    crudObj
        .getData(useremail: UserInfo.useremail, category: "other")
        .then((results) {
      setState(() {
        otherproducts = results;
      });
    });
  }

  @override
  void initState() {
    crudObj
        .getData(useremail: UserInfo.useremail, category: "other")
        .then((results) {
      setState(() {
        otherproducts = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addOtherProduct = () => {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => AddProductPage(
                    category: "other",
                    useremail: UserInfo.useremail,
                  )))
        };
    return Scaffold(
      appBar: appBar(title: "Other Products"),
      body:
          new RefreshIndicator(child: _otherDataList(), onRefresh: _onRefresh),
      floatingActionButton: FAB(onPressed: addOtherProduct),
    );
  }

  Widget _otherDataList() {
    if (otherproducts != null) {
      return Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: stremBuilderWidget(
                context: context, category: "other", stream: otherproducts),
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
                child: new Image(image: AssetImage("assets/images/other.png")),
              ),
            ),
          ),
          new Text(
            "Click the '+' button to Add your Other Products",
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
