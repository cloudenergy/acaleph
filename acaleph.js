'use strict';
require('include-node');
var express = require('express');
require('./libs/log')('acaleph');
var app = express();
var _ = require('underscore');
var mongodb = require('./libs/mongodb');
{
    global.MySQL = Include('/libs/mysql');
    global.ErrorCode = Include('/libs/errorCode');
}

// 获取联系人 
var messager = require('./api/messager');
//加载RPC
let proto = Include('/proto/proto')();

require('./api')(app);
mongodb(function(){

    MySQL.Load().then(
        ()=>{
            MySQL.EventQueue.sync();

            function DoFetch()
            {
                //获取事件进行处理
                MySQL.EventQueue.findAll({
                    limit: 50,
                    order: 'timestamp ASC'
                }).then(
                    data=>{
                        if(!data || data.length === 0){
                            return Retry();
                        }
                        else{
                            //
                            ProcessEvents(data);
                        }
                    },
                    err=>{
                        log.error(err);

                    }
                );
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
                var removeIDs = [];

                _.each(events, function(event){
                    log.info('events processing: ', MySQL.Plain(event));
                    removeIDs.push(event.id);

                    // 发送数据或者销毁
                    messager
                        .resolve(event)
                        .then((data) => {
                            let del = messager.send(data.target, data.msg, data.setting);
                        }, messager.discard);
                });

                MySQL.EventQueue.destroy({where:{id:{$in: removeIDs}}}).then(
                    ()=>{
                        DoFetch();
                    },err=>{
                        log.error(err, removeIDs);
                        DoFetch();
                    }
                );
            }

            Retry()
        }
    );
});

// var server = app.listen(config.port, function(){
//     log.info('listening at %s', server.address().port);
// });
