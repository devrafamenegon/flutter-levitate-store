import 'package:flutter/material.dart';
import 'package:flutter_levitate/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {

    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 52, 73, 85), //cinza
                Color.fromARGB(255, 35, 47, 52), //amarelo

                // Color.fromARGB(255, 203, 236, 241),
                // Colors.white;
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
    );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0, right: 32.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 200.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 24.0,
                      left: 0.0,
                      child: Text("Levitate's\nStore", style: TextStyle(color: Colors.white, fontSize: 34.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Olá",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold
                            ),
                          ),
                          GestureDetector(
                            child: Text("Entre ou cadastre-se >",
                              style: TextStyle(
                                color: Color.fromARGB(255, 249, 170, 51),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {

                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Color.fromARGB(255, 74, 101, 114)),
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(Icons.list, "Produtos", pageController, 1),
              DrawerTile(Icons.location_on, "Lojas", pageController, 2),
              DrawerTile(Icons.playlist_add_check, "Meus Pedidos", pageController, 3),
            ],
          )
        ],
      ),
    );
  }
}
