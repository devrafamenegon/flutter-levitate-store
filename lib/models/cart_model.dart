import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_levitate/datas/cart_product.dart';
import 'package:flutter_levitate/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  //usuário atual
  UserModel user;

  //lista com todos os prods do carrinho
  List<CartProduct> products = [];

  String couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  //quando criarmos o cart model, passaremos o user model, passando assim o usuário atual. Com isso, se caso o usuário atual mudar, o carrinho tbm muda
  CartModel(this.user){
    if(user.isLoggedIn())
    _loadCartItems();
  }

  //metodos estáticos são metodos da classe e não do objeto
  //quando quisermos ter acesso ao cart model de qualquer lugar do app, não será necessário o ScopedDescendant. Basta usar o "Ca  rtModel.of(context)"
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);

    //acessa a coleção users, pega o ID do usuario atual, e adiciona à coleção carrinho dele um mapa do produto
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").add(cartProduct.toMap()).then((doc){
      cartProduct.cid = doc.documentID; //depois q o produto foi adicionado ao firebase, assim recebendo um id unico, definimos este id do firebase ao ID do cart product
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).delete();

    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;

    //decrementando e atualizando a lista de produtos no carrinho do user
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;

    //somando e atualizando a lista de produtos no carrinho do user
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void _loadCartItems() async {
    //recuperando os produtos no carrinho do user
    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();

    //transformando cada produto do firebase e transformando num CartProduct e retornando uma lista com todos os CartProducts
    products = query.documents.map((doc)=> CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }

  void setCoupon( String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }
}