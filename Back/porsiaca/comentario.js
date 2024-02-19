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
            type: DataTypes.DATEONLY,
        },

    }, { freezeTableName: true });

    comentario.associate = function (models) {
        comentario.belongsTo(models.noticia, { foreignKey: 'id_noticia' });
    };



    return comentario;
};
