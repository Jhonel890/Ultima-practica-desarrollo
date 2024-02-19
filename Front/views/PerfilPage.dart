import 'package:flutter/material.dart';
import 'package:flutter_noticias/controls/serviciosBack/FacadeService.dart';
import 'package:flutter_noticias/controls/serviciosBack/RespuestaGenerica.dart';
import 'package:flutter_noticias/views/components/menu.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<PerfilPage> {
  List<Map<String, dynamic>> perfil = [];
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    try {
      FacadeService servicio = FacadeService();
      RespuestaGenerica value = await servicio.obtenerPerfil();

      if (value.code == 200) {
        if (value.datos is Map<String, dynamic>) {
          setState(() {
            perfil = [value.datos];
            _nombreController.text = perfil[0]['nombres'];
            _apellidoController.text = perfil[0]['apellidos'];
          });

          print("Perfil obtenido exitosamente");
          print(perfil.toString());
        } else {
          print("Error: 'datos' no es un mapa");
        }
      } else {
        _mostrarSnackBarError(value.code);
        print("Error al obtener perfil: ${value.code}");
      }
    } catch (error) {
      print("Error al obtener perfil: $error");
      // Manejar la excepción de manera más específica si es posible
    }
  }

  void _mostrarSnackBarError(int errorCode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error $errorCode')),
    );
  }

  Future<void> _mostrarModalModificarNombreApellido() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modificar Nombre y Apellido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nuevo Nombre'),
              ),
              TextField(
                controller: _apellidoController,
                decoration: InputDecoration(labelText: 'Nuevo Apellido'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el modal
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _guardarCambiosNombreApellido();
                Navigator.of(context).pop(); // Cerrar el modal
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _guardarCambiosNombreApellido() async {
    String nuevoNombre = _nombreController.text;
    String nuevoApellido = _apellidoController.text;

    if (nuevoNombre != perfil[0]['nombres'] ||
        nuevoApellido != perfil[0]['apellidos']) {
      await _modificarPerfil(nuevoNombre, nuevoApellido);
    }
  }

  Future<void> _modificarPerfil(
      String nombreNuevo, String apellidoNuevo) async {
    try {
      Map<String, String> mapa = {
        'nombres': nombreNuevo,
        'apellidos': apellidoNuevo,
      };
      FacadeService servicio = FacadeService();
      RespuestaGenerica value = await servicio.modificarPerfil(mapa);

      if (value.code == 200) {
        print("Perfil modificado exitosamente");

        setState(() {
          perfil[0]['nombres'] = nombreNuevo;
          perfil[0]['apellidos'] = apellidoNuevo;
        });
      } else {
        _mostrarSnackBarError(value.code);
        print("Error al modificar perfil: ${value.code}");
      }
    } catch (error) {
      print("Error al modificar perfil: $error");
      // Manejar la excepción de manera más específica si es posible
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      drawer: Menu(),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(
                  'https://example.com/path/to/profile_image.jpg',
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '${perfil.isNotEmpty ? perfil[0]['nombres'] + ' ' + perfil[0]['apellidos'] : ''}',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                'Correo: ${perfil.isNotEmpty ? perfil[0]['cuenta']['correo'] : ''}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _mostrarModalModificarNombreApellido();
                },
                child: Text('Modificar Nombre y Apellido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
