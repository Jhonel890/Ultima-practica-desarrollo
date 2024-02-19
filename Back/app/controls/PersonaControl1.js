'use strict';

var models = require('../models')
var persona = models.persona;
var rol = models.rol;

class PersonaControl {
    async listar(req, res) {
        var lista = await persona.findAll({
            include: [
                { model: models.cuenta, as: "cuenta", attributes: ['correo'] },
                { model: models.rol, as: "rol", attributes: ['nombre'] },

            ],
            attributes: [['external_id', 'External id'], 'apellidos', 'nombres', 'direccion', 'celular', 'fecha_nac',]
        });
        res.status(200);
        res.json({ msg: "OK", code: 200, datos: lista });
    }

    async obtener(req, res) {
        const external = req.params.external;
        var lista = await persona.findOne({
            where: {
                external_id: external
            },
            include: [
                { model: models.cuenta, as: "cuenta", attributes: ['correo'] },
                { model: models.rol, as: "rol", attributes: ['nombre'] },

            ],
            attributes: [['external_id', 'id'], 'apellidos', 'nombres', 'direccion', 'celular', 'fecha_nac',]
        });
        if (lista == undefined || lista == null) {
            res.status(200);
            res.json({ msg: "OK", code: 200, datos: {} });

        } else {
            res.status(200);
            res.json({ msg: "OK", code: 200, datos: lista });
        }
    }

    async guardar(req, res) {
        if (req.body.hasOwnProperty('nombres') && req.body.hasOwnProperty('apellidos')
            && req.body.hasOwnProperty('direccion') && req.body.hasOwnProperty('celular') &&
            req.body.hasOwnProperty('fecha') && req.body.hasOwnProperty('rol') && req.body.hasOwnProperty('correo')
            && req.body.hasOwnProperty('clave')) {
            var uuid = require('uuid');
            var rolA = await rol.findOne({ where: { external_id: req.body.rol } });
            if (rolA != undefined) {
                var data = {
                    nombres: req.body.nombres,
                    apellidos: req.body.apellidos,
                    direccion: req.body.direccion,
                    celular: req.body.celular,
                    fecha_nac: req.body.fecha,
                    id_rol: rolA.id,
                    external_id: uuid.v4(),
                    cuenta: {
                        correo: req.body.correo,
                        clave: req.body.clave
                    }

                }
                //Si existe un error como un duplicate al momento de crear un a cuenta se maneja el transaction 
                //para revertir los cambios hechos en persona
                let transaction = await models.sequelize.transaction();
                try {
                    var result = await persona.create(data, { include: [{ model: models.cuenta, as: "cuenta" }], transaction });
                    await transaction.commit();
                    if (result == null) {
                        res.status(401);
                        res.json({ msg: "ERROR", tag: "No se puede crear", code: 401 });
                    } else {
                        rolA.external_id = uuid.v4();
                        await rolA.save();
                        res.status(200);
                        res.json({ msg: "Ok", code: 200 })
                    }

                } catch (error) {
                    //aqui se hace el rolback
                    if (transaction) await transaction.rollback();
                    res.status(203);
                    res.json({ msg: "NOOO mijo este ya tiene cuentaaa", code: 400, error_msg: error });
                }


            } else {

                res.status(400);
                res.json({ msg: "ERROR", tag: "El dato a buscar no existe", code: 400 });
            }

        } else {
            res.status(400);
            res.json({ msg: "ERROR", tag: "Faltan datos", code: 400 });
        }
    }

    async guardarUsuario(req, res) {
        if (req.body.hasOwnProperty('nombres') && req.body.hasOwnProperty('apellidos')
            && req.body.hasOwnProperty('correo')
            && req.body.hasOwnProperty('clave')) {
            var uuid = require('uuid');
            var rolA = await rol.findOne({ where: { nombre: "usuario" } });
            if (rolA != undefined) {
                var data = {
                    nombres: req.body.nombres,
                    apellidos: req.body.apellidos,
                    id_rol: rolA.id,
                    external_id: uuid.v4(),
                    cuenta: {
                        correo: req.body.correo,
                        clave: req.body.clave
                    }

                }
                //Si existe un error como un duplicate al momento de crear un a cuenta se maneja el transaction 
                //para revertir los cambios hechos en persona
                let transaction = await models.sequelize.transaction();
                try {
                    var result = await persona.create(data, { include: [{ model: models.cuenta, as: "cuenta" }], transaction });
                    await transaction.commit();
                    if (result == null) {
                        res.status(401);
                        res.json({ msg: "ERROR", tag: "No se puede crear", code: 401 });
                    } else {
                        rolA.external_id = uuid.v4();
                        await rolA.save();
                        res.status(200);
                        res.json({ msg: "Ok", code: 200 })
                    }

                } catch (error) {
                    //aqui se hace el rolback
                    if (transaction) await transaction.rollback();
                    res.status(203);
                    res.json({ msg: "NOOO mijo este ya tiene cuentaaa", code: 400, error_msg: error });
                }

            }
        }
    }

    async modificar(req, res) {
        try {
            const external = req.params.external;
            const personaModificada = req.body;

            // Verificar si la persona con el external_id proporcionado existe
            const personaExistente = await persona.findOne({
                where: {
                    external_id: external
                },
            });

            if (personaExistente) {
                // Modificar los atributos de la persona existente
                personaExistente.nombres = personaModificada.nombres || personaExistente.nombres;
                personaExistente.apellidos = personaModificada.apellidos || personaExistente.apellidos;

                // Guardar los cambios en la base de datos
                await personaExistente.save();

                res.status(200).json({ msg: "OK", code: 200, datos: personaExistente.apellidos + ' ' + personaExistente.nombres });
            } else {
                res.status(404).json({ msg: "ERROR", tag: "Persona no encontrada", code: 404 });
            }
        } catch (error) {
            console.error('Error al modificar persona:', error);
            res.status(500).json({ msg: "ERROR", tag: "Error interno del servidor", code: 500 });
        }
    }
}

module.exports = PersonaControl;