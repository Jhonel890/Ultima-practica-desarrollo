import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_noticias/controls/serviciosBack/FacadeService.dart';
import 'package:flutter_noticias/controls/serviciosBack/RespuestaGenerica.dart';
import 'package:flutter_noticias/views/components/menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> noticias = [];
  String user = ''; // Declarar la variable 'user' aquí
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarNoticias();
  }

  Future<void> cargarNoticias() async {
    try {
      FacadeService servicio = FacadeService();
      RespuestaGenerica value = await servicio.getNoticias();

      if (value.code == 200) {
        setState(() {
          noticias = List<Map<String, dynamic>>.from(value.datos);
        });

        log(noticias.toString());
      } else {
        final SnackBar msg = SnackBar(content: Text('Error ${value.code}'));
        ScaffoldMessenger.of(context).showSnackBar(msg);
      }
    } catch (error) {
      print("Error al obtener noticias: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _mostrarDetalleNoticia(Map<String, dynamic> noticia) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  noticia['titulo'],
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  noticia['texto'],
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _truncateText(String text, int maxLength) {
    return text.length <= maxLength
        ? text
        : '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ultimas noticias'),
      ),
      drawer: Menu(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(noticias[index]['titulo']),
                    subtitle: Text(
                      _truncateText(noticias[index]['texto'], 100),
                    ),
                    onTap: () {
                      _mostrarDetalleNoticia(noticias[index]);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_comment),
                          onPressed: () {
                            Navigator.pushNamed(context, '/addComentario',
                                arguments: noticias[index]);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.comment),
                          onPressed: () {
                            Navigator.pushNamed(context, '/verComentarios',
                                arguments: noticias[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
