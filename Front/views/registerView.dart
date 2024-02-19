import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_noticias/controls/serviciosBack/FacadeService.dart';
import 'package:flutter_noticias/controls/utiles/Utiles.dart';
import 'package:validators/validators.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombresC = TextEditingController();
  final TextEditingController apellidosC = TextEditingController();
  final TextEditingController correoC = TextEditingController();
  final TextEditingController claveC = TextEditingController();

  void _registrarUsuario() {
    FacadeService servicio = FacadeService();
    if (_formKey.currentState!.validate()) {
      Map<String, String> mapa = {
        "nombres": nombresC.text,
        "apellidos": apellidosC.text,
        "correo": correoC.text,
        "clave": claveC.text
      };
      servicio.registro(mapa).then((value) async {
        log('Map values:');
        value.datos.forEach((key, value) {
          log('$key: $value');
        });

        if (value.code == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario registrado')),
          );
          Navigator.pushNamed(context, '/home');
        } else {
          if (value.code == 400) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("La cuenta ya existe")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error ${value.code}')),
            );
          }
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
          children: <Widget>[
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
                "Registro de usuario",
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
                controller: nombresC,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar su nombre";
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: apellidosC,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar su apellido";
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: correoC,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  suffixIcon: Icon(Icons.alternate_email),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar su correo";
                  }
                  if (!isEmail(value)) {
                    return "Debe ser un correo válido";
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: claveC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar una clave";
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Clave',
                  suffixIcon: Icon(Icons.key),
                ),
                obscureText: true,
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: _registrarUsuario,
                child: const Text('Registrarse'),
              ),
            ),
            Row(
              children: <Widget>[
                const Text('Ya tiene una cuenta'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'Inicio Sesión',
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
