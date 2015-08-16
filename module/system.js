/**
 * Created by Joey on 2015/3/26.
 */
var api = require('../libs/api');
var mongodb = require('../libs/mongodb');
var _ = require('underscore');

var SystemEvent = {
    charge: function(uid, event){
        /*充值通知
         subevent: 'charge',
         amount: charge cash
         */
        var TEMPLATE_ID = 'HndPGtslDiD836SsdNp-yrCW8auMe0dMPFCaRILAn9w';
        api.EMAPI('/account/info', {id: uid}).then(
            function(result){
                log.info('/account/info', result);
                if(result.err){

                }
                else{
                    var account = result.result;

                    api.EMAPI('/wxaccount/info', {users: uid}).then(
                        function(result){
                        log.info('/wxaccount/info', result);
                        if(result.err){}
                        else{
                            _.each(result.result, function(wxaccount){
                                var message = {
                                    url: '',
                                    touser: wxaccount._id,
                                    template_id: TEMPLATE_ID,
                                    topcolor: "#FF0000",
                                    data: {
                                        first: {
                                            "value":"已经成功充值",
                                            "color":"#173177"
                                        },
                                        accountType: {
                                            "value":"账户余额",
                                            "color":"#173177"
                                        },
                                        account: {
                                            "value": account.billingAccount.cash.toFixed(2),
                                            "color":"#173177"
                                        },
                                        amount: {
                                            "value": event.amount.toFixed(2),
                                            "color":"#173177"
                                        },
                                        result: {
                                            "value":"正常",
                                            "color":"#173177"
                                        },
                                        remark: {
                                            "value":"",
                                            "color":"#173177"
                                        }
                                    }
                                };
                                var templateMessage = {
                                    platformid: wxaccount.platformid,
                                    message: message
                                };
                                //
                                api.queryWXAPI('/templatepush', templateMessage, function(result){
                                    log.info(result);
                                });
                            });
                        }
                    });
                }
            }
        );
    },
    alert: function(uid, event){
        /*账户余额不足
         subevent: 'alert',
         //amount: account's amount
         */
        var TEMPLATE_ID = 'iknMsSJLqZYz5pn24z-JIAwRgnD08nKXuOGIrpiB4vA';
        api.EMAPI('/wxaccount/info', {users: uid}).then(
            function(result){
                log.info('/wxaccount/info', result);
                if(result.err){}
                else{
                    _.each(result.result, function(wxaccount){
                        var message = {
                            url: '',
                            touser: wxaccount._id,
                            template_id: TEMPLATE_ID,
                            topcolor: "#FF0000",
                            data: {
                                first: {
                                    "value":"您当前账号余额不足",
                                    "color":"#173177"
                                },
                                keyword1: {
                                    "value":uid,
                                    "color":"#173177"
                                },
                                keyword2: {
                                    "value": event.amount.toFixed(2),
                                    "color":"#173177"
                                },
                                remark: {
                                    "value":"",
                                    "color":"#173177"
                                }
                            }
                        };
                        var templateMessage = {
                            platformid: wxaccount.platformid,
                            message: message
                        };
                        //
                        api.queryWXAPI('/templatepush', templateMessage, function(result){
                            log.info(result);
                        });
                    });
                }
            });
    },
    balance: function(uid, event){
        /*账户余额变动
         subevent: 'balance',
         balance: alternative balance
         */
        var TEMPLATE_ID = 'jrGyI9AS0PKUgbVPPtWz0yOa4KQoLn50ddu_gn9m3ZM';
        api.EMAPI('/account/info', {id: uid}).then(
            function(result){
                if(result.err){

                }
                else{
                    var user = result.result;
                    if(!user){
                        log.error('can not find user: ', uid);
                        return;
                    }

                    api.EMAPI('/wxaccount/info', {users: user._id}).then(
                        function(result){
                            log.info('/wxaccount/info', result);
                            if(result.err){}
                            else{
                                _.each(result.result, function(wxaccount){
                                    var message = {
                                        url: '',
                                        touser: wxaccount._id,
                                        template_id: TEMPLATE_ID,
                                        topcolor: "#FF0000",
                                        data: {
                                            first: {
                                                "value":"账号余额变动",
                                                "color":"#173177"
                                            },
                                            //账户类型
                                            keyword1: {
                                                "value":"普通账户",
                                                "color":"#173177"
                                            },
                                            //操作类型
                                            keyword2: {
                                                "value": event.operatetype,
                                                "color":"#173177"
                                            },
                                            //操作内容
                                            keyword3: {
                                                "value": event.operatecontent,
                                                "color":"#173177"
                                            },
                                            //变动额度
                                            keyword4: {
                                                "value": event.balance,
                                                "color":"#173177"
                                            },
                                            //账户余额
                                            keyword5: {
                                                "value": user.billingAccount.cash,
                                                "color":"#173177"
                                            }
                                        }
                                    };
                                    var templateMessage = {
                                        platformid: wxaccount.platformid,
                                        message: message
                                    };
                                    //
                                    api.queryWXAPI('/templatepush', templateMessage, function(result){
                                        log.info('/templatepush', result);
                                    });
                                });
                            }
                        });
                }
            }
        );
    }
};

module.exports = exports = function(uid, event){
//    return SystemEvent[event.subevents];
    if(SystemEvent[event.subevent]){
        SystemEvent[event.subevent](uid, event);
    }
};