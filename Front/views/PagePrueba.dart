import 'package:flutter/material.dart';
import 'package:flutter_noticias/controls/serviciosBack/FacadeService.dart';
import 'package:flutter_noticias/controls/serviciosBack/RespuestaGenerica.dart';
import 'package:flutter_noticias/views/components/MenuAdmin.dart';
import 'package:flutter_noticias/views/components/menu.dart';

class ComentariosAdminPage extends StatefulWidget {
  @override
  _ComentariosAdminPageState createState() => _ComentariosAdminPageState();
}

class _ComentariosAdminPageState extends State<ComentariosAdminPage> {
  List<Map<String, dynamic>> comentarios = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarComentarios();
  }

  Future<void> cargarComentarios() async {
    try {
      FacadeService servicio = FacadeService();
      RespuestaGenerica value = await servicio.listarComentarios();

      if (value.code == 200) {
        setState(() {
          comentarios = List<Map<String, dynamic>>.from(value.datos);
        });

        print(comentarios.toString());
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

  Future<void> banearCuenta(String externalCuenta) async {
    try {
      FacadeService servicio = FacadeService();
      RespuestaGenerica value = await servicio.banearUsuario(externalCuenta);

      if (value.code == 200) {
        setState(() {
          comentarios = List<Map<String, dynamic>>.from(value.datos);
        });

        print(comentarios.toString());
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

  Future<void> desactivarComentarios(String externalPersona) async {
    try {
      FacadeService servicio = FacadeService();
      RespuestaGenerica value =
          await servicio.desactivarComentarios(externalPersona);

      if (value.code == 200) {
        setState(() {
          comentarios = List<Map<String, dynamic>>.from(value.datos);
        });

        print(comentarios.toString());
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

  void banearUsuario(int index) async {
    // Muestra un modal de confirmación
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Banear Usuario'),
          content: Text('¿Estás seguro de que deseas banear a este usuario?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el modal
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  print('Banear usuario');
                  // Obtiene el external de la cuenta y persona correspondiente
                  String externalCuenta =
                      comentarios[index]['persona']['cuenta']['external_id'];
                  String externalPersona =
                      comentarios[index]['persona']['external_id'];

                  print('External cuenta: $externalCuenta');
                  print('External persona: $externalPersona');

                  // Llama a la función para banear la cuenta
                  await banearCuenta(externalCuenta);
                  await desactivarComentarios(externalPersona);

                  // Actualiza la lista después de banear al usuario
                  cargarComentarios();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Usuario baneado')),
                  );

                  // Puedes realizar otras acciones aquí si es necesario

                  // Cierra el modal
                  Navigator.of(context).pop();
                } catch (error) {
                  print("Error al banear usuario: $error");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al banear usuario')),
                  );
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: Text('Banear'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios'),
      ),
      drawer: MenuAdmin(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: comentarios.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(comentarios[index]['cuerpo']),
                  subtitle: Text(comentarios[index]['usuario']),
                  trailing: Text(comentarios[index]['fecha']),

                  // Comprueba si el estado es verdadero o falso
                  // y establece el color en consecuencia
                  tileColor: comentarios[index]['estado'] == true
                      ? Colors.green
                      : Colors.red,
                  // Añade el botón "Banear Usuario"
                  onTap: () {
                    banearUsuario(index);
                  },
                );
              },
            ),
    );
  }
}
