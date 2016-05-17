var gateway = require('./gateway/email'),
	wechat = require('./gateway/wechat'),
	emailComposer = require('./libs/email'),
	wxComposer = require('./libs/wechat'),
	events = require('./libs/events'),
	_ = require('underscore'),
	fs = require('fs');

var template_data = {
		data: {
			name: '迪诺水镇',
			account: '2132010105',
			project: '迪诺水镇',
			time_range: '2016年5月',
			bills: {
				electricity: '116',
				property: '583'
			},
			amount: '123112.1',
			balance: '12992.1',
			devices: [
				{name: '设备1', type: '通讯故障', time: '2016-05-01 12:00', location:'A区', code: 'COMM'}
			],
			list: [
				{title: '1', count: 10, amount: 1656},
				{title: '2', count: 12, amount: 5324}, 
				{title: '3', count: 1, amount: 1295}
			]
		},
		device: {
			name: '迪诺水镇', 
			device: '设备1',
			type: '通讯故障', 
			time: '2016-05-01 12:00', 
			location:'A区', 
			code: 'COMM'
		}
	};

var wechat_message = {
    url: '',
    touser: "oVO8Aj7-yPPeVSbeh3KdJUQ8dGoQ",
    template_id: "04yhtxxhktLnzzp4kPQWZzxTYYdXhCA3cytTe_sx8uo",
    data: {
        first: {
            "value":"您好,你的账户余额发生变动,信息如下",
            "color":"#173177"
        },
        //账户类型
        keyword1: {
            "value":"普通账户",
            "color":"#173177"
        },
        //操作类型
        keyword2: {
            "value": 'operate',
            "color":"#173177"
        },
        //操作内容
        keyword3: {
            "value": 'content',
            "color":"#173177"
        },
        //变动额度
        keyword4: {
            "value": 'amount',
            "color":"#173177"
        }
    }
};

wechat_message = wxComposer.compile(template_data.device, 'ntf_balanceinsufficient');
wechat_message.touser = "oVO8Aj7-yPPeVSbeh3KdJUQ8dGoQ";

wechat.Send('gh_e8d031d150e4', JSON.stringify(wechat_message));

_.each(events, function(val, key){
	template_data.target = val.email.target || 'business';

	var eventType = key,
	template = emailComposer.compile(eventType, template_data);
 
	var mail = {
			title: val.title,
			content: template,
			attachment: []
		},
		target = '910599438@qq.com, 21834494@qq.com, 78110695@qq.com, 50923132@qq.com';

	// fs.writeFile('./test.html', template, 'utf8');
	gateway.Send(target, JSON.stringify(mail));
})
