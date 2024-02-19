import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_noticias/controls/serviciosBack/FacadeService.dart';
import 'package:flutter_noticias/controls/serviciosBack/RespuestaGenerica.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_tiles_map/simple_tiles_map.dart';
import 'package:geolocator/geolocator.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({Key? key}) : super(key: key);

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  List<String> comentariosList = []; // Lista para almacenar comentarios
  List<Marker> markers = [];
  late LatLng _currentPosition; // Variable para almacenar la posición actual

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(-3.903094, -78.812092); // la por defecto :(
    _getCurrentLocation(); // obtener posición actual
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      verComentarios();
    } catch (error) {
      print("Error al obtener la posición actual: $error");
    }
  }

  Future<void> verComentarios() async {
    try {
      FacadeService servicio = FacadeService();
      RespuestaGenerica value = await servicio.listarComentarios();

      if (value.code == 200) {
        var comentariosAPI = List<Map<String, dynamic>>.from(value.datos);
        List<String> nuevosComentariosList = [];

        for (var comentario in comentariosAPI) {
          nuevosComentariosList.add(
              comentario['cuerpo'] ?? ''); // Acceder al texto del comentario
        }

        setState(() {
          comentariosList =
              nuevosComentariosList; // Actualizar la lista de comentarios
        });
      } else {
        final SnackBar msg = SnackBar(content: Text(value.msg.toString()));
        ScaffoldMessenger.of(context).showSnackBar(msg);
      }
    } catch (error) {
      print("Error al obtener comentarios: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mostrar lista de comentarios
          comentariosList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: comentariosList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(comentariosList[index]),
                      );
                    },
                  ),
                )
              : Container(),
          // Mostrar mapa con marcadores
          Expanded(
            child: SimpleTilesMap(
              typeMap: TypeMap.esriStreets,
              mapOptions: MapOptions(
                initialCenter: _currentPosition,
                initialZoom: 13.0,
              ),
              otherLayers: [
                MarkerLayer(
                  markers: markers,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
