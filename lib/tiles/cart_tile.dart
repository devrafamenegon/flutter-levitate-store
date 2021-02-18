import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_levitate/datas/cart_product.dart';
import 'package:flutter_levitate/datas/product_data.dart';

class CartTile extends StatelessWidget {

  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){

    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      //caso não tenhamos os dados dos produtos, acessamos o firebase e salvamos estes dados para utilizar depois novamente
      child: cartProduct.productData == null ?
        FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection("products").document(cartProduct.category).collection("items").document(cartProduct.pid).get(),
          builder: (context, snapshot){
          if(snapshot.hasData) {
            //salvando os dados
            cartProduct.productData = ProductData.fromDocument(snapshot.data);
            //mostrandos os dados
            return _buildContent();
          } else {
            return Container(
              height: 70.0,
              child: CircularProgressIndicator(),
              alignment: Alignment.center,
            );
          }
        },
      ) : _buildContent()
    );
  }
}
