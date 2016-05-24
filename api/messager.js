'use strict';
/**
 * 消息解析和处理模块
 * @type {[type]}
 */

var mongodb = require('../libs/mongodb'),
	mongo = require('mongoose'),
	alias = require('../libs/alias'),
	events = require('../libs/events');

let getWechat = (uid) => {
	return new Promise((resolve, reject) =>{
		mongodb.WXOpenIDUser
			.findOne({
				user: uid
			})
			.exec((err, data) => {
				console.log('get wx: ', err, data, uid)

				if (err || !data) {
					reject(err)
				}else{
					resolve(data);
				}
			})
	})
}

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
					})
			}catch(e){
				console.log('e: ', e);
			}
			
		});
	},

	// 用户用户 APP tag 
	getApp (event) {

	},

	// 获取微信信息
	getWechat (event) {
		let	param = event.get('param');

		// 根据 gateway 将数据传入 pipeline;

		return getWechat(param.uid)
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

		let type = param.get('type'),
			eventName = alias[`event:${type}`],
			email = user.get('email'),
			event = events[eventName];
		let	eventGateway = event.gateway;
		// 解析用户设置渠道 和 事件允许渠道

		if (eventGateway.indexOf('email') != -1 && email) {
			this.pipeline('email', email, param);
		}

		// 判断是否包含微信请求
		if (eventGateway.indexOf('wechat') == -1) {
			return
		}

		return

		this.getWechat(playload.msg)
			.then((data)=> {
				try{
					this.pipeline(data.gateway, data.target, data.msg);
				}catch(e){
					console.log('e: ', e);
				}
			});
	},

	pipeline (gateway, target, msg) {
		console.log('pipeline mesage : ', gateway, msg);

		try{
			let api = require(`../gateway/${gateway}`);
			return api.Send(target, msg);
		}catch(e){
			console.log('e:', e);
		}
	},

	discard (event) {
		console.log('failded: ', err);
	}
}