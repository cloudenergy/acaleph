'use strict';
/**
 * 通过 alias 发送推送
 * 
 * @type {[type]}
 */
var JPush = require("jpush-sdk");
var config = require('config'),
    events = require('../libs/events');
var client = JPush.buildClient(config.PUSHKEY, config.PUSHSECRET);

// target : user_2132010105 / project_56713c947f0fd05911d382f4
// message : {
//     content : 'test',
//     title : '账户充值推送通知：您云能源账户已成功充值220元人民币，查看账户详情'
// }

exports.Send = function Send (doc, eventname) {

    let params = doc.get('param'),
        eventtype = doc.get('type'),
        targetId = params.uid || params.account,
        target = `user_${targetId}`,
        production = config.push === 'production',
        message = {
            title: events[eventname] && events[eventname].title,
            content: params,
            param: {
                type: eventtype,
                param: params
            }
        };

    log.debug('发送消息', message);
    // 
    client.push().setPlatform('ios', 'android')
    .setAudience(JPush.tag(target))
    .setNotification(
        message.title,
        JPush.ios(message.title, 'sound', 1, false, {
            action: 'CASHCHARGE',   // 根据不同事件修改 action
            param: JSON.stringify(message.param)
        }), 
        JPush.android(message.title, null, 1, {
            action: 'CASHCHARGE',   // 同上
            param: JSON.stringify(message.param)
        })
    )
    .setMessage('123' || message.content)
    .setOptions(null, 60, null, production)
    .send(function(err, res) {
        if (err) {
            log.debug('推送发送失败', err.message);
        } else {
             log.debug('推送发送成功 Sendno: ' + res.sendno, 'Msg_id: ', res.msg_id);
        }
    });

}