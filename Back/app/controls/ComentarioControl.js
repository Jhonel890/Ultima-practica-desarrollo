'use strict';

const models = require('../models');
const noticia = models.noticia;
const persona = models.persona;
const comentario = models.comentario;
const uuid = require('uuid');


class ComentarioControl {
    async listar(req, res) {
        try {
            const lista = await comentario.findAll({
                include: [
                    { model: models.noticia, as: "noticia", attributes: ['titulo'] },
                    {
                        model: models.persona,
                        as: "persona",
                        attributes: ['nombres', 'external_id'],
                        include: [
                            { model: models.cuenta, as: "cuenta", attributes: ['external_id', 'correo'] }
                        ]
                    }
                ],
                attributes: ['cuerpo', 'estado', 'fecha', 'usuario', 'hora'],
                order: [['hora', 'DESC']] // Order by fecha attribute in descending order
            });
            res.status(200).json({ msg: "OK", code: 200, datos: lista });
        } catch (error) {
            console.error(error);
            res.status(500).json({ msg: "ERROR", code: 500, error: error.message });
        }
    }

    async obtener(req, res) {
        try {
            const external = req.params.external;
            const lista = await comentario.findOne({
                where: { external_id: external },
                include: [
                    { model: models.noticia, as: "noticia", attributes: ['titulo'] },
                ],
                attributes: ['cuerpo', 'estado', 'fecha', 'usuario', 'longitud', 'latitud'],
            });
            res.status(200).json({ msg: "OK", code: 200, datos: lista || {} });
        } catch (error) {
            console.error(error);
            res.status(500).json({ msg: "ERROR", code: 500, error: error.message });
        }
    }

    async guardar(req, res) {
        if (req.body.hasOwnProperty('cuerpo') &&
            req.body.hasOwnProperty('fecha') &&
            req.body.hasOwnProperty('usuario') &&
            req.body.hasOwnProperty('longitud') &&
            req.body.hasOwnProperty('latitud') &&
            req.body.hasOwnProperty('noticia')) {

            const external = uuid.v4();

            var noticiaA = await noticia.findOne({
                where: { external_id: req.body.noticia }
            });

            var perA = await persona.findOne({
                where: { external_id: req.body.usuario }
            });

            //console.log(perA);

            if (!noticiaA) {
                return res.status(400).json({ msg: "ERROR", code: 400, tag: "Noticia no existe" });
            } else {
                if (!perA) {
                    return res.status(401).json({ msg: "ERROR", code: 400, tag: "Persona no existe" });
                } else {
                    var rolA = await models.rol.findOne({
                        where: { id: perA.id_rol },
                    });
                    if (rolA.nombre !== "usuario") {
                        return res.status(402).json({ msg: "ERROR", code: 400, tag: "La persona no es usuario" });
                    } else {
                        var data = {
                            external_id: external,
                            cuerpo: req.body.cuerpo,
                            fecha: req.body.fecha,
                            usuario: perA.nombres + " " + perA.apellidos,
                            longitud: req.body.longitud,
                            latitud: req.body.latitud,
                            id_noticia: noticiaA.id,
                            id_persona: perA.id,

                        };

                        var result = await comentario.create(data);
                        if (result == null || result == undefined) {
                            return res.status(403).json({ msg: "ERROR", code: 400, tag: "No se pudo guardar" });
                        } else {
                            return res.status(200).json({ msg: "OK", code: 200, datos: result });
                        }
                    }
                }
            }

        } else {
            res.status(400).json({ msg: "ERROR", code: 400, tag: "Datos incorrectos" });
        }
    }

    async modificar(req, res) {
        if (
            req.body.hasOwnProperty("cuerpo") &&
            req.body.hasOwnProperty("fecha") &&
            req.body.hasOwnProperty("latitud") &&
            req.body.hasOwnProperty("longitud")
        ) {
            const external = req.params.external;
            const lista = await comentario.findOne({
                where: { external_id: external },
            });

            if (!lista) {
                return res.status(404).json({ msg: "ERROR", code: 404, tag: "Comentario no encontrado" });
            } else {
                var data = {
                    cuerpo: req.body.cuerpo,
                    fecha: req.body.fecha,
                    longitud: req.body.longitud,
                    latitud: req.body.latitud,
                };

                var result = await comentario.update(data, {
                    where: { external_id: external },
                });

                if (result == null || result == undefined) {
                    return res.status(403).json({ msg: "ERROR", code: 400, tag: "No se pudo modificar" });
                } else {
                    return res.status(200).json({ msg: "OK", code: 200 });
                }
            }

        } else {
            res.status(400).json({ msg: "ERROR", code: 400, tag: "Datos incorrectos" });
        }


    }

