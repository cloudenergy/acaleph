var JPush = require("jpush-sdk");
var config = require('config');
var client = JPush.buildClient(config.PUSHKEY, config.PUSHSECRET);

exports.Send = function Send (target, message) {
	// target - push tag id -- project/user
	// 
	client.push().setPlatform('ios', 'android')
    .setAudience(JPush.tag(target))
    .setNotification(message.title, 
    	JPush.ios('ios alert'), 
    	JPush.android('android alert', null, 1)
    )
    .setMessage(message.content)
    .setOptions(null, 60)
    .send(function(err, res) {
        if (err) {
            console.log(err.message);
        } else {
            console.log('Sendno: ' + res.sendno);
            console.log('Msg_id: ' + res.msg_id);
        }
    });

}
