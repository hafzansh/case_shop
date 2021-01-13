import 'package:poggers/constants.dart';
import 'package:poggers/widgets/custom_actionbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:upi_pay/upi_pay.dart';
import 'package:intl/intl.dart';

class SelectPaymentPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String address_id;

  // ignore: non_constant_identifier_names
  SelectPaymentPage({this.address_id});
  @override
  _SelectPaymentPageState createState() => _SelectPaymentPageState();
}

class _SelectPaymentPageState extends State<SelectPaymentPage> {
  var data = Get.arguments;
  final fc = new NumberFormat("Rp #,##0", "en_US");
  Future<List<ApplicationMeta>> _appsFuture;
  @override
  void initState() {
    _appsFuture = UpiPay.getInstalledUpiApplications();
    super.initState();
  }

  Future initiatetransaction(ApplicationMeta app) {
    return UpiPay.initiateTransaction(
        app: app.upiApplication,
        receiverUpiAddress: '7066852002@ybl',
        receiverName: 'Prasaneet',
        transactionRef: '123456788',
        amount: '1',
        merchantCode: 'BCR2DN6TWOU7LT2I');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 110),
            child: Container(
              height: 141,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xffDCDCDC).withOpacity(0.5)),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'Total Tagihan:',
                    style: Constants.textstyle,
                  ),
                  Text(
                    '${fc.format(int.parse(data[0]))}',
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 36,
                        fontWeight: FontWeight.w600),
                  ),
                  // Text(
                  //   'Order Details...>>>',
                  //   style: TextStyle(
                  //       color: Colors.blueAccent,
                  //       fontWeight: FontWeight.w600,
                  //       fontSize: 20),
                  // )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Center(
                child: Text(
              'Pay using',
              style: Constants.boldheading,
            )),
          ),
          FutureBuilder<List<ApplicationMeta>>(
            future: _appsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: Text('something went  wrong'),
                );
              }
              return ListView(
                  padding: EdgeInsets.only(top: 450, right: 30, left: 30),
                  shrinkWrap: true,
                  children: snapshot.data.map((app) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: GestureDetector(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.memory(
                                app.icon,
                                width: 50,
                                height: 50,
                              ),
                              Text(
                                '${app.upiApplication.getAppName()}',
                                style: Constants.textstyle,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList());
            },
          ),
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
