'use strict';

var models = require('../models');
var persona = models.persona;
var cuenta = models.cuenta;
var rol = models.rol;
let jwt = require('jsonwebtoken');

class CuentaControl {
    async inicio_sesion(req, res) {
        // npm install jsonwebtoken --save
        // npm install dotenv --save
        if (req.body.hasOwnProperty('correo') &&
            req.body.hasOwnProperty('clave')) {
            let cuentaA = await cuenta.findOne({
                where: { correo: req.body.correo },
                include: {
                    model: models.persona,
                    as: "persona",
                    attributes: ['apellidos', 'nombres', 'external_id'],
                    include: [{ model: models.rol, as: "rol", attributes: ['nombre'] }]
                },
            });
            if (cuentaA == null) {
                res.status(400);
                res.json({ msg: "ERROR", tag: " Cuenta no existe ", code: 400 });
            } else {
                if (cuentaA.estado == true) {
                    if (cuentaA.clave == req.body.clave) {
                        // todo....
                        const token_data = {
                            external: cuentaA.external_id,
                            check: true
                        };
                        require('dotenv').config();
                        // console.log("Valor de KEY_JWT:", process.env.KEY_JWT);
                        const key = process.env.KEY_JWT;
                        const token = jwt.sign(token_data, key, {
                            expiresIn: '2h'
                        });
                        var info = {
                            token: token,
                            user: cuentaA.persona.apellidos + ' ' + cuentaA.persona.nombres,
                            rol: cuentaA.persona ? cuentaA.persona.rol.nombre : null,
                            external_id: cuentaA.persona.external_id,
                        };
                        res.status(200);
                        res.json({ msg: "OK", tag: " Listo ", data: info, code: 200 });
                    } else {
                        res.status(400);
                        res.json({ msg: "ERROR", tag: " Clave incorrecta ", code: 400 });
                    }
                } else {
                    res.status(401);
                    res.json({ msg: "ERROR", tag: " La cuenta ha sido desactivada ", code: 401 });
                }
            }
        } else {
            res.status(400);
            res.json({ msg: "ERROR", tag: " Faltan datos", code: 400 });
        }
    }

    async desactivarCuenta(req, res) {
        const external = req.params.external;
        if (external) {
            let cuentaA = await cuenta.findOne({
                where: { external_id: external }
            });
            if (cuentaA == null) {
                res.status(400);
                res.json({ msg: "ERROR", tag: " Cuenta no existe ", code: 400 });
            } else {
                cuentaA.estado = false;
                cuentaA.save();
                res.status(200);
                res.json({ msg: "OK", tag: " Cuenta desactivada ", code: 200 });
            }
        } else {
            res.status(400);
            res.json({ msg: "ERROR", tag: " Faltan datos", code: 400 });
        }
    }
}

module.exports = CuentaControl;
