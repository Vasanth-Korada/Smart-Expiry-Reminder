import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiry_remainder/pages/signin.page.dart';
import 'package:flutter/material.dart';

class CRUDMethods {
  Future<void> addData(
      {@required String category,
      @required String useremail,
      @required String productName,
      @required String expiryDate,
      @required bool isExpired,
      @required String imagedownloadURL}) async {
    Firestore.instance.runTransaction((Transaction crudTransaction) async {
      CollectionReference reference = Firestore.instance.collection('users');
      reference
          .document(useremail)
          .collection(category)
          .document(productName)
          .setData({
        "productName": productName.toUpperCase(),
        "expiryDate": expiryDate,
        "isExpired": isExpired,
        "createdAt": DateTime.now(),
        "imagedownloadURL": imagedownloadURL,
      });
    });
  }

  getData({@required String useremail, @required String category}) async {
    return Firestore.instance
        .collection('users')
        .document(useremail)
        .collection(category)
        .snapshots();
  }

  
}
