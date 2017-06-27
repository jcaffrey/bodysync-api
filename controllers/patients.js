/**

    dependencies

 */

var models = require('../models/index');
var jwt = require('jsonwebtoken');
var auth = require('./auth');
// app.locals.config = config not working?
var env = process.env.NODE_ENV || 'development';
var config = require('../config/config.json')[env];
var nodemailer = require('nodemailer');
var Mailgen = require('mailgen');
var ses = require('nodemailer-ses-transport');


/**

    CREATE (HTTP POST)

 */

module.exports.createPatient = (req, res, next) => {
    if(auth.checkRequestIdAgainstId(req, res)) {
        models.pt.findAll({
            where: {
                email: req.body.email
            }
        }).then(function (user) {
            if(Object.keys(user).length !== 0) {
                return res.status(405).send('sorry that email is taken');
            } else {
                console.log('ABOUT TO CREATE PATIENT..')
                models.patient.create({
                    name: req.body.name,
                    email: req.body.email,
                    proPicUrl: req.body.proPicUrl,
                    phoneNumber: req.body.phoneNumber,
                    phoneProvider: req.body.phoneProvider,
                    surgeryType: req.body.surgeryType,
                    isRestrictedFromRom: req.body.isRestrictedFromRom,
                    age: req.body.age,
                    weight: req.body.weight,
                    ptId: req.params.id,
                    hash: "temp"
                }).then(function(pat) {
                    if(Object.keys(pat).length !== 0)
                    {
                        var payload = {id: pat.id, sessionNumber: null, isPt: false, isAdmin: false};
                        var token = jwt.sign(payload, config.secret, {expiresIn: 60 * 60});

                        pat.forgotToken = token;
                        pat.save().then(() => {

                        var transporter = nodemailer.createTransport(ses({
                            accessKeyId: config.AWS_ACCESS_KEY_ID,
                            secretAccessKey: config.AWS_SECRET_ACCESS_KEY
                        }));

                        var mailGenerator = new Mailgen({
                            theme: 'default',
                            product: {
                                name: 'Prompt Therapy Solutions',
                                link: config.frontendServer
                            }
                        });

                        var e = {
                            body: {
                                intro: 'Welcome to Prompt Therapy Solutions - the road to recovery starts here!',
                                action: {
                                    button : {
                                        color: '#2e3192',
                                        text: 'Create your password',
                                        link: config.frontendServer + '/reset-token/' + token + '/' + false
                                    }
                                },
                                outro: 'Need help, or have questions? Just reply to this email.'
                            }
                        }

                        var emailBody = mailGenerator.generate(e);
                        var emailText = mailGenerator.generatePlaintext(e);

                        var mailOptions = {
                            to: req.body.email,
                            from: 'prompttherapysolutions@gmail.com',
                            subject: 'Welcome',
                            html: emailBody,
                            text: emailText
                        };
                        transporter.sendMail(mailOptions, function (err) {
                            if(err)
                                return next(err); // test this.
                        });

                        return res.json(pat);
                        //return next();
                        }).catch(function (err) {
                            // console.log('did not save')
                            return next(err);
                        })
                }
                else {
                    return res.status(404).send('not found!');
                }
            }).catch(function (err) {
                console.log('in here')
                return next(err);
            })
            }

        }).catch(function (err) {
                console.log('THIS ERRORED')
                return next(err);
            })
    }
    return;
};


/**

    READ (HTTP GET)

 */


// TODO: figure out what to return when patients object below is []
module.exports.getPatients = (req, res, next) => {

    if(auth.checkRequestIdAgainstId(req, res)) {

        models.patient.findAll({
            where: {
                ptId: req.params.id
            }

        }).then(function(patients) {
            if(patients && patients.length !== 0)
                return res.json(patients);
            else
                return res.json([]);
            // var pIds = [];
            // for (var p in patients) {
            //     pIds.push(patients[p].id);
            // }
            // req.body.patientIds = pIds;
            // return next();
        }).catch(function (e) {
            return next(e);
        })
    }
};


