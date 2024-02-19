var express = require('express');
var router = express.Router();

//Persona
const personaC = require('../app/controls/PersonaControl1');
let personaControl = new personaC();
router.get('/admin/personas', personaControl.listar);
router.get('/admin/personas/get/:external', personaControl.obtener);
router.post('/admin/personas/save', personaControl.guardar);
router.put('/admin/personas/modificar/:external', personaControl.modificar);
router.post('/admin/personas/usuario', personaControl.guardarUsuario);
// router.put('/admin/banear/persona/:external', personaControl.banearPersona);



//Rol
const rolC = require('../app/controls/RolControl');
let rolControl = new rolC();
router.get('/admin/rol', rolControl.listar);
router.post('/admin/rol/save', rolControl.guardar);

//Comentario
const comentarioC = require('../app/controls/ComentarioControl');
let comentarioControl = new comentarioC();
router.get('/comentarios', comentarioControl.listar);
router.get('/comentarios/get/:external', comentarioControl.obtener);
router.post('/comentarios/save', comentarioControl.guardar);
router.put('/comentarios/modificar/:external', comentarioControl.modificar);
router.get('/comentarios/noticia/:external', comentarioControl.obtenerComentariosNoticia);
router.get('/comentarios/persona/:external', comentarioControl.obtenerComentariosPersona);
router.put('/comentarios/desactivar/:external', comentarioControl.desactivarComentariosPersona);


//Noticia
const noticiaA = require('../app/controls/NoticiaControl');
let noticiaControl = new noticiaA();
router.get('/noticias', noticiaControl.listar);
router.get('/noticias/get/:external', noticiaControl.obtener);
router.post('/noticias/guardar', noticiaControl.guardar);
router.post('/noticias/save/:external', noticiaControl.guardarFoto);
router.put('/noticias/modificar/:external', noticiaControl.modificar);

// Modeleware
const auth = function middleware(req, res, next) {
  const token = req.headers['news-token'];
  if (token == undefined) {
    res.status(400);
    res.json({ msg: "ERROR", tag: "Falta token", code: 400 });

  } else {
    require('dotenv').config();
    const key = process.env.KEY_JWT;
    jwt.verify(token, key, async (err, decode) => {
      if (err) {
        res.json(401);
        res.json({ msg: "Error", tag: "Token no válido", code: 401 })
      } else {
        console.log(decode.external);
        const models = require('../app/models');
        const cuenta = models.cuenta;
        const aux = await cuenta.findOne({
          where: { external_id: decoded.external }

        });
        if (aux == null) {

        }
      }

    })
  }
  //console.log(token);
  //console.log(next);
  //next();
}

//inicio de secion 
const cuentaControlC = require('../app/controls/CuentaControls');
let cuentaControl = new cuentaControlC();
router.post('/login', cuentaControl.inicio_sesion);
router.put('/banear/:external', cuentaControl.desactivarCuenta);




//Router
router.get('/', function (req, res, next) {
  res.send('Wenass a resource');
});
module.exports = router;
