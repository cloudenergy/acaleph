'use strict';
/**
 * 消息解析和处理模块
 * @type {[type]}
 */

var moment = require('moment');
var mongodb = require('../libs/mongodb'),
	alias = require('../libs/alias'),
	apis = {
		email: require('../gateway/email'),
		wechat: require('../gateway/wechat'),
		push: require('../gateway/push'),
		sms: require('../gateway/sms')
	},
	events = require('../libs/events');
var _ = require('underscore');

let getWechat = (user) => {
	return new Promise((resolve, reject) =>{
		mongodb.WXOpenIDUser
			.find({
				user: user.user
			})
			.exec((err, data) => {
				if (err || !data) {
					log.error('wechat user get error: ', err, user);
					reject(err);
				}else{
					log.debug('wechat user ', user, data);
					resolve(data);
				}
			});
	});
};

module.exports = {
	// 获取用户信息 -todo aggregate wechat
	resolve (event) {

		return new Promise((resolve, reject) => {
			try{
				event = event.toObject();
				let param = event.param;
				MySQL.Account
					.findOne({
						where: {
                            $or: [
                                {uid: param.to || param.account},
                                {user: param.to || param.account}
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
                                    msg: event
                                });
                            }
						},
						err=>{
                            reject(err);
						}
					);
			}catch(e){
				log.error('get user info exception: ', e, event);
			}
			
		});
	},

	// 用户用户 APP tag 
	getApp (event) {
		log.debug('get event for app: ', event);
	},

	// 获取微信信息
	getWechat (user, event, eventName) {
		let	param = event.param;
		log.info('get wechat: ', event);
		// 根据 gateway 将数据传入 pipeline;

		return getWechat(user)
			.then((wx) => {
				return {
					gateway: 'wechat',
					target: wx,
					msg: {
						event: eventName,
						data: param
					}
				};
			});
	},

	send (user, param) {
		let destroy = true;
		log.info('sending: ', user, ' params: ', param);

		if (!user) {
			throw new Error("User must not be null");
		}

		try {
			var type = param.type,
				eventName = alias[`event:${type}`],
				email = user.email,
				event = events[eventName];
			var	eventGateway = event.gateway;
		} catch(e) {
			// statements
			log.error('sending exception: ', e, user, param);
		}
		if(param.timestamp){
			param.param.time = param.timestamp;///moment.unix(param.timestamp).toDate();
		}
	
		// 解析用户设置渠道 和 事件允许渠道
		if (eventGateway.indexOf('email') !== -1 && email) {
			this.pipeline('email', email, {
				event: eventName,
				template: event,
				data: param
			});
		}

		if (~eventGateway.indexOf('sms') && user.mobile) {
			let doc = Object.assign({}, param.param);
			doc.mobile = user.mobile;
			// 如果uid 不是 手机号 则不发送
			this.pipeline('sms', doc, eventName);
		}

		if (~eventGateway.indexOf('app')) {
			destroy = false;
			this.pipeline('push', param, eventName);
		}

		// 判断是否包含微信请求
		if (eventGateway.indexOf('wechat') === -1) {
			return destroy; 
		}

		this.getWechat(user, param, eventName)
			.then((data)=> {
				try{
					this.pipeline(data.gateway, data.target, data.msg);
				}catch(e){
					log.error('get wechat exception: ', e, param, eventName, data);
				}
			});
			
		return destroy;
	},

	pipeline (gateway, target, msg) {
		// log.warn('pipeline mesage : ', gateway, msg.event);

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