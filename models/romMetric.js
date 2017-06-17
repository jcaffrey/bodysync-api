
"use strict";

module.exports = function(sequelize, DataTypes) {
    var romMetric = sequelize.define("romMetric", {
        // schema
        name: {
            type: DataTypes.STRING,
            allowNull: false
        },
        startRange: {
            type: DataTypes.FLOAT
        },
        endRangeGoal: {
            type: DataTypes.FLOAT,
            allowNull: false
        }
    }, {
        classMethods: {
            associate: function(models) {
                romMetric.belongsTo(models.injury, {
                    onDelete: "CASCADE",
                    foreignKey: {
                        allowNull: false
                    }
                });
                romMetric.hasMany(models.romMetricMeasure);
            }
        }
    });

    return romMetric;
};
