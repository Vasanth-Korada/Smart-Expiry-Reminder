import 'package:expiry_remainder/home-page.dart';
import 'package:expiry_remainder/pages/signin.page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    title: "Smart Expiry Reminder",
    debugShowCheckedModeBanner: false,
    home: new SignIn(),
    theme: ThemeData(
      primaryColor: Colors.deepPurple,
      primarySwatch: Colors.deepPurple,
      cursorColor: Colors.purple,
      buttonColor: Colors.deepPurpleAccent,
      dividerColor: Colors.grey,
      errorColor: Colors.redAccent,
    ),
  ));
}
