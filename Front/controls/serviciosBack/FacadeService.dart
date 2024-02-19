import 'dart:convert';
import 'dart:developer';

import 'package:flutter_noticias/controls/Conexion.dart';
import 'package:flutter_noticias/controls/serviciosBack/RespuestaGenerica.dart';
import 'package:flutter_noticias/controls/serviciosBack/modelo/InicioSesionSW.dart';
import 'package:flutter_noticias/controls/utiles/Utiles.dart';

import 'package:http/http.dart' as http;

// no se llama a conexion, se encapsula datos sensibles
class FacadeService {
  Conexion c = Conexion();
  Future<InicioSesionSW> inicioSesion(Map<String, String> mapa) async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final String _url = '${c.URL}login';
    final uri = Uri.parse(_url);
    InicioSesionSW isw = InicioSesionSW();
    try {
      final response =
          await http.post(uri, headers: _header, body: jsonEncode(mapa));

      if (response.statusCode != 200) {
        if (response.statusCode == 400) {
          isw.code = 400;
          isw.msg = "Error";
          isw.tag = "Usuario o clave incorrecta";
          isw.datos = {};
        } else if (response.statusCode == 401) {
          isw.code = 401;
          isw.msg = "Error";
          isw.tag = "Cuenta desactivada";
          isw.datos = {};
        } else if (response.statusCode == 404) {
          isw.code = 404;
          isw.msg = "Error";
          isw.tag = "Recurso no encontrado";
          isw.datos = {};
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          isw.code = mapa['code'];
          isw.msg = mapa['msg'];
          isw.tag = mapa['tag'];
          isw.datos = mapa['data'];
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        log(mapa.toString());
        isw.code = mapa['code'];
        isw.msg = mapa['msg'];
        isw.tag = mapa['tag'];
        isw.datos = mapa['data'];
      }
    } catch (e) {
      isw.code = 500;
      isw.msg = "Error";
      isw.tag = "Error inesperado";
      isw.datos = {};
    }
    return isw;
  }

  Future<RespuestaGenerica> registro(Map<String, String> mapa) async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final String _url = '${c.URL}admin/personas/usuario';
    final uri = Uri.parse(_url);
    InicioSesionSW isw = InicioSesionSW();

    try {
      final response =
          await http.post(uri, headers: _header, body: jsonEncode(mapa));
      isw.code = response.statusCode;
      isw.msg = response.body;
      isw.tag = "Registro";
      isw.datos = {};

      if (response.statusCode == 200) {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString());
        isw.code = mapa['code'];
        isw.msg = mapa['msg'];
        isw.tag = mapa['tag'];
        isw.datos = mapa['datos'];

        log("si se pudo encontrar");
      } else {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString() + "error");
        isw.code = mapa['code'];
        isw.msg = mapa['msg'];
        isw.tag = mapa['tag'];
        isw.datos = mapa['datos'];

