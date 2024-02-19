import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_noticias/controls/serviciosBack/RespuestaGenerica.dart';
import 'package:flutter_noticias/controls/serviciosBack/FacadeService.dart';
import 'package:flutter_noticias/controls/utiles/Utiles.dart';
import 'package:geolocator/geolocator.dart';

class ModificarComentario extends StatefulWidget {
  @override
  _ModificarComentarioState createState() => _ModificarComentarioState();
}

class _ModificarComentarioState extends State<ModificarComentario> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> comentarios = [];
  final TextEditingController comentarioC = TextEditingController();
  bool isLoading = true;
  double? _userLatitude;
  double? _userLongitude;

  @override
  void initState() {
    super.initState();
    _cargarComentariosPersona();
    _obtenerUbicacionUsuario();
  }

  ScaffoldMessengerState get _scaffoldMessenger =>
      ScaffoldMessenger.of(context);

  Future<void> _cargarComentariosPersona() async {
    Utiles util = Utiles();
    String? externalId = 'external_id';
    util.getValue(externalId).then((value) {
      log('External ID: $value');

      if (value != null) {
        FacadeService servicio = FacadeService();
        servicio.getComentariosPersona(value).then((value) {
          if (value.code == 200) {
            setState(() {
              comentarios = List<Map<String, dynamic>>.from(value.datos);
            });
          } else {
            _scaffoldMessenger.showSnackBar(
              SnackBar(content: Text('Error ${value.code}')),
            );
          }
        });
      }
    });
  }

  Future<void> _obtenerUbicacionUsuario() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userLatitude = position.latitude;
        _userLongitude = position.longitude;
      });
    } catch (e) {
      log("Error al obtener la ubicación del usuario: $e");
    }
  }

  Future<void> _modificarComentario(
      String nuevoTexto, String externalId) async {
    try {
      setState(() {
        isLoading = true;
      });

      FacadeService servicio = FacadeService();

      // Crea un mapa con el nuevo texto, la ubicación del usuario y el external id del comentario
      Map<String, String> mapa = {
        "cuerpo": nuevoTexto,
        "fecha": DateTime.now().toString(),
        "latitud": _userLatitude?.toString() ?? "0.0",
        "longitud": _userLongitude?.toString() ?? "0.0",
        "comentario": externalId,
      };

      RespuestaGenerica value = await servicio.modificarComentario(mapa);

      if (value.code == 200) {
        // Realiza acciones después de una modificación exitosa
        // Puedes agregar lógica adicional aquí si es necesario.

        // Actualiza la vista volviendo a cargar los comentarios
        _cargarComentariosPersona();

        // Muestra un mensaje de éxito
        _scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Comentario modificado con éxito')),
        );
      } else {
        // Maneja el caso en que la modificación no fue exitosa
        // Puedes mostrar un mensaje de error o realizar otras acciones.

        // Muestra un mensaje de error
        _scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error al modificar el comentario')),
        );
      }
    } catch (error) {
      print("Error al modificar el comentario: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _mostrarModal(String comentario, String externalId) {
    TextEditingController comentarioController =
        TextEditingController(text: comentario);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Modificar Comentario',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: comentarioController,
                      maxLines: null,
                      onChanged: (newText) {
                        setState(() {
                          // Actualizar el estado cuando el texto cambia
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese un comentario';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _formKey.currentState?.validate() == true
                        ? () {
                            _modificarComentario(
                                comentarioController.text, externalId);
                            Navigator.pop(context); // Cerrar el modal
                          }
                        : null,
                    child: Text('Guardar cambios'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'Mis comentarios',
              style: TextStyle(fontSize: 24), // Estilo opcional para tu título
            ),
            comentarios.isEmpty
                ? Center(
                    child: Text('Usted no ha realizado comentarios'),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: comentarios.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _mostrarModal(
                                comentarios[index]['cuerpo'],
                                comentarios[index]['external_id']
                                    .toString()); // Obtén el external id del comentario
                          },
                          child: ListTile(
                            title: Text(
                              comentarios[index]['cuerpo'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(comentarios[index]['fecha'] +
                                "  Noticia: " +
                                comentarios[index]['noticia']['titulo']),
                          ),
                        );
                      },
                    ),
                  ),
            // Otros botones o widgets si los tienes
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/listado');
              },
              child: Text('Volver a la pantalla principal'),
            ),
          ],
        ),
      ),
    );
  }
}
