import 'package:flutter/material.dart';

Widget FAB({@required Function onPressed}) {
  return Container(
    padding: EdgeInsets.only(bottom: 50.0),
    child: new FloatingActionButton(
      onPressed: onPressed,
      child: new Icon(Icons.add),
    ),
  );
}
