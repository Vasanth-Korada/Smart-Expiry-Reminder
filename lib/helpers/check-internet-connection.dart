import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

Future<bool> checkInternetConnectivity(BuildContext context) async {
  var connectivityResult = await (new Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return true;
  }
}

ShowDialog({@required BuildContext context,@required String content}) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: ListTile(
        title: Text(content),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
