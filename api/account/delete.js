/**
 * Created by Joey on 14-7-18.
 */

var _ = require('underscore');
var mongodb = require('../../libs/mongodb.js');
var moment = require('moment');

exports = module.exports = function(req, res, next) {
    exports.Do(req.body, function(err, result){
        //
        res.send({
            err: err,
            result: result
        });
    });
};

function DeleteAccount(id)
{
    mongodb.Account.remove({'_id': id}, function(err){
        //
        if(err){
            log.info('Account /delete error: ', err);
        }
        else{
        }
    });
}

exports.Do = function(body, func)
{
    //
    if(Array.isArray(body.id)){
        //
        _.each(body.id, function(accountID){
            DeleteAccount(accountID);
        });
    }
    else{
        DeleteAccount(body.id);
    }

    func && func(null, '');
}

exports.Token = '/delete';