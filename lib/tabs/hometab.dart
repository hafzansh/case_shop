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
                  return StaggeredGridView.count(
                      crossAxisCount: 4,
                      padding: EdgeInsets.only(top: 110.0, bottom: 24.0),
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
                      crossAxisSpacing: 1.0);
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
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
