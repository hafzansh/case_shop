import 'package:poggers/services/firebase_services.dart';
import 'package:poggers/widgets/custom_actionbar.dart';
import 'package:poggers/widgets/forminputfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//ignore: must_be_immutable
class AddAddress extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final FirebaseServices _firebaseServices = FirebaseServices();
  String name;
// ignore: non_constant_identifier_names
  String mobile_no;
  String houseno;
  String roadname;
  String landmark;
  String city;
  String state;
  String pincode;
  AddAddress({this.name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 120, left: 30, right: 30),
            child: Form(
              key: _formkey,
              child: ListView(
                children: [
                  FormInputField(
                    hinttext: 'Nama',
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  FormInputField(
                    hinttext: 'Nomor Handphone',
                    onChanged: (value) {
                      mobile_no = value;
                    },
                  ),
                  FormInputField(
                    hinttext: 'Alamat Rumah',
                    onChanged: (value) {
                      houseno = value;
                    },
                  ),
                  FormInputField(
                    hinttext: 'Jalan',
                    onChanged: (value) {
                      roadname = value;
                    },
                  ),
                  FormInputField(
                    hinttext: 'Kecamatan',
                    onChanged: (value) {
                      landmark = value;
                    },
                  ),
                  FormInputField(
                    hinttext: 'Kota',
                    onChanged: (value) {
                      city = value;
                    },
                  ),
                  FormInputField(
                    hinttext: 'Provinsi',
                    onChanged: (value) {
                      state = value;
                    },
                  ),
                  FormInputField(
                    hinttext: 'Kode POS',
                    onChanged: (value) {
                      pincode = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        if (_formkey.currentState.validate()) {
                          _firebaseServices.userref
                              .doc(_firebaseServices.getuserid())
                              .collection('Addresses')
                              .add({
                            'name': name,
                            'mobile_no': mobile_no,
                            'house_no': houseno,
                            'road_name': roadname,
                            'landmark': landmark,
                            'city': city,
                            'state': state,
                            'pincode': pincode
                          }).then((value) {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Add',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          CustomActionBar(
            hasbackarrow: true,
            hascartbutton: false,
            hasbackground: true,
            hastitle: true,
            title: 'Add Address',
          )
        ],
      ),
    );
  }
}
