import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_levitate/datas/product_data.dart';
import 'package:flutter_levitate/tiles/product_tile.dart';

//Esta tela recebe a categoria que estamos navegando, buscando cada produto chamando o snapshot que contém cada produto
class CategoryScreen extends StatelessWidget {

  final DocumentSnapshot snapshot; //indica qual categoria é
  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data["title"]),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.list),
                )
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("products")
                .document(snapshot.documentID)
                .collection("items")
                .getDocuments(),

            //este snapshot indica cada documento(produto) da categoria
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    GridView.builder(
                      padding: EdgeInsets.all(4.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {

                        //pega os dados de cada produto a partir do index
                        ProductData data = ProductData.fromDocument(snapshot.data.documents[index]);
                        //salvando a categoria do produto vinda do firebase em nosso próprio produto
                        data.category = this.snapshot.documentID;

                        //retorna o produto à tela
                        return ProductTile("grid", data);
                      },
                    ),
                    ListView.builder(
                      padding: EdgeInsets.all(4.0),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {

                        //pega os dados de cada produto a partir do index
                        ProductData data = ProductData.fromDocument(snapshot.data.documents[index]);
                        //salvando a categoria do produto vinda do firebase em nosso próprio produto
                        data.category = this.snapshot.documentID;

                        //retorna o produto à tela
                        return ProductTile("list", data);
                      },
                    ),
                  ],
                );
            },
          )),
    );
  }
}
