'use strict';
var express = require('express');
require('./libs/log')('acaleph');
var app = express();

var _ = require('underscore');
var mongodb = require('./libs/mongodb');

// 获取联系人 
var messager = require('./api/messager');

require('./api')(app);
mongodb(function(){
    function DoFetch()
    {
        //获取事件进行处理
        mongodb.Event
            .find({})
            // .skip(1)
            .limit(50)
            .sort({timestamp: 1})
            .exec(function(err, data){
                if(!data || data.length === 0 || err){
                    return Retry();
                }
                else{
                    //
                    ProcessEvents(data)
                    //Remove data
                }
            });
    }

    function Retry()
    {
        setTimeout(function(){
            setTimeout(function(){
                //
                DoFetch();
            }, 1000);
        }, 0);
    }

    function ProcessEvents (events){
        console.log('events processing: ', events);
        
        var removeIDs = [];

        _.each(events, function(event){
            removeIDs.push(event._id);
            
            // 发送数据或者销毁
            messager
                .resolve(event)
                .then((data) => {
                    let del = messager.send(data.target, data.msg);
                }, messager.discard);
        });

        mongodb.Event.remove({_id:{$in: removeIDs}}, function(err){
            DoFetch();
        });
    }

    Retry()
});

// var server = app.listen(config.port, function(){
//     log.info('listening at %s', server.address().port);
// });
