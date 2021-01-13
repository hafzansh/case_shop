import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:poggers/services/firebase_services.dart';
import 'package:poggers/streams/productpage.dart';
import 'package:poggers/streams/shipaddress.dart';
import 'package:poggers/widgets/custom_actionbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  int totalcartprice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _firebaseServices.userref
                  .doc(_firebaseServices.getuserid())
                  .collection('Cart')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Center(
                      child: Text(snapshot.error.toString()),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  return Stack(
                    children: [
                      ListView(
                          padding: EdgeInsets.only(top: 130.0, bottom: 24.0),
                          children: snapshot.data.docs.map((document) {
                            totalcartprice =
                                totalcartprice + document.data()['price'];
                            return GestureDetector(
                                onTap: () {
                                  Get.to(ProductPage(id: document.id));
                                },
                                child: FutureBuilder(
                                    future: _firebaseServices.productref
                                        .doc(document.id)
                                        .get(),
                                    builder: (context, productsnap) {
                                      if (productsnap.hasError) {
                                        return Container(
                                          child: Center(
                                            child: Text('${productsnap.error}'),
                                          ),
                                        );
                                      }
                                      if (productsnap.connectionState ==
                                          ConnectionState.done) {
                                        Map _productmap =
                                            productsnap.data.data();
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 24.0, vertical: 12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 90,
                                                height: 90,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.network(
                                                    '${_productmap['images'][0]}',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 200,
                                                padding:
                                                    EdgeInsets.only(left: 10.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${_productmap['title']}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 6.0),
                                                      child: Text(
                                                        '${fc.format(_productmap['price'])}',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${document.data()['size']}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  totalcartprice =
                                                      totalcartprice -
                                                          document
                                                              .data()['price'];
                                                  _firebaseServices.userref
                                                      .doc(_firebaseServices
                                                          .getuserid())
                                                      .collection('Cart')
                                                      .doc(document.id)
                                                      .delete();
                                                  totalcartprice = 0;
                                                },
                                                child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0)),
                                                    child: Icon(
                                                      Icons.cancel,
                                                      color: Colors.white,
                                                    )),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      return Container(
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    }));
                          }).toList()),
                      Positioned(
                        bottom: 0,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 85,
                            decoration: BoxDecoration(color: Colors.blueGrey),
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'SubTotal : ',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '${fc.format(totalcartprice)}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(ShippingAddress(), arguments: [
                                        totalcartprice.toString()
                                      ]);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Text(
                                          'Alamat',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w600),
                                        )),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ],
                  );
                }
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
          CustomActionBar(
            title: 'Keranjang',
            hastitle: true,
            hasbackground: true,
            hasbackarrow: true,
            hascartbutton: false,
          )
        ],
      ),
    );
  }
}
