'use strict';
require('include-node');
const express = require('express');
require('./libs/log')('acaleph');
Include('/libs/log')("acaleph");

const app = express();
const _ = require('underscore');
{
    global.MySQL = Include('/libs/mysql');
    global.ErrorCode = Include('/libs/errorCode');
}

// 获取联系人 
const messager = require('./api/messager');
//加载RPC
const proto = Include('/proto/proto')();

MySQL.Load().then(
    ()=>{

        function DoFetch(offset)
        {
            //获取事件进行处理
            MySQL.EventQueue.findAll({
                limit: 5,
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
            setTimeout(()=>{
                setImmediate(()=>{
                    DoFetch(offset);
                });
            }, 5000)
        }

        function ProcessEvents (offset, events){
            let removeIDs = [];

            log.info('process events: ', offset);
            let offsetIndex = offset;
            _.each(events, function(event){
                event = event.toJSON();
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
                    DoFetch(offsetIndex);
                },err=>{
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
