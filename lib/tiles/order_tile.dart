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
          stream: Firestore.instance.collection("order").document(orderId).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  Text("Código do pedido: ${snapshot.data.documentID}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
