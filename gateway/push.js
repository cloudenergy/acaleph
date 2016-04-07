var JPush = require("jpush-sdk");
var config = require('config');
var client = JPush.buildClient(config.PUSHKEY, config.PUSHSECRET);

exports.Send = function Send () {

}
