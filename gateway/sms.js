var moment = require('moment');
var crypto = require('crypto');
var https = require('https');

var SoftVersion = '2013-12-26';
var AccountSID = '8a48b55150a898370150ac4c830b088b';
var AccountToken = '817907edfb484329a68e2e09f22576f1';

var AppID = '8a48b55150a898370150ac4dbcf608a1';
var AppToken = 'e7748afd4a2e8754cef5332b3db18734';

module.exports = exports = function(){};

function MD5(plain)
{
    return crypto.createHash('md5').update(plain).digest('hex').toUpperCase();
}

function EncodeAuthorization()
{
    var timeStamp = moment();
    var plainAuth = AccountSID + ":" + timeStamp.format('YYYYMMDDHHmmss');
    //console.log(plainAuth);
    return new Buffer(plainAuth).toString('base64');
}

function PackageBody(to, data)
{
    var body = {
        "to": to,
        "appId": AppID,
        "templateId":"1",
        "datas":data}
    return body;
}

exports.Send = function (number, content)
{
    //
    var timeStamp = moment();
    var plainSignature = AccountSID + AccountToken + timeStamp.format('YYYYMMDDHHmmss');
    var encryptSignature = MD5(plainSignature);
    var url = "/"+SoftVersion+"/Accounts/"+AccountSID+"/SMS/TemplateSMS?sig="+encryptSignature;

    var body = PackageBody('13777494316', ["A","B"]);
    var contentLength = JSON.stringify(body).length;

    var Header = {
        "Accept": "application/json"
        , "Content-type": "application/json;charset=utf-8;"
        , "Content-Length": contentLength
        , "Authorization": EncodeAuthorization()
    };

    var options = {
        host: "sandboxapp.cloopen.com"
        , port: "8883"
        , path: url
        , method: 'POST'
        , headers: Header
    };
    console.log(options);
    console.log(body);
    var req = https.request(options, function(res){
        var data='';
        res.on('data', function(chunk){
            data += chunk;
        });
        res.on('end', function(){
           console.log(data);
        });
    });
    req.on('error', function(e){
        log.error(e);
    });
    req.write(JSON.stringify(body));
    req.end();
};