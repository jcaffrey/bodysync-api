var models = require('../models/index');
var jwt = require('jsonwebtoken');
var auth = require('./auth');
// app.locals.config = config not working?
var env = process.env.NODE_ENV || 'development';
var config = require('../config/config.json')[env];

module.exports.createMeasure = (req, res, next) => {
    var token = req.query.token || req.body.token || req.headers['x-access-token'];
    var decoded = jwt.verify(token, config.secret);

    models.romMetric.findOne({
        where: {
            id: req.params.id
        }
    }).then(function(romMetric) {
        if(Object.keys(romMetric).length !== 0){
            models.injury.findOne({
                where: {
                    id: romMetric.injuryId
                }
            }).then(function(injury) {
                if(Object.keys(injury).length !== 0){
                    models.patient.findOne({
                        where: {
                            id: injury.patientId
                        }
                    }).then(function(patient) {
                        if(Object.keys(patient).length !== 0) {
                            if(decoded.isPt && decoded.id == patient.ptId) {
                                models.romMetricMeasure.create({
                                    name: req.body.name,
                                    degreeValue: req.body.degreeValue,
                                    nextGoal: req.body.nextGoal,
                                    dayOfNextGoal: req.body.dayOfNextGoal,
                                    dayMeasured: req.body.dayMeasured,
                                    endRangeGoal: req.body.endRangeGoal,
                                    romMetricId: req.params.id
                                }).then(function (measure) {
                                    if(Object.keys(measure).length !== 0){
                                        return res.json(measure);
                                        //return next();
                                    }
                                    else {
                                        return res.status(500).send('Could not create');
                                    }
                                }).catch(function (err) {
                                    return next(err);
                                })
                            } else {
                                return res.status(401).send('Unauthorized');
                            }
                        } else {
                            return res.status(404).send('No patient with that injury');
                        }
                    }).catch(function (err) {
                        // CURRENTLY CATCHING ERROR HERE--GERARDO COULDN'T FIGURE IT OUT
                        console.log("here1");
                        return next(err);
                    })
                } else {
                    return res.status(404).send('No patient with that injury');
                }
            }).catch(function (err) {
                // CURRENTLY CATCHING ERROR HERE--GERARDO COULDN'T FIGURE IT OUT
                return console.log("here2");
            })
        } else {
            return res.status(404).send('No injury with that rom');
        }
    }).catch(function (err) {
        return next(err);
    })
}

// TODO: figure out what to return when patients object below is []
module.exports.getMeasures = (req, res, next) => {
    var token = req.query.token || req.body.token || req.headers['x-access-token'];
    var decoded = jwt.verify(token, config.secret);

    models.romMetricMeasure.findAll({
        where: {
            romMetricId: req.params.id
        }
    }).then(function(measures) {
        if(measures.length !== 0) {
            var firstMeasure = measures[0]

            models.romMetric.findOne({
                where: {
                    id: firstMeasure.romMetricId
                }
            }).then(function (rom) {
                if(Object.keys(rom).length !== 0) {
                    models.injury.findOne({
                        where: {
                            id: rom.injuryId
                        }
                    }).then(function (injury) {
                        if(Object.keys(injury).length !== 0) {
                            // check patient-level flag
                            models.patient.findOne({
                                where: {
                                    id: injury.patientId
                                }
                            }).then(function (patient) {
                                if(Object.keys(patient).length !== 0) {
                                    if(!decoded.isPt) {
                                        if(!patient.isRestrictedFromRom || patient.id == decoded.id) {
                                            return res.json(measures);
                                        } else {
                                            return res.status(401).send('Patient unauthorized');
                                        }
                                    }
                                    // is pt
                                    else {
                                        if(decoded.id == patient.ptId) {
                                            //req.body.patientId = patient.id || injury.patientId;
                                            return res.json(measures);
                                            //return next();
                                        }
                                        else {
                                            return res.status(401).send('PT unauthorized');
                                        }
                                    }
                                }
                            }).catch(function (err) {
                                return next(err);
                            })
                        }
                    }).catch(function (err) {
                        return next(err);
                    })
                }
            }).catch(function (err) {
                return next(err);
            })
        } else {
            return res.status(404).send('No Measures for that RomMetric');
        }
    }).catch(function (err) {
        return next(err);
    })
}