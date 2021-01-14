import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poggers/widgets/custom_actionbar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:poggers/phone.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:firebase_database/firebase_database.dart' as rt;
import 'package:cached_network_image/cached_network_image.dart';

final databaseReference = rt.FirebaseDatabase.instance.reference();
final makecall = new MakeCall();

class PhoneList {
  List<PhoneListItem> phoneList;
  PhoneList({this.phoneList});

  factory PhoneList.fromJSON(Map<dynamic, dynamic> json) {
    return PhoneList(phoneList: parsephones(json));
  }

  static List<PhoneListItem> parsephones(recipeJSON) {
    var rList = recipeJSON['phone'] as List;
    List<PhoneListItem> phoneList =
        rList.map((data) => PhoneListItem.fromJson(data)).toList(); //Add this
    return phoneList;
  }
}

class MakeCall {
  List<PhoneListItem> listItems = [];

  Future<List<PhoneListItem>> firebaseCalls(
      rt.DatabaseReference databaseReference) async {
    listItems.clear();
    PhoneList phoneList;
    rt.DataSnapshot dataSnapshot = await databaseReference.once();
    Map<dynamic, dynamic> jsonResponse = dataSnapshot.value['data'];

    phoneList = new PhoneList.fromJSON(jsonResponse);
    listItems.addAll(phoneList.phoneList);
    listItems.sort((a, b) {
      return a.vendor.toLowerCase().compareTo(b.vendor.toLowerCase());
    });
    return listItems;
  }
}

class DesignTab extends StatefulWidget {
  @override
  _DesignTab createState() => _DesignTab();
}

class _DesignTab extends State<DesignTab> with AutomaticKeepAliveClientMixin {
  PanelController _panel = new PanelController();
  final Query collectionref = FirebaseFirestore.instance
      .collection('products')
      .orderBy('createdAt', descending: true);
  File _image;
  String _model = "Iphone 11 Pro";
  String _cover = "kek";
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile.path == null) {
      setState(() {});
      return null;
    } else {
      _cropImage(pickedFile.path);
    }
  }

  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath,
        aspectRatio: CropAspectRatio(ratioX: 9.0, ratioY: 19.0));
    if (croppedImage != null) {
      _image = croppedImage;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: makecall.firebaseCalls(databaseReference), // async work
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        super.build(context);
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('Press button to start');
          case ConnectionState.waiting:
            return new Text("");
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      elevation: 0.0,
                      child: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: InkWell(
                            onTap: () async {
                              print(snapshot.data[index].model);
                              _panel.close();
                              _model = snapshot.data[index].model;
                              _cover = snapshot.data[index].cover;
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 6),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                '${snapshot.data[index].vendor}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                ' ${snapshot.data[index].model}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  );
                },
              );
            }
        }
      },
    );
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          SlidingUpPanel(
            maxHeight: 217,
            minHeight: 80,
            controller: _panel,
            parallaxEnabled: true,
            backdropTapClosesPanel: true,
            parallaxOffset: .3,
            panel: Container(
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20.0,
                      color: Colors.grey,
                    ),
                  ]),
              child: Center(
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: _model == "Iphone 11"
                                ? Text("Iphone 11 Pro",
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white))
                                : Text(_model,
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white)),
                          )),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: RaisedButton(
                              onPressed: () async {
                                setState(() {
                                  _image = null;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.blueGrey)),
                              color: Colors.grey[350],
                              textColor: Colors.blueGrey,
                              child: Icon(Icons.autorenew)),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: RaisedButton(
                              onPressed: () {
                                showToastWidget(Container(
                                    width: 380,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.9),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text('Data Disimpan',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                    )));
                                setState(() {
                                  _image = null;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.blueGrey)),
                              color: Colors.white,
                              textColor: Colors.blueGrey,
                              child: Text("Simpan".toUpperCase(),
                                  style: TextStyle(fontSize: 16))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Expanded(child: futureBuilder),
                ]),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                  top: 100.0, left: 20, right: 20, bottom: 150),
              child: new Stack(children: <Widget>[
                new SizedBox.expand(
                    child: Center(
                  child: Container(
                    child: _image == null
                        ? Text('Pilih Gambar')
                        : Image.file(_image),
                  ),
                )),
                new Positioned(
                    child: new GestureDetector(
                        onTap: () {
                          getImage();
                        }, // handle your image tap here
                        child: Center(
                          child: new CachedNetworkImage(
                              imageUrl: _cover == "kek"
                                  ? "https://firebasestorage.googleapis.com/v0/b/shop-app-847a9.appspot.com/o/images%2Fphone%2Fip11.png?alt=media&token=0726b23b-49ee-419b-8ab0-548dff450bbd"
                                  : _cover,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )),
                        )))
              ]),
            ),
          ),
          CustomActionBar(
            title: 'Design',
            hasbackarrow: false,
            hastitle: true,
          ),
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;
}
