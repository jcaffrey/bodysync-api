/**

    dependencies

 */
var models = require('../models/index');
var jwt = require('jsonwebtoken');
var auth = require('./auth');
var env = process.env.NODE_ENV || 'development';
var config = require('../config/config.json')[env];
var nodemailer = require('nodemailer');
var Mailgen = require('mailgen');
var ses = require('nodemailer-ses-transport');

/**

    CREATE (HTTP POST)

 */

module.exports.createPt = (req, res, next) => {
   var transporter = nodemailer.createTransport(ses({
        accessKeyId: config.AWS_ACCESS_KEY_ID,
        secretAccessKey: config.AWS_SECRET_ACCESS_KEY
    }));

    models.pt.create({
        name: req.body.name,
        email: req.body.email,
        proPicUrl: req.body.proPicUrl,
        phoneNumber: req.body.phoneNumber,
        phoneProvider: 'att',
        isAdmin: false,
        hash: 'temp'
    }).then(function(pt) {
        if(Object.keys(pt).length !== 0)
        {
          var payload = {id: pt.id, sessionNumber: null, isPt: true, isAdmin: false};
          var token = jwt.sign(payload, config.secret, {expiresIn: 60 * 60});

          pt.forgotToken = token;
          pt.save().then(() => {
            var mailGenerator = new Mailgen({
              theme: 'default',
              product: {
                name: 'Prompt Therapy Solutions',
                link: config.frontendServer
              }
            });

          var e = {
            body: {
              intro: 'Welcome to Prompt Therapy Solutions',
              action: {
                button : {
                  color: '#2e3192',
                  text: 'Create your password',
                  link: config.frontendServer + '/reset-token/' + token + '/' + true
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
          return res.json(pt);

        }).catch(function (err) {
          return next(err);
        })
        }
        else
        {
            return res.status(500).send('something went wrong');
        }

        //return next();
    });
};


/**

    DELETE (HTTP DELETE)

 */

// TODO: update this!
module.exports.deletePt = (req, res, next) => {
    models.pt.destroy({
        where: {
            id: req.params.id
        }
    }).then(function() {
        return res.sendStatus(200);
    });
}

module.exports.isVerified = (req, res, next) => {
    var token = req.query.token || req.body.token || req.headers['x-access-token'];
    var decoded = jwt.verify(token, config.secret);

    if(decoded.isPt && decoded.id == req.params.id)
    {
        models.pt.findOne({
            where: {
                id: req.params.id
            }
        }).then(function (pt) {
            if (pt && Object.keys(pt).length !== 0)
            {
                if (pt.isVerified) {
                    return res.json({isVerified: true});
                }
                else {
                    return res.json({isVerified: false});
                }
            }
            else
            {
                return res.status(404).send('no such pt found');
            }
        })
    }
    else
    {
        return res.status(403).send('not authorized');
    }
}