    async obtenerComentariosNoticia(req, res) {
        try {
            const external = req.params.external;
            const limit = parseInt(req.query.limit) || 10; // Número de comentarios por página
            const page = parseInt(req.query.page) || 1; // Número de página actual
            const offset = (page - 1) * limit;

            // Verificar si la noticia con el external_id existe
            const noticiaEncontrada = await noticia.findOne({
                where: { external_id: external },
            });

            if (!noticiaEncontrada) {
                return res.status(404).json({ msg: "Noticia no encontrada", code: 404 });
            }

            const lista = await comentario.findAll({
                where: {
                    id_noticia: noticiaEncontrada.id,
                    estado: true
                },
                include: [
                    { model: models.noticia, as: "noticia", attributes: ['titulo'] },
                ],
                attributes: ['cuerpo', 'estado', 'fecha', 'usuario', 'longitud', 'latitud', 'hora',],
                limit: limit,
                offset: offset,
                order: [['hora', 'DESC']], // Order by fecha column in descending order
            });

            // Sort the comments by the most recent date and time
            lista.sort((a, b) => new Date(b.fecha) - new Date(a.fecha));

            res.status(200).json({ msg: "OK", code: 200, datos: lista || [] });
        } catch (error) {
            console.error(error);
            res.status(500).json({ msg: "ERROR", code: 500, error: error.message });
        }
    }

    async obtenerComentariosPersona(req, res) {
        try {
            const external = req.params.external;

            // Verificar si la persona con el external_id existe
            const personaEncontrada = await persona.findOne({
                where: { external_id: external },
            });

            if (!personaEncontrada) {
                return res.status(404).json({ msg: "Persona no encontrada", code: 404 });
            }

            const lista = await comentario.findAll({
                where: { usuario: personaEncontrada.nombres + " " + personaEncontrada.apellidos },
                include: [
                    { model: models.noticia, as: "noticia", attributes: ['titulo'] },
                ],
                attributes: ['cuerpo', 'estado', 'fecha', 'usuario', 'longitud', 'latitud', 'external_id'],
            });

            res.status(200).json({ msg: "OK", code: 200, datos: lista || [] });
        } catch (error) {
            console.error(error);
            res.status(500).json({ msg: "ERROR", code: 500, error: error.message });
        }
    }

    async desactivarComentariosPersona(req, res) {
        try {
            const external = req.params.external;

            // Verificar si la persona con el external_id proporcionado existe
            const personaEncontrada = await persona.findOne({
                where: { external_id: external },
            });

            if (!personaEncontrada) {
                return res.status(404).json({ msg: "Persona no encontrada", code: 404 });
            }

            const result = await comentario.update(
                { estado: false },
                { where: { id_persona: personaEncontrada.id } }
            );

            res.status(200).json({ msg: "OK", code: 200, datos: result });
        } catch (error) {
            console.error(error);
            res.status(500).json({ msg: "ERROR", code: 500, error: error.message });
        }
    }

    async obtenerComentariosNoticia(req, res) {
        try {
            const external = req.params.external;

            // Verificar si la noticia con el external_id existe
            const noticiaEncontrada = await noticia.findOne({
                where: { external_id: external },
            });

            if (!noticiaEncontrada) {
                return res.status(404).json({ msg: "Noticia no encontrada", code: 404 });
            }

            const lista = await comentario.findAll({
                where: {
                    id_noticia: noticiaEncontrada.id,
                    estado: true
                },
                include: [
                    { model: models.noticia, as: "noticia", attributes: ['titulo'] },
                ],
                attributes: ['cuerpo', 'estado', 'fecha', 'usuario', 'longitud', 'latitud', 'hora',],
                order: [['hora', 'DESC']], // Order by fecha column in descending order
            });

            // Sort the comments by the most recent date and time
            lista.sort((a, b) => new Date(b.fecha) - new Date(a.fecha));

            res.status(200).json({ msg: "OK", code: 200, datos: lista || [] });
        } catch (error) {
            console.error(error);
            res.status(500).json({ msg: "ERROR", code: 500, error: error.message });
        }
    }


}

module.exports = ComentarioControl;
