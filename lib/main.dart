import 'package:flutter/material.dart';
import 'package:flutter_levitate/models/cart_model.dart';
import 'package:flutter_levitate/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //O modelo do usuário vem acima do modelo do carrinho pois, o carrinho precisa saber qual o usuário atual, mas o usuário não precisa ter conhecimento sobre o que tem em nosso carrinho.
    return ScopedModel<UserModel>(
        model: UserModel(),
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model){ //sempre que o user atual mudar, a tela é reconstruída
            return ScopedModel<CartModel>(
            model: CartModel(model),//passando o user model para o cart model
            child: MaterialApp(
            title: 'Levitate Store',
            theme: ThemeData(
            primarySwatch: Colors.amber,
            primaryColor: Color.fromARGB(255, 52, 73, 85),
            // primaryColor: Color.fromARGB(255, 4, 125, 141),
            ),
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),),
            );
          },
        )
    );
  }
}

/*
  primary: 700 #344955 52, 73, 85
           800 #232F34 35, 47, 52
           600 #4A6572 74, 101, 114

  secondary: 500 #F9AA33 249, 170, 51
*/
