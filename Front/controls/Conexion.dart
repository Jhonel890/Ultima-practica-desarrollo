import 'dart:developer';
import 'dart:ui';
import 'dart:convert';
import 'dart:core';
import 'package:flutter_noticias/controls/serviciosBack/RespuestaGenerica.dart';
import 'package:flutter_noticias/controls/utiles/Utiles.dart';
import 'package:http/http.dart' as http;

class Conexion {
  final String URL = "http://192.168.0.106:3000/api/";
  final String URL_MEDIA = "http://192.168.0.106:3000/multimedia/";
  static bool NOTOKEN = false;

  Future<RespuestaGenerica> solicitudGet(String recurso, bool token) async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token) {
      _header = {'content-Type': 'application/json', 'news-token': 'bhjgj'};
    }

    final String _url = URL + recurso;
    final uri = Uri.parse(_url);
    try {
      final response = await http.get(uri, headers: _header);
      if (response.statusCode == 200) {
        Map<String, dynamic> mapa = json.decode(response.body);
        return _response(mapa["code"], mapa["msg"], mapa["datos"]);
        //log("si se pudo encontrar");
      } else {
        Map<String, dynamic> mapa = json.decode(response.body);
        return _response(mapa["code"], mapa["msg"], mapa["datos"]);
        //log("no se pudo encontrar");
      }
      return RespuestaGenerica();
    } catch (e) {
      return _response(500, "Error en la conexion", []);
    }
  }

  Future<RespuestaGenerica> solicitudPost(
      String recurso, bool token, Map<dynamic, dynamic> mapa) async {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token) {
      Utiles util = Utiles();
      String? tokenA = await util.getValue("token");
      _header = {
        'content-Type': 'application/json',
        'news-token': tokenA.toString()
      };
    }

    final String _url = URL + recurso;
    final uri = Uri.parse(_url);
    try {
      final response =
          await http.post(uri, headers: _header, body: json.encode(mapa));
      log(response.body.toString());
      if (response.statusCode == 200) {
        Map<String, dynamic> mapa = json.decode(response.body);
        return _response(mapa["code"], mapa["msg"], mapa["datos"]);
        //log("si se pudo encontrar");
      } else {
        Map<String, dynamic> mapa = json.decode(response.body);
        return _response(mapa["code"], mapa["msg"], mapa["datos"]);
        //log("no se pudo encontrar");
      }
      return RespuestaGenerica();
    } catch (e) {
      return _response(500, "Error en la conexion", []);
    }
  }

  RespuestaGenerica _response(int code, String msg, dynamic data) {
    var respuesta = RespuestaGenerica();
    respuesta.code = code;
    respuesta.msg = msg;
    respuesta.datos = data;
    return respuesta;
  }
}
