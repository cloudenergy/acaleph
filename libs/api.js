var http = require('http');
var urlParse = require('url');
var https = require('https');
var crypto = require('crypto');
var _ = require('underscore');

var config = require('config');
var Q = require('q');

//exports.APPID = 3;
//var APPID = "WX";
//var APPSECRET = "mwnHa0jEaJ2hLvQ31JBUj6jkipefiiB7";
var APPID = config.APPID;
var APPSECRET = config.APPSECRET;
var API_URL = '/api';

var APIHOST = config.APIHOST;
var APIPORT = config.APIPORT;
var HEADER = {
    "Content-type": "application/json"
    , "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    , "Connection": "keep-alive"
    , "Accept-Encoding": "identity"
    , "User-Agent": "wx"
};

//WX API
var WX_HOST = config.WXAPIHOST;
var WX_PORT = config.WXAPIPORT;
var WX_API_URL = '/api';
var WX_HEADER = {
    "Content-Type":"application/json; charset=utf-8",
    Accept:"*/*",
    "Accept-Encoding":"gzip, deflate",
    "Accept-Language":"zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4",
    "Cache-Control":"no-cache"
};

function HttpRequest(host, port, header, method, url, data, func)
{
    //
    if(_.isObject(data)){
        data = JSON.stringify(data);
    }
    header['Content-Length'] = Buffer.byteLength(data, 'utf8');
    var options = {
        host: host
        , port: port
        , path: url
        , method: method
        , headers: header
    };

    log.info(data);
    log.info(options);

    var req = http.request(options, function(res){
        var data='';
        res.on('data', function(chunk){
            data += chunk;
        });
        res.on('end', function(){
            if(func != undefined){
                func(data);
            }
        });
    });
    req.on('error', function(e){
        log.info(method+" "+host+":"+port+url+':Err - '+e);
    });
    req.write(data);
    req.end();
}

function generatePostRequest(kv, secretKey)
{
    kv['_time'] = Math.round(Date.now() / 1000);

    var sortArray = new Array();
    for(key in kv){
        sortArray.push(key)
    }
    sortArray.sort();

    newMap = {}
    for(key in sortArray){
        pKey = sortArray[key];
        pValue = kv[pKey];
        newMap[pKey] = pValue;
    }

    plainText = secretKey;
    for(key in newMap){
        plainText += key.toString() + newMap[key].toString();
    }
    plainText += secretKey;

//    log.info(plainText);
    var hash = require('crypto').createHash('md5');
    var hashResult = hash.update(plainText).digest('hex');
    newMap['_sign'] = hashResult;

//    log.info(newMap);
    return newMap;
}

exports.queryWXAPI = function(url, postValue, func)
{
    //
    var requestURL = WX_API_URL + url;
    HttpRequest(WX_HOST, WX_PORT, WX_HEADER, 'POST', requestURL, postValue, function(data){
        func && func(data);
    });
};

exports.Http = function(url, data, func)
{
    //
    var url = urlParse.parse(url);
    HttpRequest(url.hostname, url.port, {}, 'POST', url.pathname, data, function(data){
        func && func(data);
    });
};

exports.Https = function(method, url, postData, func)
{
    var header = HEADER;
    if(typeof(postData) == 'object'){
        postData = JSON.stringify(postData);
    }

    var urlObj = urlParse.parse(url);
    header['Content-Length'] = postData.length;
    var options = {
        host: urlObj.host
        , port: urlObj.port
        , path: urlObj.path
        , method: method
    };

    var req = https.request(options, function(res){
//        log.info("statusCode: ", res.statusCode);
//        log.info("headers: ", res.headers);

        var data='';
        res.on('data', function(chunk){
            data += chunk;
        });
        res.on('end', function(){
            if(func != undefined){
                func(data);
            }
        });
    });
    req.on('error', function(e){
        log.info(method+" "+host+":"+port+url+':Err - '+e);
    });
    req.write(postData);
    req.end();
};

exports.EMAPI = function(path, parameters)
{
    var deferred = Q.defer();

    parameters['pid'] = APPID;
    parameters['psc'] = APPSECRET;

    var parametersString = JSON.stringify(parameters);
    var options = {
        host: APIHOST
        , port: APIPORT
        , path: API_URL+path
        , method: 'POST'
        , headers: HEADER
    };
    options.headers['Content-Length'] = parametersString.length;

//    log.info(parameters);
//    log.info(options);

    var req = http.request(options, function(res){
        var data='';
        res.on('data', function(chunk){
            data += chunk;
        });
        res.on('end', function(){
            try {
                var obj = JSON.parse(data);
                deferred.resolve(obj);
            }
            catch(err){
                log.info('Parse Json Error: ', err, data);
                deferred.reject(err);
            }
        });
    });
    req.on('error', function(e){
        log.info(APIHOST+":"+APIPORT+path+':Err - '+e);
        deferred.reject(e);
    });
    req.write(parametersString);
    req.end();

    return deferred.promise;
};