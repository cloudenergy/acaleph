var include = require('include-node');
var appRootPath = require('app-root-path');
var logger = require('./libs/log')('acaleph');
var express = require('express');
var cookieParser = require('cookie-parser');
var app = express();

var _ = require('underscore');
var config = require('config');
var mongodb = require('./libs/mongodb');
var apiUtil = require('./api/apiUtil');
var moment = require('moment');
var url = require('url');

var crypto = require('crypto');
var moment = require('moment');

var wechat = Include('/gateway/wechat');
var email = Include('/gateway/email');
var sms = Include('/gateway/sms');
var push = Include('/gateway/push');

// 获取联系人 
var messager = require('./api/messager');

wechat.Init();
email.Init();

require('./api')(app);
mongodb(function(){

    var Retry = function()
    {
        setTimeout(function(){
            setTimeout(function(){
                //
                DoFetch();
            }, 1000);
        }, 0);
    };

    var DoFetch = function()
    {
        log.info('fetching events...');
        //获取事件进行处理
        mongodb.Event
            .find({})
            .limit(50)
            .sort({timestamp: 1})
            .exec(function(err, data){
                if(!data || data.length ==0 || err){
                    // return Retry();
                }
                else{
                    //
                    ProcessEvents(data);
                    //Remove data
                }
            });
    };

    var ProcessEvents = function(events){
        //
        var removeIDs = [];

        _.each(events, function(event){
            removeIDs.push(event._id);

            // 发送数据或者销毁
            messager
                .resolve(event)
                .then((data) => {
                    return messager.send(data.target, data.msg);
                }, messager.discard);
        });
        
        mongodb.Event.remove({_id:{$in: removeIDs}}, function(err){
            DoFetch();
        });
    };

    Retry();
});

// var server = app.listen(config.port, function(){
//     log.info('listening at %s', server.address().port);
// });
