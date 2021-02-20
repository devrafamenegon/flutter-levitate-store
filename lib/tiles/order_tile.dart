import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {

  final String orderId;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          //usamos o .snapshots pois ele retorna em tempo real um stream, ja o .get retornaria um FutureBuilder
          stream: Firestore.instance.collection("orders").document(orderId).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {

              int status = snapshot.data["status"];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Código do pedido: ${snapshot.data.documentID}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    _buildProductsText(snapshot.data)
                  ),
                  SizedBox(height: 8.0,),
                  Text("Status do pedido:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCircle("1", "Preparação", status, 1),
                      _buildLine(),
                      _buildCircle("2", "Transporte", status, 2),
                      _buildLine(),
                      _buildCircle("3", "Entrega", status, 3),
                    ],
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot){
    String text = "Descrição:\n";
    for(LinkedHashMap p in snapshot.data["products"]){
      text += "${p["quantity"]} x ${p["product"]["title"]} (R\$ ${p["product"]["price"].toStringAsFixed(2)})\n";
    }
    text += "Total: R\$ ${snapshot.data["totalPrice"].toStringAsFixed(2)}";
    return text;
  }

  Widget _buildCircle(String title, String subtitle, int status, int thisStatus){

    Color backColor;
    Widget child;

    if(status < thisStatus){
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white),);
    } else if (status == thisStatus){
      backColor = Color.fromARGB(255, 52, 73, 85);
      child = Stack(
        alignment: Alignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.white),),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Color.fromARGB(255, 249, 170, 51);
      child = Icon(Icons.check, color: Colors.white,);
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }

  Widget _buildLine(){
    return Container(
      height: 1.0,
      width: 40.0,
      color: Colors.grey[500],
    );
  }
}
