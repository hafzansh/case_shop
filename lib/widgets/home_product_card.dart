import 'package:cached_network_image/cached_network_image.dart';
import 'package:poggers/streams/productpage.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomeProductCard extends StatelessWidget {
  final String productid;
  final String imageurl;
  final String title;
  final String price;
  HomeProductCard({this.productid, this.imageurl, this.title, this.price});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductPage(id: productid)));
      },
      child: Container(
        height: 280,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: CachedNetworkImage(
                  imageUrl: imageurl,
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(1.0),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover))),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, top: 5),
              child: Text(
                // products is out demo list
                title ?? 'Product Name',
                style: TextStyle(color: Colors.grey[700], fontSize: 15),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "IDR. $price",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
