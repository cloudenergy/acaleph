/**
 * Created by Joey on 14-7-18.
 */

var _ = require('underscore');
var mongodb = require('../../libs/mongodb.js');
var moment = require('moment');
var config = require('config');

exports = module.exports = function(req, res, next) {
    exports.Do(req.body, function(err, result){
        //
        res.send({
            err: err,
            result: result
        });
    });
};

exports.Do = function(body, func)
{
    //
    var obj = new mongodb.Account;
    obj._id = body.user;
    obj.passwd = body.passwd;
    obj.title = body.title;
    obj.lastlogin = new Date(body.lastlogin);
    obj.initpath = body.initpath;
    obj.expire = body.expire || config.defaultTokenExpire;
    obj.level = body.level;
    obj.billingAccount = body.billingAccount;
    obj.character = body.character;

    obj.save(function(err){
        if(err){
            func && func(err, {});
        }
        else{
            func && func(null, '');
        }
    });
}

exports.Token = '/add';