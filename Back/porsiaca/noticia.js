'use strict';

module.exports = (sequelize, DataTypes) => {
    const noticia = sequelize.define('noticia', {
        titulo: { type: DataTypes.STRING(100), defaultValue: 'NONE' },
        archivo: { type: DataTypes.STRING(100), defaultValue: 'NONE' },
        tipo_archivo: { type: DataTypes.ENUM(['VIDEO', 'IMAGEN']), defaultValue: 'IMAGEN' },
        tipo_noticia: { type: DataTypes.ENUM(['NORMAL', 'DEPORTIVA', 'URGENTE', 'SOCIAL', 'TECNOLOGIA']), defaultValue: 'NORMAL' },
        cuerpo: { type: DataTypes.TEXT, defaultValue: 'NONE' },
        fecha: { type: DataTypes.DATEONLY },
        external_id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4 }
    }, { freezeTableName: true });

    noticia.associate = function (models) {
        noticia.belongsTo(models.noticia, { foreignKey: 'id_noticia' });
        noticia.hasMany(models.comentario, { foreignKey: 'id_noticia', as: 'comentario' });
    };

    return noticia;
};
