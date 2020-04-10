import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiry_remainder/helpers/onTap-productdetail.dart';
import 'package:expiry_remainder/pages/signin.page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget stremBuilderWidget(
    {@required BuildContext context,
    @required String category,
    @required Stream stream}) {
  return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Loading ..."),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new LinearProgressIndicator(backgroundColor: Colors.deepPurple),
                )
              ],
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data.documents.isEmpty) {
          return Column(
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
                    child: new Image(
                        image: AssetImage("assets/images/$category.png")),
                  ),
                ),
              ),
              new Text(
                "Click the '+' button to Add your $category Products",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600),
              ),
            ],
          );
        }
        var length = snapshot.data.documents.length;
        return Scrollbar(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, i) {
                var productName =
                    snapshot.data.documents[length - i - 1].data['productName'];
                int index = productName.toString().indexOf("~");

                var expiryDate = snapshot
                    .data.documents[length - i - 1].data['expiryDate']
                    .toString();
                bool isExpired =
                    snapshot.data.documents[length - i - 1].data["isExpired"];
                String imagedownloadURL = snapshot
                    .data.documents[length - i - 1].data['imagedownloadURL'];

                if (DateTime.now().isAfter(DateTime.parse(expiryDate))) {
                  isExpired = true;
                  Firestore.instance
                      .collection('users')
                      .document(UserInfo.useremail)
                      .collection("$category")
                      .document(productName)
                      .updateData({"isExpired": true});
                }

                return Card(
                  margin: EdgeInsets.all(8.0),
                  color: Colors.white60,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                    children: <Widget>[
                      ClipRect(
                        child: isExpired
                            ? Banner(
                                message: "Expired",
                                location: BannerLocation.topEnd,
                                child: new ListTile(
                                  leading: new CircleAvatar(
                                      radius: 28.0,
                                      backgroundImage: imagedownloadURL != null
                                          ? NetworkImage(imagedownloadURL)
                                          : AssetImage(
                                              "assets/images/$category.png")),
                                  title: Text(
                                    productName
                                        .toUpperCase()
                                        .substring(0, index),
                                    style: new TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple),
                                  ),
                                  subtitle: Text(
                                    "Expires on" +
                                        " ${DateFormat("dd-MM-yyyy").format(DateTime.parse(expiryDate))}"
                                            .substring(0, 11),
                                    style: new TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onTap: () {
                                    onTapProductDetail(
                                        category: "$category",
                                        isExpired: isExpired,
                                        productName: productName,
                                        expiryDate:
                                            " ${DateFormat("dd-MM-yyyy").format(DateTime.parse(expiryDate))}",
                                        imagedownloadURL: imagedownloadURL,
                                        context: context);
                                  },
                                ),
                              )
                            : new ListTile(
                                leading: new CircleAvatar(
                                  radius: 28.0,
                                  backgroundImage: imagedownloadURL != null
                                      ? NetworkImage(imagedownloadURL)
                                      : AssetImage(
                                          "assets/images/$category.png"),
                                ),
                                title: Text(
                                  productName.toUpperCase().substring(0, index),
                                  style: new TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple),
                                ),
                                subtitle: Text(
                                  "Expires on" +
                                      " ${DateFormat("dd-MM-yyyy").format(DateTime.parse(expiryDate))}"
                                          .substring(0, 11),
                                  style: new TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onTap: () {
                                  onTapProductDetail(
                                    category: "$category",
                                    isExpired: isExpired,
                                    productName: productName,
                                    expiryDate:
                                        " ${DateFormat("dd-MM-yyyy").format(DateTime.parse(expiryDate))}",
                                    imagedownloadURL: imagedownloadURL,
                                    context: context,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              }),
        );
      });
}
