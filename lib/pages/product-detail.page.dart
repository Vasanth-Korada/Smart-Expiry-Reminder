import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiry_remainder/pages/signin.page.dart';
import 'package:expiry_remainder/widgets/app-bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as Path;

class ProductDetailPage extends StatefulWidget {
  final String productName;
  final String expiryDate;
  final String imagedownloadURL;
  final bool isExpired;
  final String category;
  ProductDetailPage({
    @required this.productName,
    @required this.expiryDate,
    @required this.imagedownloadURL,
    @required this.isExpired,
    @required this.category,
  });
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    int index = widget.productName.indexOf("~");
    return Scaffold(
      appBar: appBar(title: widget.productName.substring(0, index)),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: new ListView(
          children: <Widget>[
            Container(
              color:widget.isExpired?Colors.redAccent: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      widget.isExpired
                          ? "Expired on${widget.expiryDate}"
                          : "Expires on${widget.expiryDate}",
                      style: TextStyle(color: Colors.white, fontSize: 20.0,fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            // new Divider(
            //   color: Colors.black54,
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    child: Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width - 10,
                      child: new RaisedButton(
                        onPressed: () async {
                          setState(() {
                            _loading = true;
                          });

                          FirebaseStorage(
                                  storageBucket:
                                      'gs://expiry-remainder.appspot.com')
                              .ref()
                              .child(
                                  "users/${UserInfo.useremail}/${widget.category}/${widget.productName}/image")
                              .delete()
                              .then((_) {
                            print(
                                "${widget.productName} Image Deleted Successfully");
                          });
                          Firestore.instance
                              .collection('users')
                              .document(UserInfo.useremail)
                              .collection(widget.category)
                              .document(widget.productName)
                              .delete()
                              .then((_) {
                            Navigator.of(context).pop();
                            setState(() {
                              _loading = false;
                            });
                          });
                        },
                        color: Colors.red[400],
                        child: Text(
                          "DELETE THIS PRODUCT",
                          style: TextStyle(fontSize: 17.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: new SingleChildScrollView(
                child: widget.imagedownloadURL == null ||
                        widget.imagedownloadURL == ""
                    ? Image.asset("assets/images/${widget.category}.png")
                    : new Image.network(widget.imagedownloadURL),
              ),
            ),
            new SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
