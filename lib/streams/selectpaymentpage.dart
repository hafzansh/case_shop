import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:poggers/constants.dart';
import 'package:poggers/widgets/custom_actionbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelectPaymentPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String address_id;

  // ignore: non_constant_identifier_names
  SelectPaymentPage({this.address_id});
  @override
  _SelectPaymentPageState createState() => _SelectPaymentPageState();
}

class _SelectPaymentPageState extends State<SelectPaymentPage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  moveDocumentToOtherCollection(String docId) async {
    var kek = DateTime.now().toString();
    var oldColl = db
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('Cart')
        .doc(docId);
    var newColl = db
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('Transaction')
        .doc(oldColl.id);

    DocumentSnapshot snapshot = await oldColl.get()
        // ignore: missing_return
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        // document id does exist
        print('Successfully found document');

        newColl
            .set({
              'price': docSnapshot['price'],
              'size': docSnapshot['size'],
              'at': kek
            })
            .then((value) => print("document moved to different collection"))
            .catchError((error) => print("Failed to move document: $error"))
            .then((value) => ({
                  oldColl
                      .delete()
                      .then((value) =>
                          print("document removed from old collection"))
                      .catchError((error) {
                    newColl.delete();
                    print("Failed to delete document: $error");
                  })
                }));
      } else {
        //document id doesnt exist
        print('Failed to find document id');
      }
    });
  }

  var data = Get.arguments;
  final fc = new NumberFormat("Rp #,##0", "en_US");
  String cardNumber = "";
  String cardHolderName = "";
  String expiryDate = "";
  String cvv = "";
  bool showBack = false;

  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  var cc = new MaskTextInputFormatter(
      mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});
  var exp = new MaskTextInputFormatter(
      mask: '##/##', filter: {"#": RegExp(r'[0-9]')});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  CreditCard(
                    cardNumber: cardNumber,
                    cardExpiry: expiryDate,
                    cardHolderName: cardHolderName,
                    cardType: CardType.visa,
                    cvv: cvv,
                    bankName: "Credit Card",
                    showBackSide: showBack,
                    frontBackground: CardBackgrounds.black,
                    backBackground: CardBackgrounds.white,
                    showShadow: true,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "Card Number"),
                          keyboardType: TextInputType.number,
                          inputFormatters: [cc],
                          maxLength: 19,
                          onChanged: (value) {
                            setState(() {
                              cardNumber = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "Card Expiry"),
                          keyboardType: TextInputType.number,
                          inputFormatters: [exp],
                          maxLength: 5,
                          onChanged: (value) {
                            setState(() {
                              expiryDate = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: TextFormField(
                          decoration:
                              InputDecoration(hintText: "Card Holder Name"),
                          onChanged: (value) {
                            setState(() {
                              cardHolderName = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "CVV"),
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          onChanged: (value) {
                            setState(() {
                              cvv = value;
                            });
                          },
                          focusNode: _focusNode,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 110),
              child: Container(
                height: 101,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffDCDCDC).withOpacity(0.5)),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 7),
                              child: Text(
                                'Total Tagihan:',
                                style: Constants.textstyle,
                              ),
                            ),
                            Text(
                              '${fc.format(int.parse(data[0]))}',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 200,
                          height: 55,
                          child: RaisedButton(
                              onPressed: () async {
                                moveDocumentToOtherCollection(
                                    "JYb67rRHiMZy3ui0RLzu");
                                //                             final FirebaseAuth _auth = FirebaseAuth.instance;

                                //                             FirebaseUser user = await _auth.currentUser();
                                //                             userFirebaseInstance
                                // .collection(NewCollection)
                                // .document()
                                // .setData(YourDataHere)
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.blueGrey)),
                              color: Colors.blueGrey,
                              textColor: Colors.white,
                              child: Text("Bayar".toUpperCase(),
                                  style: TextStyle(fontSize: 16))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 0),
          //   child: Center(
          //       child: Text(
          //     'Pay using',
          //     style: Constants.boldheading,
          //   )),
          // ),
          CustomActionBar(
            hastitle: true,
            title: 'Pembayaran',
            hascartbutton: false,
            hasbackarrow: true,
            hasbackground: true,
          )
        ],
      ),
    );
  }
}
