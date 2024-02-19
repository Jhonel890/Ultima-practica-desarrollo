import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Mi informativo favorito'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Mi perfil'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/verPerfil');
            },
          ),
          ListTile(
            leading: Icon(Icons.newspaper),
            title: Text('Noticias'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/listado');
            },
          ),
          ListTile(
            leading: Icon(Icons.comment),
            title: Text('Modificar mis comentarios'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/verMisComentarios');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          // Agrega más elementos aquí
        ],
      ),
    );
  }
}