module.exports.getPatientById = (req, res, next) => {
    // auth
    var token = req.query.token || req.body.token || req.headers['x-access-token'];
    var decoded = jwt.verify(token, config.secret);

    models.patient.findOne({
        where: {id: req.params.id}
    }).then(function(patient) {
        // auth is done here so only one query
        // pt and patient alike have access
  
        // if pt
        if (decoded.isPt) {
            // if requesting pt is requested patient's pt
            if (decoded.id == patient.ptId) { // should be === ?
               // req.body.patientId = patient.id;
                return res.json(patient);
                //return next();
            }  
            else {
                return res.status(401).send('You are not authorized to see this resource');
            }
        }
        // else if patient
        else {
            // if requesting patient is requested patient
            if (decoded.id == req.params.id) {
                return res.json(patient);
            } 
            else {
                return res.status(401).send('You are not authorized to see this resource');
            }        
        }
    }).catch(function(err) {
        return next(err);
    })
};





/**

    UPDATE (HTTP PUT)

 */

module.exports.updatePatientNotes = (req, res, next) => {
    var token = req.query.token || req.body.token || req.headers['x-access-token'];
    var decoded = jwt.verify(token, config.secret);
    // TODO : test that req.body.ptNotes exists

    models.patient.findOne({
        where: {
            id: req.params.id
        }
    }).then(function(pat) {
        if(Object.keys(pat).length !== 0)
        {
            if(pat.ptId == decoded.id)
            {
                pat.ptNotes = req.body.ptNotes || pat.ptNotes;
                pat.save().then(() => {
                    return res.json(pat);
                    //return res.status(200).send('success');
                }).catch((err) => {
                    return next(err);
                })
            }
            else
            {
                return res.status(403).send('not authorized');
            }
        }
        else
        {
            return res.status(404).send('could not find')
        }
    }).catch((err) => {
        return next(err);
    })
}

//
// for testing only
// module.exports.findParanoid = (req, res, next) => {
//     models.patient.findAll({
//         paranoid: false
//     }).then(function (pats) {
//         if(pats.length !== 0)
//             res.json(pats)
//         else
//             res.json([]);
//     })
// }


/**

    DELETE (HTTP DELETE)

 */

module.exports.deletePatient = (req, res, next) => {
    var token = req.query.token || req.body.token || req.headers['x-access-token'];
    var decoded = jwt.verify(token, config.secret);

    models.patient.findOne({
        where: {
            id: req.params.id
        }
    }).then(function (patient) {
        if (patient.length !== 0)
        {
            if (decoded.isPt) {
                // if requesting pt is requested patient's pt
                if (decoded.id === patient.ptId) {
                    patient.destroy();
                    return res.json(patient);
                    //return next();
                }
                else {
                    return res.status(401).send('You are not authorized to destroy this resource');
                }
            }
        }
        else
            return res.status(404).send('Sorry not found');
    }).catch(function(err) {
        return next(err);
                        // doesn't quite catch error how we would want? still get:
                            // Error: No default engine was specified and no extension was provided.
    });
};

module.exports.isVerified = (req, res, next) => {
    var token = req.query.token || req.body.token || req.headers['x-access-token'];
    var decoded = jwt.verify(token, config.secret);

    if(!decoded.isPt && decoded.id == req.params.id)
    {
        models.patient.findOne({
            where: {
                id: req.params.id
            }
        }).then(function (pat) {
            if (pat && Object.keys(pat).length !== 0)
            {
                if (pat.isVerified) {
                    return res.json({isVerified: true});
                }
                else {
                    return res.json({isVerified: false});
                }
            }
            else
            {
                return res.status(404).send('no such patient found');
            }
        })
    }
    else
    {
        return res.status(403).send('not authorized');
    }
}
