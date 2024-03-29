import 'package:poggers/constants.dart';
import 'package:poggers/services/firebase_services.dart';
import 'package:poggers/streams/productpage.dart';
import 'package:poggers/widgets/custom_input.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();
  List allproducts = [];
  List searchedproducts = [];
  List finalproducts = [];

  @override
  void initState() {
    _firebaseServices.productref.get().then((data) {
      allproducts = data.docs;
    });
    super.initState();
  }

  search(String value) {
    if (value.length == 0) {
      setState(() {
        finalproducts = [];
      });
    } else {
      searchedproducts = [];
      value = value.substring(0, 1).toUpperCase() + value.substring(1);
      allproducts.forEach((document) {
        if (document['description'].substring(0, value.length) == value) {
          searchedproducts.add(document);
        }
      });
      setState(() {
        finalproducts = searchedproducts;
      });
    }
  }

// ignore: non_constant_identifier_names
  Widget Searched() {
    return finalproducts.length == 0
        ? Center(
            child: Text(
            'Hasil Pencarian',
            style: Constants.textstyle,
          ))
        : ListView(
            padding: EdgeInsets.symmetric(vertical: 100, horizontal: 24.0),
            children: [
                for (var i = 0; i < finalproducts.length; i++)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductPage(
                                    id: finalproducts[i].id,
                                  )));
                    },
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 12.0),
                        child: Row(children: [
                          Container(
                            width: 90,
                            height: 90,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                '${finalproducts[i]['images'][0]}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text(
                              '${finalproducts[i]['title']}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ])),
                  )
              ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Searched(),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: CustomInput(
              hinttext: 'Cari Brand Case',
              onChanged: (value) {
                search(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
