var api = require('../libs/api');

module.exports = exports = function(){};

exports.Init = function () {
};

exports.Send = function(target, message){
    try{
        message = JSON.parse(message);
    }
    catch(e){
        message = {};
    }

    var templateMessage = {
        platformid: target,
        message: message
    };
    //
    api.queryWXAPI('/templatepush', templateMessage, function(result){
        log.info(result);
    });
};

