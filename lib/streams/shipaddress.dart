import 'package:get/get.dart';
import 'package:poggers/services/firebase_services.dart';
import 'package:poggers/streams/add_address.dart';
import 'package:poggers/streams/selectpaymentpage.dart';
import 'package:poggers/widgets/custom_actionbar.dart';
import 'package:poggers/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ShippingAddress extends StatefulWidget {
  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  var data = Get.arguments;
  FirebaseServices _firebaseServices = FirebaseServices();
  String gvalue;
  @override
  void initState() {
    _firebaseServices.userref
        .doc(_firebaseServices.getuserid())
        .collection('Addresses')
        .get()
        .then((data) {
      // setState(() {
      //   addresses = data.docs;
      // });
      // print(addresses);
      setState(() {
        gvalue = data.docs.first.id;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: _firebaseServices.userref
                .doc(_firebaseServices.getuserid())
                .collection('Addresses')
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasError) {
                return Container(
                  child: Center(
                    child: Text('${snapshots.error}'),
                  ),
                );
              }
              if (snapshots.connectionState == ConnectionState.active) {
                return ListView(
                  padding: EdgeInsets.only(
                      top: 165, bottom: 50, left: 10, right: 10),
                  children: snapshots.data.docs.map<Widget>((document) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                groupValue: gvalue,
                                value: document.id,
                                onChanged: (value) {
                                  setState(() {
                                    gvalue = value;
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, top: 15, bottom: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${document.data()['name']}',
                                      style: Constants.adtextstyleb,
                                    ),
                                    Text(
                                      '${document.data()['mobile_no']}\n'
                                      '${document.data()['house_no']}, ${document.data()['road_name']}\n'
                                      '${document.data()['state']}, ${document.data()['city']}\n'
                                      '${document.data()['pincode']}',
                                      style: Constants.adtextstyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  }).toList(),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                Get.to(SelectPaymentPage(address_id: gvalue), arguments: data);
              },
              child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12.0),
                          topLeft: Radius.circular(12.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 32)
                      ]),
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Pembayaran',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600,
                            fontSize: 22),
                      ),
                    ),
                  )),
            ),
          ),
          Positioned(
            top: 110,
            child: GestureDetector(
              onTap: () {
                Get.to(AddAddress());
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(color: Color(0xffDCDCDC)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle,
                      color: Theme.of(context).accentColor,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Tambah Alamat',
                      style: Constants.textstyle,
                    )
                  ],
                ),
              ),
            ),
          ),
          CustomActionBar(
            title: 'Alamat',
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
