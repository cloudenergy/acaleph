'use strict';
/**
 * 消息解析和处理模块
 * @type {[type]}
 */

var mongodb = require('../libs/mongodb'),
	mongo = require('mongoose');

module.exports = {
	resolve (event) {
		
		return new Promise((resolve, reject) => {
			let param = event.get('param')
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
		});
	},

	parse (user, event) {
		console.info('parse event now: ', event.id, event.get('eid'));
		let type = event.id;
	},

	send (playload) {
		// 解析用户设置渠道 和 事件允许渠道
		this.parse(playload.target, playload.msg);
	},

	discard (event) {
		console.log('failded: ', err);
	}
}