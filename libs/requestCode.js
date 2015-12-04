/*
 * 对请求加入校验机制
 * */

var _ = require('underscore');
var crypto = require('crypto');
var moment = require('moment');
var Q = require('q');

function RequestCode()
{}

/*
 * user: 用户ID,
 * token: 登录后服务器返回的token
 * data: 请求的参数对象
 * @Return
 *   返回加入签名以后的对象
 * */

function Hash(v)
{
    var hash = crypto.createHash('sha1');
    return hash.update(v.toString()).digest('hex');
}

function PlainText(data, vCode)
{
    var keyArray = [];
    _.map(data, function(v, k){
        keyArray.push(k);
    });

    keyArray.sort();

    var plainText = '';
    var kvArray = [];
    _.each(keyArray, function (key) {
        kvArray.push(key+'='+data[key]);
    });
    plainText = kvArray.toString();
    plainText = plainText.replace(/,/g, '');
    plainText = vCode + plainText + vCode;

    return plainText;
}

RequestCode.prototype.Encrypt = function(user, token, data)
{
    if(_.isEmpty(data)){
        return null;
    }

    var v = moment();
    var vCode = Hash(v.unix());

    data['v'] = v.unix();
    data['t'] = token;

    var plainText = PlainText(data, vCode);
    //console.log(plainText);

    var sign = Hash(plainText);
    //console.log(sign);

    data['sign'] = sign;
    data['p'] = user;
    data = _.omit(data, 't');

    return data;
};

function Encrypt(type, id, token, data)
{
    if(_.isEmpty(data)){
        return null;
    }

    var v = moment();
    var vCode = Hash(v.unix());

    data['v'] = v.unix();
    data['t'] = token;

    var plainText = PlainText(data, vCode);
    //console.log(plainText);

    var sign = Hash(plainText);
    //console.log(sign);

    data['sign'] = sign;
    if(type == 'USER') {
        data['pu'] = id;
    }
    else{
        data['pa'] = id;
    }
    data = _.omit(data, 't');

    return data;
};

RequestCode.prototype.EncryptAppIDSecret = function(appid, appsecret, data)
{
    return Encrypt('APPID', appid, appsecret, data);
};
RequestCode.prototype.EncryptUser = function (user, token, data)
{
    return Encrypt('USER', user, token, data);
};

RequestCode.prototype.Decrypt = function(data)
{
    if(_.isEmpty(data)){
        return null;
    }

    var deferred = Q.defer();

    var user = data.pa || data.pu;
    var type = data.pa ? 'APPID':'USER';
    var sign = data.sign;
    var v = data.v;
    if(!user || !sign || !v){
        return null;
    }

    var vCode = Hash(v);

    var encryptData = _.omit(data, ['pa', 'pu', 'sign', 't']);

    //get user's token
    var DecryptData = function(deferred, userInfo, encryptData)
    {
        encryptData['t'] = userInfo.token || userInfo.passwd;

        //验证
        var plainText = PlainText(encryptData, vCode);
        //console.log(plainText);

        var newSign = Hash(plainText);
        //console.log(newSign);

        if(sign == newSign){
            var plainData = _.omit(data, ['p','sign','t','v']);
            plainData['userinfo'] = userInfo;
            deferred.resolve(plainData);
        }
        else{
            deferred.reject({
                code: ErrorCode.Code.SIGNATUREFAILED,
                message: ErrorCode.Message.SIGNATUREFAILED
            });
        }
    };
    if(type == 'APPID'){
        //
        var appidsecret = Include('/api/appidsecret/info');
        appidsecret.Do({appid: user}, function (code, message, appIDSecretInfo) {
            if(code || !appIDSecretInfo || appIDSecretInfo.length == 0){
                deferred.reject({
                    code: ErrorCode.Code.USERNOTEXISTS,
                    message: ErrorCode.Message.USERNOTEXISTS
                });
            }
            else{
                DecryptData(deferred, appIDSecretInfo, encryptData);
            }
        })
    }
    else if(type == 'USER'){
        //
        var accountInfo = Include('/api/account/info');
        accountInfo.Do({id: user}, function (code, message, userInfo) {
            if(code || !userInfo || userInfo.length == 0){
                deferred.reject({
                    code: ErrorCode.Code.USERNOTEXISTS,
                    message: ErrorCode.Message.USERNOTEXISTS
                });
            }
            else{
                DecryptData(deferred, appIDSecretInfo, encryptData);
            }
        });
    }

    return deferred.promise;
};

module.exports = exports = new RequestCode();