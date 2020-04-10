import 'package:expiry_remainder/pages/product-detail.page.dart';
import 'package:flutter/material.dart';

onTapProductDetail({
  @required BuildContext context,
  @required String productName,
  @required String expiryDate,
  @required String imagedownloadURL,
  @required bool isExpired,
  @required String category,
}) {
  Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) => new ProductDetailPage(
        category: category,
          isExpired: isExpired,
          productName: productName.toString().toUpperCase(),
          expiryDate: expiryDate,
          imagedownloadURL: imagedownloadURL)));
}
