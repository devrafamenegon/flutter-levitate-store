import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_levitate/datas/cart_product.dart';
import 'package:flutter_levitate/datas/product_data.dart';
import 'package:flutter_levitate/models/cart_model.dart';

class CartTile extends StatelessWidget {

  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(cartProduct.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cartProduct.productData.title,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                    ),
                    Text("Tamanho: ${cartProduct.size}",
                    style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Text("R\$ ${cartProduct.productData.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            icon: Icon(Icons.remove),
                            color: Color.fromARGB(255, 249, 170, 51),
                            onPressed: cartProduct.quantity > 1 ?
                            (){
                              CartModel.of(context).decProduct(cartProduct);
                            } : null,
                        ),
                        Text(cartProduct.quantity.toString()),
                        IconButton(
                          icon: Icon(Icons.add),
                          color: Color.fromARGB(255, 249, 170, 51),
                          onPressed: (){
                            CartModel.of(context).incProduct(cartProduct);
                          },
                        ),
                        FlatButton(
                          child: Text("Remover"),
                          textColor: Colors.grey[500],
                          onPressed: (){
                            CartModel.of(context).removeCartItem(cartProduct);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
          ),
        ],
      );
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
