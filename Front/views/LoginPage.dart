import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_noticias/controls/serviciosBack/FacadeService.dart';
import 'package:flutter_noticias/controls/utiles/Utiles.dart';
import 'package:validators/validators.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyLoginPage> createState() => _SesionViewState();
}

class _SesionViewState extends State<MyLoginPage> {
  Utiles util = Utiles();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    util.removeAll();
    util.getValue('token').then((value) {
      log('Token: $value');
    });
    util.getValue('user').then((value) {
      log('User: $value');
    });
    util.getValue('external_id').then((value) {
      log('External ID: $value');
    });
  }

  void _iniciar() {
    if (_formKey.currentState!.validate()) {
      FacadeService servicio = FacadeService();
      Map<String, String> mapa = {
        "correo": correoControl.text,
        "clave": claveControl.text
      };

      servicio.inicioSesion(mapa).then((value) async {
        log('Map values:');
        value.datos.forEach((key, value) {
          log('$key: $value');
        });

        if (value.code == 400) {
          final SnackBar msg =
              SnackBar(content: Text("Usuario o clave incorrecta"));
          ScaffoldMessenger.of(context).showSnackBar(msg);
        }

        if (value.code == 200) {
          Utiles util = Utiles();
          util.saveValue('token', value.datos['token']);
          util.saveValue('user', value.datos['user']);
          util.saveValue('external_id', value.datos['external_id']);
          final SnackBar msg = SnackBar(
            content: Text('Bienvenido ${value.datos['user']}'),
          );
          ScaffoldMessenger.of(context).showSnackBar(msg);
          log('User: ${value.datos['user']}');

          if (value.datos['rol'] == 'administrador') {
            Navigator.pushNamed(context, '/comentarios');
          } else {
            Navigator.pushNamed(context, '/listado');
          }
        } else if (value.code == 401) {
          final SnackBar msg =
              SnackBar(content: Text("La cuenta está desactivada"));
          ScaffoldMessenger.of(context).showSnackBar(msg);
        } else {
          final SnackBar msg = SnackBar(content: Text('Error ${value.code}'));
          ScaffoldMessenger.of(context).showSnackBar(msg);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Noticias Nuevas",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "La mejor app de noticias",
                style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Inicio de sesión",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: correoControl,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar su correo";
                  }
                  if (!isEmail(value)) {
                    return "Debe ser un correo válido";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  suffixIcon: Icon(Icons.alternate_email),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                obscureText: true,
                controller: claveControl,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar una clave";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Clave',
                  suffixIcon: Icon(Icons.key),
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: _iniciar,
                child: const Text('Inicio'),
              ),
            ),
            Row(
              children: <Widget>[
                const Text('No tienes una cuenta'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
