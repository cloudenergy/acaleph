var JPush = require("jpush-sdk");
var config = require('config');
var client = JPush.buildClient(config.PUSHKEY, config.PUSHSECRET);

// target : user_2132010105 / project_56713c947f0fd05911d382f4
// message : {
//     content : 'test',
//     title : '账户充值推送通知：您云能源账户已成功充值220元人民币，查看账户详情'
// }

exports.Send = function Send (target, message) {
    // target - push tag id -- project/user
    // 
    client.push().setPlatform('ios', 'android')
    .setAudience(JPush.tag(target))
    .setNotification(
        JPush.ios(message.title, 'sound', 1, false, {
            action: 'CASHCHARGE'   // 根据不同事件修改 action
        }), 
        JPush.android(message.title, null, 1, {
            action: 'CASHCHARGE'   // 同上
        })
    )
    .setMessage(message.content)
    .setOptions(null, 60, null, true)
    .send(function(err, res) {
        if (err) {
            console.log(err.message);
        } else {
            console.log('Sendno: ' + res.sendno);
            console.log('Msg_id: ' + res.msg_id);
        }
    });

}