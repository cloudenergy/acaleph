let api = require('../libs/api'),
    composer = require('../libs/wechat');

module.exports = exports = function(){};

exports.Init = function () {
};

exports.Send = function(target, message){
    log.debug('wechat ', target, message);
    let msg = composer.compile(message.data, message.event);

        msg.touser = target._id;
    var templateMessage = {
        platformid: target.platformid,
        message: msg
    };
    //
    api.queryWXAPI('/templatepush', templateMessage, function(result){
        log.info('wechat', result, message);
    });
};

