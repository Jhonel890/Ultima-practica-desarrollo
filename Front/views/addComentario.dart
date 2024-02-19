import 'package:flutter/material.dart';
import 'package:flutter_noticias/views/components/menu.dart';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_noticias/controls/serviciosBack/FacadeService.dart';
import 'package:flutter_noticias/controls/utiles/Utiles.dart';

class AddComentario extends StatefulWidget {
  @override
  _AddComentarioState createState() => _AddComentarioState();
}

class _AddComentarioState extends State<AddComentario> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController comentarioC = TextEditingController();

  @override
  void dispose() {
    comentarioC.dispose();
    super.dispose();
  }

  void _enviarComentario(String externalId) async {
    FacadeService servicio = FacadeService();
    Utiles utiles = Utiles();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String? externalIdusuario = 'external_id';
    utiles.getValue(externalIdusuario).then((value) {
      log('External ID: $value');

      if (_formkey.currentState!.validate()) {
        Map<String, String> mapa = {
          "cuerpo": comentarioC.text,
          "fecha": DateTime.now().toString(),
          "usuario": value.toString(),
          "longitud": position.longitude.toString(),
          "latitud": position.latitude.toString(),
          "noticia": externalId,
        };

        servicio.addComentario(mapa).then((value) async {
          if (value.code == 200) {
            final SnackBar msg = SnackBar(content: Text('Comentario agregado'));
            ScaffoldMessenger.of(context).showSnackBar(msg);
          } else {
            final SnackBar msg = SnackBar(content: Text('Error ${value.code}'));
            ScaffoldMessenger.of(context).showSnackBar(msg);
          }
        });

        print('OKEY');
        Navigator.pushNamed(context, '/listado');
      } else {
        print('ERROR');
      }
    });
  }

  void _cancelar() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (arguments == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error: Argumentos nulos'),
        ),
      );
    }

    final String externalId = arguments['external_id'] ?? '';
    // final String texto = arguments['texto'] ?? '';
    final String titulo = arguments['titulo'] ?? '';
    // final String fecha = arguments['fecha'] ?? '';

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Volver'),
      // ),
      // drawer: Menu(), // Añade el menú aquí
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text('External ID: $externalId'),
              // Text('Texto: $texto'),

              Text('$titulo'),
              // Text('Fecha: $fecha'),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: comentarioC,
                  decoration: InputDecoration(
                    labelText: 'Tu comentario aquí...',
                    border: InputBorder.none,
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un comentario válido';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _enviarComentario(externalId),
                      child: Text('Enviar Comentario'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _cancelar,
                      child: Text('Cancelar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
