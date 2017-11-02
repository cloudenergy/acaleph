'use strict';
/**
 * 消息解析和处理模块
 * @type {[type]}
 */

let moment = require('moment');
let mongodb = require('../libs/mongodb'),
	alias = require('../libs/alias'),
	apis = {
		email: require('../gateway/email'),
		wechat: require('../gateway/wechat'),
		app: require('../gateway/push'),
		sms: require('../gateway/sms')
	},
	events = require('../libs/events');
let _ = require('underscore');
const config = require('config');

module.exports = {
	// 获取用户信息 -todo aggregate wechat
	resolve (event) {

		return new Promise((resolve, reject) => {
			// event = event.toObject();
			let param = event.param;

			let queryMessageSetting = {
				mids: [event.type.toString()]
			};
			const projectid = param.project || param.projectid;
			if(projectid){
				queryMessageSetting.projectid = projectid;
			}
			else{
				queryMessageSetting.projectid = 'PLT';
			}

			RPC.Message.Config.List(queryMessageSetting).then(
				result=>{
					if(result.code != ErrorCode.OK ){
						return reject(result);
					}

					if(_.isArray(result.result)){
						return reject(ErrorCode.ack(ErrorCode.NOTSUPPORT, result));
					}

					const setting = _.omit(result.result, ['mid', 'projectid']);
					MySQL.Account
						.findOne({
							where: {
								$or: [
									{uid: param.to || param.account || param.uid},
									{user: param.to || param.account || param.uid}
								],
								timedelete: 0
							},
							limit: 1
						})
						.then(
							user=>{
								if(!user){
									log.error(param, 'can not find');
								}
								else {
									resolve({
										target: MySQL.Plain(user),
										msg: event,
										setting: setting
									});
								}
							},
							err=>{
								reject(err);
							}
						);
				}
			);
		});
	},

	// 用户用户 APP tag 
	getApp (event) {
		log.debug('get event for app: ', event);
	},

	// 获取微信信息
	getWechat (user, event, eventName) {
		let	param = event.param;
		// 根据 gateway 将数据传入 pipeline;

        return new Promise((resolve, reject) =>{
            MySQL.WXOpenIDUser
                .findAll({
                    where: {
                        user: user.user
                    }
                })
                .then(
                    result=>{
                        // log.debug('wechat user ', user, data);
						let wx = [];
						result.map(r=>{
							wx.push(MySQL.Plain(r));
						});


                        resolve(
                            {
                                gateway: 'wechat',
                                target: wx,
                                msg: {
                                    event: eventName,
                                    data: param
                                }
                            }
						);
                    },err=>{
                        log.error('wechat user get error: ', err, user);
                        reject(err);
                    }
                );
        });
        //
		// return getWechat(user)
		// 	.then((wx) => {
		// 		return {
		// 			gateway: 'wechat',
		// 			target: wx,
		// 			msg: {
		// 				event: eventName,
		// 				data: param
		// 			}
		// 		};
		// 	});
	},

	send (user, param, settings) {
		let destroy = true;
		// log.info('sending: ', user, ' params: ', param);
		param.param.user = user.user;

		if (!user) {
			throw new Error("User must not be null");
		}

		let type = param.type,
			eventName = alias[`event:${type}`],
			email = user.email;
		if(param.timestamp){
			param.param.time = param.timestamp;///moment.unix(param.timestamp).toDate();
		}

		_.map(settings, (enable, channel)=>{
			if(!enable){
				return;
			}

			switch(channel){
				case 'email':
                    this.pipeline('email', email, {
                        event: eventName,
                        template: events[eventName],
                        data: param
                    });
					break;
				case 'app':
                    this.pipeline('push', param, eventName);
					break;
				case 'sms':
                    let doc = Object.assign({}, param.param);
                    doc.mobile = user.mobile;
                    // 如果uid 不是 手机号 则不发送
                    this.pipeline('sms', doc, eventName);
					break;
				case 'wechat':
                    this.getWechat(user, param, eventName)
                        .then((data)=> {
                            try{
                                this.pipeline(data.gateway, data.target, data.msg);
                            }catch(e){
                                log.error('get wechat exception: ', e, param, eventName, data);
                            }
                        });
					break;

			}
		});
			
		return destroy;
	},

	pipeline (gateway, target, msg) {
		// log.warn('pipeline mesage : ', gateway, msg.event);

		if(config.debug){
			return log.debug(gateway, target, msg);
		}

		try{
			if(_.isArray(target)){
				target.forEach(v=>{
						let api = apis[gateway];
						return api.Send(v, msg);
					})
			}
			else{
				let api = apis[gateway];
				return api.Send(target, msg);
			}
		}catch(e){
			log.error('pipeline exception: ', e, gateway, target, msg);
		}
	},

	discard (event) {
		log.error('discard: ', event);
	}
};