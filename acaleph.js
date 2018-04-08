'use strict';
require('include-node');
var express = require('express');
require('./libs/log')('acaleph');
var app = express();
var _ = require('underscore');
{
    global.MySQL = Include('/libs/mysql');
    global.ErrorCode = Include('/libs/errorCode');
}

// 获取联系人 
var messager = require('./api/messager');
// 加载RPC
let proto = Include('/proto/proto')();

// let offsetIndex = 0;
let cache = {};
MySQL.Load().then(
    ()=>{
        MySQL.EventQueue.sync();

        function DoFetch(offset)
        {
            //获取事件进行处理
            MySQL.EventQueue.findAll({
                limit: 50,
                order: 'timestamp ASC',
                id:{$gt: offset}
            }).then(
                data=>{
                    if(!data || data.length === 0){
                        return Retry(offset);
                    }
                    else{
                        //
                        ProcessEvents(offset, data);
                    }
                },
                err=>{
                    log.error(err);
                }
            );
        }

        function Retry(offset)
        {
            setTimeout(function(){
                setTimeout(function(){
                    //
                    DoFetch(offset);
                }, 1000);
            }, 0);
        }

        function ProcessEvents (offset, events){
            let removeIDs = [];

            let offsetIndex = 0;
            _.each(events, function(event){
                event = event.toJSON();
                // if(cache[event.id]){
                //     log.warn('events dumplicate: ', event);
                //     return;
                // }

                // cache[event.id] = true;
                if(event.id <= offsetIndex){
                    log.warn('events dumplicate: ', event);
                }
                else{
                    log.info('events processing: ', event);
                }
                removeIDs.push(event.id);
                offsetIndex = event.id;

                // 发送数据或者销毁
                messager
                    .resolve(event)
                    .then((data) => {
                        messager.send(data.target, data.msg, data.setting);
                    }, messager.discard);
            });

            MySQL.EventQueue.destroy({where:{id:{$in: removeIDs}}}).then(
                ()=>{
                    // cache = {};
                    DoFetch(offsetIndex);
                },err=>{
                    // cache = {};
                    log.error(err, removeIDs);
                    DoFetch(offsetIndex);
                }
            );
        }

        Retry(0);
    }
);

// var server = app.listen(config.port, function(){
//     log.info('listening at %s', server.address().port);
// });
