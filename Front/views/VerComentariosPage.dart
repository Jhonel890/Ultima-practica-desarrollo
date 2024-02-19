import 'package:flutter/material.dart';
import 'package:flutter_noticias/controls/serviciosBack/FacadeService.dart';
import 'package:flutter_noticias/controls/serviciosBack/RespuestaGenerica.dart';

class VerComentariosPage extends StatefulWidget {
  @override
  _VerComentariosState createState() => _VerComentariosState();
}

class _VerComentariosState extends State<VerComentariosPage> {
  List<Map<String, dynamic>> comentarios = [];
  bool isLoading = true;
  int limit = 10; // Número de comentarios por página
  int page = 1; // Número de página actual

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cargarComentarios();
  }

  Future<void> cargarComentarios() async {
    try {
      final Map<String, dynamic>? arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      if (arguments == null) {
        return;
      }

      final String externalId = arguments['external_id'] ?? '';
      FacadeService servicio = FacadeService();
      RespuestaGenerica value = await servicio.getComentarios(
        externalId,
        limit: limit,
        page: page,
      );

      if (value.code == 200) {
        setState(() {
          comentarios = List<Map<String, dynamic>>.from(value.datos);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error ${value.code}')),
        );
      }
    } catch (error) {
      print("Error al obtener comentarios: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (arguments == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: const Text('Error: Argumentos nulos'),
        ),
      );
    }

    final String titulo = arguments['titulo'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Volver"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          comentarios.isEmpty
              ? Center(
                  child: const Text(
                    'No hay comentarios.',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: comentarios.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: ListTile(
                          title: Text(
                            comentarios[index]['cuerpo'],
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          subtitle: Text(
                            comentarios[index]['fecha'] +
                                ' - ' +
                                comentarios[index]['usuario'] +
                                ' - ' +
                                comentarios[index]['hora'],
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (page > 1) {
                    setState(() {
                      page--;
                    });
                    cargarComentarios();
                  }
                },
              ),
              Text('Página $page'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  if (comentarios.length == limit) {
                    setState(() {
                      page++;
                    });
                    cargarComentarios();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
