import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_levitate/datas/cart_product.dart';
import 'package:flutter_levitate/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  //usuário atual
  UserModel user;

  //lista com todos os prods do carrinho
  List<CartProduct> products = [];

  //quando criarmos o cart model, passaremos o user model, passando assim o usuário atual. Com isso, se caso o usuário atual mudar, o carrinho tbm muda
  CartModel(this.user);

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

}