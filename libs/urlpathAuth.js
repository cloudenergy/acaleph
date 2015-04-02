/**
 * Created with JetBrains WebStorm.
 * User: christozhou
 * Date: 14-7-21
 * Time: 下午10:14
 * To change this template use File | Settings | File Templates.
 */

var mongodb = require('./mongodb.js');
var crypto = require('crypto');
var config = require('config');
var moment = require('moment');
var _ = require('underscore');
var crypto = require('crypto');
var accountInfo = require('../api/account/info');

function MD5(plain)
{
    return crypto.createHash('md5').update(plain).digest('hex').toUpperCase();
}

module.exports = exports = function(accessURL, req, res, func){
    //
    var cookie = req.cookies;
    var user = cookie.user || req.body.user;
//    console.log(req.body, req.cookies);
    var findKey = {'id': user};
//    console.log('findKey', findKey);

    accountInfo.Do(findKey, function (err, item) {
        if(err || item.length == 0){
            func && func(401, 'Try Access After Login')
        }
        else{
            var token = cookie.token || req.body.token;
            var userInfo = item;
            //验证p(proof)加密串是否正确
            var cypherFromServerSide = MD5(user + userInfo.passwd + user);
            if(cypherFromServerSide != token){
                //
                func && func(401, null);
                return;
            }

            func && func(err, userInfo);
        }
    });
//    mongodb.Account.find(
//        findKey,
//        function(err, item){
//            //
//
//        }
//    );
};

exports.VerifyParameter = function(param, secretKey)
{
    //
    if(param._sign == undefined){
        return false;
    }

    //判断请求是否超时
    if( config.enableTimeout ){
        var reqTimestamp = param._time || 0;
        if( Math.abs(moment().unix() - param._time) > config.requestTimeout ){
            //请求超时
            return false;
        }
    }

    //
    var sign = param._sign;
    var sortArray = new Array();
    for(key in param){
        sortArray.push(key);
    }
    sortArray.sort();

    var newParam = {};
    for(key in sortArray){
        pKey = sortArray[key];
        pValue = kv[pKey];
        newParam[pKey] = pValue;
    }

    var plainText = secretKey;
    for(key in newParam){
        plainText += key.toString() + newParam[key].toString();
    }
    plainText += secretKey;

    var cypherText = crypto.createHash('md5').update(plainText).digest('hex').toUpperCase();
    return cypherText == sign;
}