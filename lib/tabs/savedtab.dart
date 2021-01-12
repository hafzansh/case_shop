import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poggers/services/firebase_services.dart';
import 'package:poggers/streams/productpage.dart';
import 'package:poggers/widgets/custom_actionbar.dart';
import 'package:flutter/material.dart';

class SavedTab extends StatelessWidget {
  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: _firebaseServices.userref
                .doc(_firebaseServices.getuserid())
                .collection('Saved')
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
                return ListView(
                    padding: EdgeInsets.only(top: 130.0, bottom: 24.0),
                    children: snapshot.data.docs.map((document) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductPage(id: document.id)));
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
                                  Map _productmap = productsnap.data.data();
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24.0, vertical: 12.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        color: Theme.of(context).accentColor,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 200,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20)),
                                                child: Image.network(
                                                  '${_productmap['images'][0]}',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 16.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${_productmap['title']}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    // _firebaseServices.userref
                                                    //     .doc(_firebaseServices
                                                    //         .getuserid())
                                                    //     .collection('Saved')
                                                    //     .doc(document.id)
                                                    //     .delete();
                                                    showAlertDialog(
                                                        context, document);
                                                  },
                                                  child: Container(
                                                      width: 60,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      2.0)),
                                                      child: Icon(
                                                        Icons.delete_outline,
                                                        color: Colors.white,
                                                      )),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }));
                    }).toList());
              }
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }),
        CustomActionBar(
          title: 'Saved Items',
          hasbackarrow: false,
          hastitle: true,
        )
      ],
    );
  }

  showAlertDialog(BuildContext context, document) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Delete"),
      onPressed: () {
        _firebaseServices.userref
            .doc(_firebaseServices.getuserid())
            .collection('Saved')
            .doc(document.id)
            .delete();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hapus Item"),
      content: Text("Item ini akan dihapus dari Favorit anda?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
