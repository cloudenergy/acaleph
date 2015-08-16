/**
 * Created by Joey on 14-7-18.
 */

var _ = require('underscore');
var mongodb = require('../../libs/mongodb.js');
var moment = require('moment');
var apiUtil = require('../apiUtil');

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
    var setObj = apiUtil.ParameterFilter(body, ['token','expire', 'lastlogin']);

    mongodb.Account.update(
        {'_id': body._id || body.id},
        {$set: setObj},
        {},
        function(err){
            log.info(err);
            if(err){
                func && func(err, {});
            }
            else{
                func && func(null, '');
            }
        }
    );
}

exports.Token = '/update';