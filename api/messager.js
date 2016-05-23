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
	resolve (event) {
		return new Promise((resolve, reject) => {
			try{
				let param = event.get('param');
				mongodb.Account
					.findOne({
						_id : "1-1F-A-003" //event.param.uid || event.param.account
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

	parse (user, event) {

		let type = event.get('type'),
			param = event.get('param'),
			eventName = alias[`event:${type}`];
		let	eventGateway = events[eventName].gateway;

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

	send (playload) {
		// 解析用户设置渠道 和 事件允许渠道
		this.parse(playload.target, playload.msg)
			.then((data)=> {
				try{
					this.pipepline(data.gateway, data.target, data.msg);
				}catch(e){
					console.log('e: ', e);
				}
			});
	},

	pipepline (gateway, target, msg) {
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