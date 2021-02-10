import 'package:flutter/material.dart';
import 'package:flutter_levitate/datas/product_data.dart';

class ProductScreen extends StatefulWidget {

  ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductData product;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
