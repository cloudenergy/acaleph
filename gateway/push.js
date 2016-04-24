var JPush = require("jpush-sdk");
var config = require('config');
var client = JPush.buildClient(config.PUSHKEY, config.PUSHSECRET);

exports.Send = function Send (target, message) {
	// target - push tag id -- project/user
	// 
	client.push().setPlatform('ios', 'android')
    .setAudience(JPush.tag(target))
    .setNotification('云能源通知消息', // 全局消息名称  
    	JPush.ios('ios alert', 'sound', 1, false, {
            action: 'pay'   // 根据不同事件修改 action
        }), 
    	JPush.android('android alert', null, 1, {
            action: 'pay'   // 同上
        })
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
