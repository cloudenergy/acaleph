/**
 * Created with JetBrains WebStorm.
 * User: christozhou
 * Date: 14-7-17
 * Time: 下午8:58
 * To change this template use File | Settings | File Templates.
 */

var appRootPath = require('app-root-path');
var logger = require(appRootPath.path + '/libs/log')("EMAcaleph");
var express = require('express');
var cookieParser = require('cookie-parser');
var app = express();

var _ = require('underscore');
var config = require('config');
var mongodb = require('./libs/mongodb');
var apiUtil = require('./api/apiUtil');
var moment = require('moment');
var cors = require('cors');
var url = require('url');

var moduleSystem = require('./module/system');

var urlPathAuth = require('./libs/urlpathAuth');

//{credentials: true}
app.use(cors());
app.use(express.bodyParser());
app.use(cookieParser());
app.use(express.session({
    secret: 'EMAPI1234567890',
    store: new express.session.MemoryStore()
}));

var ACCESS_FREE = 'NONE';
var ACCESS_BYACCOUNT = 'BYACCOUNT';
var ACCESS_BYAPPID = 'BYAPPID';

//URL访问验证
app.use(function(req, res, next){

    var goProcess = function()
    {
        req.body = req.body.data || req.body;
        next();
    };

    //是否开启了URL验证
    if( config.enableURLAuth ){
//        log.info('Start Check UrlPath Attribute');
        //从urlPath表中获取URL的属性
        var path = url.parse(req.url).pathname;

        log.info('Request URL: ', path);
        mongodb.UrlPath.findById(path, function(err, urlpath){
            //
//            log.info('UrlPath Object: ', urlpath);
            //找不到对应路径 || 路径被禁止访问，返回404
            if(err || urlpath == undefined || urlpath == null || !urlpath.enable ){
                res.status(404);
                res.send({
                    err: 404,
                    result: null
                });
                return;
            }

            var VerifyAuthType = function(userInfo)
            {
                //验证类型
                //是否允许验证
                if(!config.enableVerify){
                    return goProcess();
                }
//                log.info('Start Check CheckSum');
                switch(urlpath.authtype){
                    case ACCESS_FREE:
                    {
                        //不需要验证
                        return goProcess();
                    }
                        break;
                    case ACCESS_BYAPPID:
                    {
                        //先判断用什么来验证(APPID验证>账户验证)
                        AppID = req.body.pid;
                        AppSecret = req.body.psc;

                        User = req.body.user || req.cookies.user;
                        PathName = url.parse(req.url).pathname;
                        if(AppID != undefined || AppID != null){
                            //APPID验证
                            //获取APPID信息
                            var appIDSecret = require('./api/appidsecret/info');
                            appIDSecret.Do({appid: AppID}, function(err, data){
                                //
                                //验证APPID加密
//                            var ret = urlPathAuth.VerifyParameter(req.body, resource.value);
//                            if(!ret){
//                                //
//                                return res.send({
//                                    err: 407,
//                                    result: null
//                                });
//                            }
                                if(data.secret != AppSecret){
                                    res.status(404);
                                    return res.send({
                                        err: 404,
                                        result: 'error appsecret'
                                    });
                                }
                                req.userinfo = data;
                                return goProcess();
                            });

//                            var resourceAPI = require('./api/resource/info');
//                            log.info('Load Appid: ', AppID);
//                            resourceAPI.Do({key: AppID}, function(err, data){
//                                //
//                                if(err || data == undefined || data == null){
//                                    //
//                                    log.info('Load AppID Error: ', err, data);
//                                    res.status(err);
//                                    return res.send({
//                                        err: err,
//                                        result: data
//                                    });
//                                }
//                                else{
//                                    var resource = data;
//
//                                    //判断这个资源(这里为APPID)是否过期
//
//                                    //用户是否有权访问该节点
//                                    if(apiUtil.IsAccessAble(resource.belongto, PathName) == null){
//                                        return res.send({
//                                            err: 403,
//                                            result: "can't access "+req.url
//                                        });
//                                    }
//
//
//                                }
//                            });
                        }
                        else if(User != undefined || User != null){
                            //账户验证
                            var VerifyAccessByAccount = function(userInfo){
                                if(userInfo == null || userInfo == undefined){
                                    res.status(404);
                                    res.send({
                                        err: 404,
                                        result: 'unknow user info'
                                    });
                                    return;
                                }

                                if(apiUtil.IsAccessAble(userInfo, PathName) == null){
                                    return res.send({
                                        err: 401,
                                        result: null
                                    });
                                }

                                //验证加密
                                req.userinfo = userInfo;
                                return goProcess();
                            };

                            if(userInfo == undefined){
                                //先加载用户信息
                                log.info('Load UserInfo from: ', User);
                                var accountInfo = require('./api/account/info');
                                accountInfo.Do({'id':User}, function(err, result){
                                    if(err){
                                        //error
                                    }
                                    else{
                                        VerifyAccessByAccount(result);
                                    }
                                })
                            }
                            else{
                                VerifyAccessByAccount(userInfo);
                            }
                        }
                        else{
                            //
                            res.status(404);
                            return res.send({
                                err: 404,
                                result: "unknow authtype"
                            });
                            break;
                        }
                    }
                        break;
                    default:
                        res.status(404);
                        return res.send({
                            err: 404,
                            result: "can't find property authtype"
                        });
                        break
                }
            };

            //是否需要登录后访问
            if(urlpath.needlogin){
                //登录后访问
                //判断cookie有效性
                if(req.body.pid){
                    //
                    VerifyAuthType();
                }
                else {
                    urlPathAuth(req.url, req, res, function (err, userInfo) {
                        if (err || userInfo == null || userInfo == undefined) {
                            log.info('Cookie Auth Failed: ', err, userInfo);
                            res.status(err);
                            res.send({
                                err: err,
                                result: null
                            });
                            return;
                        }

                        VerifyAuthType(userInfo);
                    });
                }
            }
            else{
                //直接访问
                VerifyAuthType();
            }
        });
    }
    else{
        goProcess();
    }
});

/*
* system.charge 充值提醒
* */
require('./api')(app);
mongodb(function(){

    var Retry = function()
    {
        setTimeout(function(){
            setTimeout(function(){
                //
                DoFetch();
//        }, 1000 * 60 * 5);
            }, 1000);
        }, 0);
    };

    var DoFetch = function()
    {
        //获取事件进行处理
        mongodb.Event
            .find({})
            .limit(50)
            .sort({timestamp: 1})
            .exec(function(err, data){
                if(data.length ==0 || err){
                    return Retry();
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
            switch(event.type){
                case 'system':
                    moduleSystem(event.uid, event.event);
                    break;
            }
        });

        mongodb.Event.remove({_id:{$in: removeIDs}}, function(err){});
        return DoFetch();
    };

    Retry();
});

var server = app.listen(config.port, function(){
    log.info('listening at %s', server.address().port);
});