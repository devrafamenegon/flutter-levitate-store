import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class UserModel extends Model {

  //atalho para n precisar escrever sempre "FirebaseAuth.instance"
  FirebaseAuth _auth = FirebaseAuth.instance;

  //usuário logado no momento, caso n tenha, ele retorna null
  FirebaseUser firebaseUser;

  //Email, nome e endereço
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  void signUp({@required Map<String, dynamic> userData, @required String pass, @required VoidCallback onSucess, @required VoidCallback onFail}){
    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
    email: userData["email"],
    password: pass
    ).then((user) async {
      firebaseUser = user;

      await _saveUserData(userData);

      onSucess();
      notifyListeners();
    }).catchError((e){
      onFail();
      isLoading = false;

    });
  }

  void signIn() async{
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
  }

  void recoverPass(){
    signUp(userData: null, pass: null, onSucess: null, onFail: null);
  }

  /*bool isLoggedIn(){

  }*/
   Future<Null> _saveUserData(Map<String,dynamic> userData) async {
     this.userData = userData;
     await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
   }
}

