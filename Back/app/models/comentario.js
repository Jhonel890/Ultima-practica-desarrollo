'use strict';


module.exports = (sequelize, DataTypes) => {
    const comentario = sequelize.define('comentario', {
        cuerpo: {
            type: DataTypes.STRING(100), defaultValue: "NONE",
        },
        estado: {
            type: DataTypes.BOOLEAN, defaultValue: true,
        },
        fecha: {
            type: DataTypes.DATEONLY, defaultValue: DataTypes.NOW,
        },
        hora: {
            type: DataTypes.TIME, defaultValue: DataTypes.NOW,
        },
        usuario: {
            type: DataTypes.STRING(100), defaultValue: "NONE",
        },
        longitud: {
            type: DataTypes.DOUBLE, defaultValue: 0,
        },
        latitud: {
            type: DataTypes.DOUBLE, defaultValue: 0,

        },
        external_id: {
            type: DataTypes.UUID,
            defaultValue: DataTypes.UUIDV4,
            primaryKey: true
        },
    }, { freezeTableName: true });

    comentario.associate = function (models) {
        comentario.belongsTo(models.noticia, { foreignKey: 'id_noticia', as: 'noticia' });
        comentario.belongsTo(models.persona, { foreignKey: 'id_persona' });
    };



    return comentario;
};
