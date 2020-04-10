import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiry_remainder/helpers/check-internet-connection.dart';
import 'package:expiry_remainder/helpers/crud.dart';
import 'package:expiry_remainder/pages/signin.page.dart';
import 'package:expiry_remainder/widgets/app-bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddProductPage extends StatefulWidget {
  final String category;
  final String useremail;
  AddProductPage({@required this.category, @required this.useremail});
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  File _image;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String _downloadURL;
  bool _loading = false;
  bool autoValidate = false;
  DateTime expirydate;
  CRUDMethods crudObj = new CRUDMethods();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController productcontroller = new TextEditingController();
  TextEditingController datecontroller = new TextEditingController();
  var selectedDate = new DateTime.now();

  Future uploadImage(BuildContext context) async {
    var pid = DateTime.now().toString();
    if (_image == null) {
      crudObj.addData(
          category: widget.category,
          useremail: widget.useremail,
          productName: productcontroller.text.toUpperCase() + "~" + pid,
          expiryDate: expirydate.toString(),
          isExpired: false,
          imagedownloadURL: _downloadURL);
      setState(() {
        _loading = false;
      });
      ShowDialog(
          context: context,
          content:
              "${productcontroller.text} added successfully! You will be notified when the product expires.");
    }
    StorageReference storagereference = new FirebaseStorage(
            storageBucket: 'gs://expiry-remainder.appspot.com')
        .ref()
        .child(
            'users/${widget.useremail}/${widget.category}/${productcontroller.text + "~" + pid}/image');
    StorageUploadTask uploadTask = storagereference.putFile(_image);
    await uploadTask.onComplete;
    storagereference.getDownloadURL().then((fileURL) {
      setState(() {
        _downloadURL = fileURL;
        debugPrint("DOWNLOAD URL:" + _downloadURL);
      });
      crudObj.addData(
          category: widget.category,
          useremail: widget.useremail,
          productName: productcontroller.text.toUpperCase() + "~" + pid,
          expiryDate: expirydate.toString(),
          isExpired: false,
          imagedownloadURL: _downloadURL);
    });
    setState(() {
      _loading = false;
    });
    ShowDialog(
        context: context,
        content:
            "${productcontroller.text} added successfully! You will be notified when the product expires.");

    // if (widget.category == "medical") {
    //   Navigator.of(context)
    //       .push(new MaterialPageRoute(builder: (context) => HomePage()));
    // } else if (widget.category == "grocery") {
    //   Navigator.of(context).push(
    //       new MaterialPageRoute(builder: (context) => GroceryProductsPage()));
    // } else {
    //   Navigator.of(context).push(
    //       new MaterialPageRoute(builder: (context) => OtherProductsPage()));
    // }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        datecontroller.value = TextEditingValue(
            text: "Expiry Date: " + picked.toString().substring(0, 10));
        expirydate = picked;
      });
  }

  Future getImage(ImageSource source) async {
    await ImagePicker.pickImage(source: source).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  // showNotification() async {
  //   var android = new AndroidNotificationDetails(
  //       'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
  //       priority: Priority.High, importance: Importance.Max);
  //   var iOS = new IOSNotificationDetails();
  //   var platform = new NotificationDetails(android, iOS);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, 'New Video is out', 'Flutter Local Notification', platform,
  //       payload: 'Nitish Kumar Singh is part time Youtuber');
  // }

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(
      initSetttings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(title: "Add your ${widget.category} product"),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: new ListView(
          children: <Widget>[
            new Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: new TextFormField(
                    autovalidate: autoValidate,
                    textCapitalization: TextCapitalization.characters,
                    controller: productcontroller,
                    decoration: new InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1.5,
                              style: BorderStyle.solid)),
                      icon: Icon(
                        Icons.edit,
                        color: Colors.deepPurple,
                      ),
                      labelText: "Your ${widget.category} product name:",
                    ),
                    validator: (String val) {
                      if (val.isEmpty)
                        return "Name cannot be empty!";
                      else
                        return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        autovalidate: autoValidate,
                        controller: datecontroller,
                        keyboardType: TextInputType.datetime,
                        decoration: new InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 1.5,
                                  style: BorderStyle.solid)),
                          icon: Icon(
                            Icons.dialpad,
                            color: Colors.deepPurple,
                          ),
                          labelText: "Enter expiry date:",
                        ),
                        validator: (String val) {
                          if (val.isEmpty)
                            return "Date cannot be empty!";
                          else
                            return null;
                        },
                      ),
                    ),
                  ),
                ),
                new Column(
                  children: <Widget>[
                    _image == null
                        ? Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width / 14),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return FractionallySizedBox(
                                        heightFactor: 0.25,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  getImage(ImageSource.camera);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.camera),
                                                    new SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      "CAMERA",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .deepPurple),
                                                    ),
                                                  ],
                                                )),
                                            new FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  getImage(ImageSource.gallery);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.photo_album),
                                                    new SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      "GALLERY",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .deepPurple),
                                                    ),
                                                  ],
                                                )),
                                            new SizedBox(height: 50.0)
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                  height: 90.0,
                                  width: 90.0,
                                  child: new Image.asset(
                                      "assets/images/uploadicon.png")),
                            ),
                          )
                        : Container(
                            height: 150.0,
                            width: 450.0,
                            child: Image.file(_image)),
                    _image == null
                        ? new Text("Click to Upload an Image")
                        : Container(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    child: Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width - 10,
                      child: new RaisedButton(
                        onPressed: () async {
                          setState(() {
                            productcontroller.text.isEmpty || expirydate == null
                                ? autoValidate = true
                                : autoValidate = false;
                          });
                          if (autoValidate == false) {
                            setState(() {
                              _loading = true;
                            });
                            FocusScope.of(context).unfocus();
                            uploadImage(context);
                            DateTime now = DateTime.now();

                            var scheduledNotificationDateTime = expirydate.add(
                              Duration(
                                  seconds:
                                      int.parse(DateFormat.s().format(now)),
                                  minutes:
                                      int.parse(DateFormat.m().format(now)),
                                  hours: int.parse(DateFormat.H().format(now))),
                            );
                            debugPrint("SCHEDULED TIME:" +
                                scheduledNotificationDateTime.toString());
                            var androidPlatformChannelSpecifics =
                                AndroidNotificationDetails(
                                    'your other channel id',
                                    'your other channel name',
                                    'your other channel description');
                            var iOSPlatformChannelSpecifics =
                                IOSNotificationDetails();
                            NotificationDetails platformChannelSpecifics =
                                NotificationDetails(
                                    androidPlatformChannelSpecifics,
                                    iOSPlatformChannelSpecifics);

                            await flutterLocalNotificationsPlugin.schedule(
                              0,
                              'Your ${productcontroller.text} is expired!',
                              'Tap to see more',
                              scheduledNotificationDateTime,
                              platformChannelSpecifics,
                              androidAllowWhileIdle: true,
                              payload:
                                  "Your ${productcontroller.text} is expired!",
                            );
                          }
                        },
                        color: Colors.deepPurple,
                        child: Text(
                          "Add my ${widget.category} product",
                          style: TextStyle(fontSize: 17.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
