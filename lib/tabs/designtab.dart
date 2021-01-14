import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poggers/widgets/custom_actionbar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DesignTab extends StatefulWidget {
  @override
  _DesignTab createState() => _DesignTab();
}

class _DesignTab extends State<DesignTab> {
  final Query collectionref = FirebaseFirestore.instance
      .collection('products')
      .orderBy('createdAt', descending: true);
  File _image;
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
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          SlidingUpPanel(
            maxHeight: 300,
            minHeight: 70,
            parallaxEnabled: true,
            parallaxOffset: .5,
            panel: Material(
              elevation: 10,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    )),
                height: 30,
                child: Row(
                  children: [
                    Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text('Iphone 12 Pro',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white)),
                        )),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: RaisedButton(
                            onPressed: () async {
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
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                  top: 100.0, left: 20, right: 20, bottom: 50),
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
                          child: new Container(
                              decoration: new BoxDecoration(
                                  image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new ExactAssetImage(
                                'assets/images/apple/mockup-iphone11pro-transparent.png'),
                          ))),
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
}
