import 'package:flutter/material.dart';

class MenuAdmin extends StatelessWidget {
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
            leading: Icon(Icons.comment),
            title: Text('Comentarios'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/comentarios');
            },
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Mapa'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/mapa');
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
