var JPush = require("jpush-sdk");
var config = require('config');
var client = JPush.buildClient(config.PUSHKEY, config.PUSHSECRET);

function Send () {

}

exports.Send = Send;
