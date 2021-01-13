import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:poggers/widgets/custom_actionbar.dart';
import 'package:poggers/widgets/home_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeTab extends StatelessWidget {
  final Query collectionref = FirebaseFirestore.instance
      .collection('products')
      .orderBy('createdAt', descending: true);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[150],
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(top: 100),
                  child: InkWell(
                    onTap: () {
                      print("kek");
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Design()));
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: AssetImage('assets/images/logo.png'),
                              fit: BoxFit.cover)),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(.2),
                                    Colors.black.withOpacity(.1)
                                  ])),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text("3Case",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(.6),
                                      fontSize: 85,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 60),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          colors: [
                                            Colors.white.withOpacity(.6),
                                            Colors.white.withOpacity(.9)
                                          ]),
                                      color: Colors.white.withOpacity(.9)),
                                  child: Center(
                                      child: Text("Buat Desainmu Sendiri",
                                          style: TextStyle(
                                              color: Colors.grey[900],
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)))),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
              FutureBuilder<QuerySnapshot>(
                  future: collectionref.get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Container(
                        child: Center(
                          child: Text(snapshot.error.toString()),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Expanded(
                        child: StaggeredGridView.count(
                            crossAxisCount: 4,
                            padding: EdgeInsets.only(top: 0.0, bottom: 24.0),
                            children: snapshot.data.docs.map((document) {
                              Map details = document.data();
                              return HomeProductCard(
                                productid: document.id,
                                title: details['title'],
                                price: details['price'].toString(),
                                imageurl: details['images'][0],
                              );
                            }).toList(),
                            staggeredTiles: snapshot.data.docs
                                .map<StaggeredTile>((_) => StaggeredTile.fit(2))
                                .toList(),
                            mainAxisSpacing: 1.0,
                            crossAxisSpacing: 1.0),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ],
          ),
          CustomActionBar(
            title: 'HOME',
            hasbackarrow: false,
            hastitle: true,
          ),
        ],
      ),
    );
  }
}
