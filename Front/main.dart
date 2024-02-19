import 'package:flutter/material.dart';
import 'package:flutter_noticias/views/HomePage.dart';
import 'package:flutter_noticias/views/LoginPage.dart';
import 'package:flutter_noticias/views/PagePrueba.dart';
import 'package:flutter_noticias/views/PerfilPage.dart';
import 'package:flutter_noticias/views/addComentario.dart';
import 'package:flutter_noticias/views/VerComentariosPage.dart';
import 'package:flutter_noticias/views/exception/Page404.dart';
import 'package:flutter_noticias/views/mapa.dart';
import 'package:flutter_noticias/views/modificarComentario.dart';
import 'package:flutter_noticias/views/registerView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const HomePage(),
      initialRoute: '/home',
      routes: {
        '/listado': (context) => HomePage(),
        '/home': (context) => MyLoginPage(title: 'Login Page'),
        '/register': (context) => RegisterView(),
        '/addComentario': (context) => AddComentario(),
        '/verComentarios': (context) => VerComentariosPage(),
        // '/verMenu': (context) => PagePrueba(),
        '/verMisComentarios': (context) => ModificarComentario(),
        '/verPerfil': (context) => PerfilPage(),
        '/comentarios': (context) => ComentariosAdminPage(),
        '/mapa': (context) => MapaPage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Page404(),
        );
      },
    );
  }
}
