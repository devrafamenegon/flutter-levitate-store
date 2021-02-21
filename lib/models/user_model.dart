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

  //metodos estáticos são metodos da classe e não do objeto
  //quando quisermos ter acesso ao user model de qualquer lugar do app, não será necessário o ScopedDescendant. Basta usar o "UserModel.of(context)"
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  //carregar o usuário(caso esteja logado) quando se abre o app.
  @override
  void addListener(listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}){

    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
    email: userData['email'],
    password: pass
    ).then((authResult) async {
      firebaseUser = authResult.user;

      await _saveUserData(userData);

      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn({@required String email, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail}) async{
    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(email: email, password: pass).then(
        (AuthResult) async {
          firebaseUser = AuthResult.user;

          await _loadCurrentUser();

          onSuccess();
          isLoading = false;
          notifyListeners();
        }).catchError((e){
          onFail();
          isLoading = false;
          notifyListeners();
    });

    isLoading = false;
    notifyListeners();
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn(){
    return firebaseUser != null;
  }

  /*bool isLoggedIn(){

  }*/
   Future<Null> _saveUserData(Map<String,dynamic> userData) async {
     this.userData = userData;
     await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
   }

   Future<Null> _loadCurrentUser() async {
     if(firebaseUser == null)
       firebaseUser = await _auth.currentUser();
     if(firebaseUser != null){
       if(userData["name"] == null){
         DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
         userData = docUser.data;
       }
     }
     notifyListeners();
   }
}

