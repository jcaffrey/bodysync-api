// http://docs.sequelizejs.com/en/1.7.0/articles/express
// for bcyrpt - http://anneblankert.blogspot.com/2015/06/node-authentication-migrate-from.html
"use strict";

var bcrypt = require('bcrypt-nodejs');

module.exports = function(sequelize, DataTypes) {
    var patient = sequelize.define("patient", {
        // schema
        name: {
            type: DataTypes.STRING,
            allowNull: false
        },
        hash: {
            type: DataTypes.STRING,
            allowNull: false
        },
        proPicUrl: {
            type: DataTypes.STRING,
            defaultValue: 'https://s3.amazonaws.com/bodysync-photo-upload/default-profile-img.png',
            allowNull: true
        },
        surgeryType: {
            type: DataTypes.STRING,
            allowNull: false
        },
        email: {
            type: DataTypes.STRING,
            unique: true,
            allowNull: false,
            validate: {
                isEmail: true
            }
        },
        surgeonName: {
            type: DataTypes.STRING
        },
        // workers comp patients should have this set to true -> not allowed to see their ROM
        isRestrictedFromRom: {
            type: DataTypes.BOOLEAN,
            defaultValue: false
        },
        forgotToken: {
            type: DataTypes.STRING
        },
        token: {
            type: DataTypes.STRING
        },
        phoneNumber: {
            type: DataTypes.STRING
        },
        age: DataTypes.INTEGER,
        weight: DataTypes.INTEGER,
        phoneProvider: DataTypes.STRING,
        surgeryNotes: DataTypes.TEXT,
        ptNotes: DataTypes.TEXT,
        isVerified: {
            type: DataTypes.BOOLEAN,
            defaultValue: false,
            allowNull: false
        }
    }, {
        classMethods: {
            associate: function(models) {
                patient.belongsTo(models.pt, {
                    onDelete: "CASCADE",     // not sure we need this - works with or without
                    foreignKey: {
                        allowNull: false
                    }
                });
                patient.hasMany(models.injury);
                patient.hasMany(models.exercise);
            },
            generateHash: function (hash) {
                return bcrypt.hashSync(hash, bcrypt.genSaltSync(8),null);  // think about doing this async if performance becomes noticeable
            },
        },
        instanceMethods: {
            validHash : function(hash) {
                return bcrypt.compareSync(hash, this.hash);
            }
        },
        paranoid: true
    });

    return patient;
};