        log("no se pudo encontrar");
      }
      return RespuestaGenerica();
    } catch (e) {
      log(e.toString());
    }
    return isw as RespuestaGenerica;
  }

  Future<RespuestaGenerica> addComentario(Map<String, String> mapa) async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final String _url = '${c.URL}comentarios/save';
    final uri = Uri.parse(_url);
    InicioSesionSW isw = InicioSesionSW();

    try {
      final response =
          await http.post(uri, headers: _header, body: jsonEncode(mapa));
      isw.code = response.statusCode;
      isw.msg = response.body;
      isw.tag = "Registro";
      isw.datos = {};

      if (response.statusCode == 200) {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString());
        isw.code = mapa['code'];
        isw.msg = mapa['msg'];
        isw.tag = mapa['tag'];
        isw.datos = mapa['datos'];

        //log("si se pudo encontrar");
      } else {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString() + "error");
        isw.code = mapa['code'];
        isw.msg = mapa['msg'];
        isw.tag = mapa['tag'];
        isw.datos = mapa['datos'];

        //log("no se pudo encontrar");
      }
      return RespuestaGenerica();
    } catch (e) {
      log(e.toString());
    }
    return isw as RespuestaGenerica;
  }

  Future<List<dynamic>> listar() async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final String _url = '${c.URL}noticias';
    final uri = Uri.parse(_url);

    try {
      final response = await http.get(uri, headers: _header);

      if (response.statusCode == 200) {
        // Si la solicitud es exitosa, devuelve la lista de noticias
        List<dynamic> noticias = json.decode(response.body);
        return noticias;
      } else {
        // Si la solicitud falla, imprime el mensaje de error y devuelve una lista vacía
        print('Error en la solicitud: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      return [];
    }
  }

  Future<RespuestaGenerica> getNoticias() async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final String _url = '${c.URL}noticias';
    final uri = Uri.parse(_url);
    RespuestaGenerica res = RespuestaGenerica();

    try {
      final response = await http.get(uri, headers: _header);
      res.code = response.statusCode;
      res.msg = response.body;
      res.datos = {};

      if (response.statusCode == 200) {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString());
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("si se pudo encontrar");
      } else {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString() + "error");
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("no se pudo encontrar");
      }
      return res;
    } catch (e) {
      log(e.toString());
    }
    return res;
  }

  Future<RespuestaGenerica> getComentarios(String externalId,
      {int limit = 10, int page = 1}) async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final String _url =
        '${c.URL}comentarios/noticia/$externalId?limit=$limit&page=$page';
    final uri = Uri.parse(_url);
    RespuestaGenerica res = RespuestaGenerica();

    try {
      final response = await http.get(uri, headers: _header);
      res.code = response.statusCode;
      res.msg = response.body;
      res.datos = {};

      if (response.statusCode == 200) {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString());
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("si se pudo encontrar");
      } else {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString() + "error");
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("no se pudo encontrar");
      }
      return res;
    } catch (e) {
      log(e.toString());
    }
    return res;
  }

  Future<RespuestaGenerica> getComentariosPersona(String external_id) async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final String _url = '${c.URL}comentarios/persona/$external_id';
    final uri = Uri.parse(_url);
    RespuestaGenerica res = RespuestaGenerica();

    try {
      final response = await http.get(uri, headers: _header);
      res.code = response.statusCode;
      res.msg = response.body;
      res.datos = {};

      if (response.statusCode == 200) {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString());
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("si se pudo encontrar los comentarios de la persona");
      } else {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString() + "error");
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("no se pudo encontrar");
      }
      return res;
    } catch (e) {
      log(e.toString());
    }
    return res;
  }

  Future<RespuestaGenerica> modificarComentario(
      Map<String, String> mapa) async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Extraer el 'id' del mapa
    String external_id = mapa['comentario'] ?? '';

    final String _url =
        '${c.URL}comentarios/modificar/$external_id'; // Agregar el 'id' al final de la URL
    final uri = Uri.parse(_url);
    RespuestaGenerica res = RespuestaGenerica();

    try {
      final response =
          await http.put(uri, headers: _header, body: jsonEncode(mapa));
      res.code = response.statusCode;
      res.msg = response.body;
      res.datos = {};

      if (response.statusCode == 200) {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString());
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("si se pudo encontrar");
      } else {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString() + "error");
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("no se pudo encontrar");
      }
      return res;
    } catch (e) {
      log(e.toString());
    }
    return res;
  }

  Future<RespuestaGenerica> obtenerPerfil() async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    Utiles util = Utiles();
    var external_i = await util.getValue('external_id');
    final String _url = '${c.URL}admin/personas/get/$external_i';
    final uri = Uri.parse(_url);
    RespuestaGenerica res = RespuestaGenerica();

    try {
      final response = await http.get(uri, headers: _header);
      res.code = response.statusCode;
      res.msg = response.body;
      res.datos = {};

      if (response.statusCode == 200) {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString());
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("Perfil encontrado con éxito");
      } else {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString() + " error");
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("No se pudo encontrar el perfil");
      }
      return res;
    } catch (e) {
      log(e.toString());
    }
    return res;
  }

  Future<RespuestaGenerica> modificarPerfil(Map<String, String> mapa) async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    Utiles util = Utiles();
    var external_id = await util.getValue('external_id');

    final String _url =
        '${c.URL}admin/personas/modificar/$external_id'; // Agregar el 'id' al final de la URL
    final uri = Uri.parse(_url);
    RespuestaGenerica res = RespuestaGenerica();

    try {
      final response =
          await http.put(uri, headers: _header, body: jsonEncode(mapa));
      res.code = response.statusCode;
      res.msg = response.body;
      res.datos = {};

      if (response.statusCode == 200) {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString());
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("si se pudo encontrar");
      } else {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString() + "error");
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("no se pudo encontrar");
      }
      return res;
    } catch (e) {
      log(e.toString());
    }
    return res;
  }

  Future<RespuestaGenerica> listarComentarios() async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final String _url = '${c.URL}comentarios';
    final uri = Uri.parse(_url);
    RespuestaGenerica res = RespuestaGenerica();

    try {
      final response = await http.get(uri, headers: _header);
      res.code = response.statusCode;
      res.msg = response.body;
      res.datos = {};

      if (response.statusCode == 200) {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString());
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("si se pudo encontrar");
      } else {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString() + "error");
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("no se pudo encontrar");
      }
      return res;
    } catch (e) {
      log(e.toString());
    }
    return res;
  }

  Future<RespuestaGenerica> banearUsuario(String externalCuenta) async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final String _url = '${c.URL}banear/$externalCuenta';
    final uri = Uri.parse(_url);
    RespuestaGenerica res = RespuestaGenerica();
    try {
      final response = await http.put(uri, headers: _header);
      res.code = response.statusCode;
      res.msg = response.body;
      res.datos = {};
      if (response.statusCode == 200) {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString());
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("si se pudo encontrar");
      } else {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString() + "error");
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("no se pudo encontrar");
      }
      return res;
    } catch (e) {
      log(e.toString());
    }
    return res;
  }

  Future<RespuestaGenerica> desactivarComentarios(
      String externalPersona) async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final String _url = '${c.URL}comentarios/desactivar/$externalPersona';
    final uri = Uri.parse(_url);
    RespuestaGenerica res = RespuestaGenerica();
    try {
      final response = await http.put(uri, headers: _header);
      res.code = response.statusCode;
      res.msg = response.body;
      res.datos = {};
      if (response.statusCode == 200) {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString());
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("si se pudo encontrar");
      } else {
        Map<String, dynamic> mapa = json.decode(response.body);
        log(mapa.toString() + "error");
        res.code = mapa['code'];
        res.msg = mapa['msg'];
        res.datos = mapa['datos'];
        log("no se pudo encontrar");
      }
      return res;
    } catch (e) {
      log(e.toString());
    }
    return res;
  }
}
