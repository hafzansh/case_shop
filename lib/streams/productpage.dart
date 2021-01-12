import 'package:poggers/constants.dart';
import 'package:poggers/services/firebase_services.dart';
import 'package:poggers/widgets/capacity_btns.dart';
import 'package:poggers/widgets/custom_actionbar.dart';
import 'package:poggers/widgets/imageswipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ProductPage extends StatefulWidget {
  final String id;
  ProductPage({this.id});
  @override
  _ProductPageState createState() => _ProductPageState();
}

final fc = new NumberFormat("Rp #,##0", "en_US");

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  List savedproducts;
  int productprice;

  int z = 0; //is saved flag variable

  String _selectedproductcapacity = '0.5';

  final SnackBar _snackBar = SnackBar(
      content: Text('Product added to the cart'),
      backgroundColor: Colors.blueGrey);
  final SnackBar _savedsnackBar = SnackBar(
      content: Text('Product saved'), backgroundColor: Colors.blueGrey);

  Future addtocart() {
    return _firebaseServices.userref
        .doc(_firebaseServices.getuserid())
        .collection('Cart')
        .doc(widget.id)
        .set({'size': _selectedproductcapacity, 'price': productprice});
  }

  Future addtosaved() {
    return _firebaseServices.userref
        .doc(_firebaseServices.getuserid())
        .collection('Saved')
        .doc(widget.id)
        .set({'id': widget.id});
  }

  bool issaved() {
    savedproducts.forEach((document) {
      if (document.id == widget.id) {
        z = 1;
        return;
      }
    });
    return z == 1 ? true : false;
  }

  @override
  void initState() {
    _firebaseServices.userref
        .doc(_firebaseServices.getuserid())
        .collection('Saved')
        .get()
        .then((data) {
      savedproducts = data.docs;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        FutureBuilder(
          future: _firebaseServices.productref.doc(widget.id).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text(snapshot.error.toString()),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> documentdetails = snapshot.data.data();
              List imagelist = documentdetails['images'];
              List capacitylist = documentdetails['capacity'];
              productprice = documentdetails['price'];
              return ListView(
                children: [
                  ImageSwipe(
                    imagelist: imagelist,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 5.0),
                    child: Text(
                      '${documentdetails['title']}' ?? 'Product Name',
                      style: Constants.boldheadingProduct,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 5.0),
                    child: Text(
                      '${fc.format(documentdetails['price'])}' ?? 'price',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 8.0),
                    child: Text(
                      '${documentdetails['description']}' ?? 'Description',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    child: Text(
                      'Select Phone Type',
                      style: Constants.textstyle,
                    ),
                  ),
                  CapacityButtons(
                    capacitylist: capacitylist,
                    selectedcapacity: (capacity) {
                      _selectedproductcapacity = capacity;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            addtosaved();
                            Scaffold.of(context).showSnackBar(_savedsnackBar);
                            setState(() {
                              z = 1;
                            });
                          },
                          child: Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                  color: Color(0xffDCDCDC),
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Icon(
                                Icons.favorite,
                                size: 40,
                                color: issaved()
                                    ? Theme.of(context).accentColor
                                    : Colors.black,
                              )),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await addtocart();
                              Scaffold.of(context).showSnackBar(_snackBar);
                            },
                            child: Container(
                                margin: EdgeInsets.only(left: 16.0),
                                height: 65.0,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius: BorderRadius.circular(12.0)),
                                alignment: Alignment.center,
                                child: Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                )),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        CustomActionBar(
          title: 'detail',
          hasbackarrow: true,
          hastitle: false,
          hasbackground: false,
        )
      ],
    ));
  }
}
