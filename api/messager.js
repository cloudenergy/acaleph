'use strict';
/**
 * 消息解析和处理模块
 * @type {[type]}
 */

var mongodb = require('../libs/mongodb'),
	alias = require('../libs/alias'),
	apis = {
		email: require('../gateway/email'),
		wechat: require('../gateway/wechat'),
		push: require('../gateway/push'),
		sms: require('../gateway/sms')
	},
	events = require('../libs/events');

let getWechat = (uid) => {
	return new Promise((resolve, reject) =>{
		mongodb.WXOpenIDUser
			.findOne({
				user: uid
			})
			.exec((err, data) => {
				console.log('get wx: ', err, data, uid);

				if (err || !data) {
					reject(err);
				}else{
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
				let param = event.get('param');
				mongodb.Account
					.findOne({
						_id : param.uid || param.account
					})
					.limit(1)
					.exec((err, data) => {
						if (err) {
							reject(err);
						}else{
							resolve({
								target: data,
								msg: event
							});
						}
					});
			}catch(e){
				console.log('e: ', e);
			}
			
		});
	},

	// 用户用户 APP tag 
	getApp (event) {
		log.info('get event for app: ', event);
	},

	// 获取微信信息
	getWechat (event, eventName) {
		let	param = event.get('param');
		log.info('get wechat: ', event);
		// 根据 gateway 将数据传入 pipeline;

		return getWechat(param.uid || param.account)
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
			var type = param.get('type'),
				eventName = alias[`event:${type}`],
				email = user.get('email'),
				event = events[eventName];
			var	eventGateway = event.gateway;
		} catch(e) {
			// statements
			console.log('exception: ', e);
		}
	
		// 解析用户设置渠道 和 事件允许渠道
		if (eventGateway.indexOf('email') !== -1 && email) {
			this.pipeline('email', email, {
				event: eventName,
				template: event,
				data: param
			});
		}

		if (eventGateway.indexOf('app') !== -1) {
			destroy = false;
			this.pipeline('push', param, eventName);
		}

		// 判断是否包含微信请求
		if (eventGateway.indexOf('wechat') === -1) {
			return destroy; 
		}

		this.getWechat(param, eventName)
			.then((data)=> {
				try{
					this.pipeline(data.gateway, data.target, data.msg);
				}catch(e){
					console.log('e: ', e);
				}
			});
			
		return destroy;
	},

	pipeline (gateway, target, msg) {
		log.warn('pipeline mesage : ', gateway, msg.event);

		try{
			let api = apis[gateway];
			return api.Send(target, msg);
		}catch(e){
			console.log('e:', e);
		}
	},

	discard (event) {
		console.log('failded: ', event);
	}
}