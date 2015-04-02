/**
 * Created by Joey on 2015/3/26.
 */
var api = require('../libs/api');
var mongodb = require('../libs/mongodb');
var _ = require('underscore');

var SystemEvent = {
    charge: function(event){
        /*充值通知
         subevent: 'charge',
         billingaccount: charge billingAccount,
         amount: charge cash
         */
        var TEMPLATE_ID = 'HndPGtslDiD836SsdNp-yrCW8auMe0dMPFCaRILAn9w';
        api.EMAPI('/account/info', {billingaccount: event.billingaccount}).then(
            function(result){
                console.log('/account/info', result);
                if(result.err){

                }
                else{
                    var users = {};
                    var userIDs = [];
                    _.each(result.result, function(account){
                        userIDs.push(account._id);
                        users[account._id] = account;
                    });

                    api.EMAPI('/wxaccount/info', {users: userIDs}).then(
                        function(result){
                        console.log('/wxaccount/info', result);
                        if(result.err){}
                        else{
                            _.each(result.result, function(wxaccount){
                                var account = users[wxaccount.user._id];
                                if(!account) {
                                    return;
                                }
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
                                            "value": account.billingAccount.cash.toString(),
                                            "color":"#173177"
                                        },
                                        amount: {
                                            "value": event.amount.toString(),
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
                                    console.log(result);
                                });
                            });
                        }
                    });
                }
            }
        );
    },
    amount: function(event){
        /*账户余额变动
         subevent: 'amount',
         billingaccount: amount billingAccount,
         //amount: account's amount
         */
        var TEMPLATE_ID = 'iknMsSJLqZYz5pn24z-JIAwRgnD08nKXuOGIrpiB4vA';
        api.EMAPI('/account/info', {billingaccount: event.billingaccount}).then(
            function(result){
                console.log('/account/info', result);
                if(result.err){

                }
                else{
                    var user = result.result[0];
                    if(!user.billingAccount.alerthreshold){
                        console.log('billingAccount: ', event.billingaccount, ' alerthreshold is null');
                        return;
                    }

                    api.EMAPI('/wxaccount/info', {users: user._id}).then(
                        function(result){
                            console.log('/wxaccount/info', result);
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
                                                "value":user._id,
                                                "color":"#173177"
                                            },
                                            keyword2: {
                                                "value": user.billingAccount.cash.toString(),
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
                                        console.log(result);
                                    });
                                });
                            }
                        });
                }
            }
        );
    }
};

module.exports = exports = function(event){
//    return SystemEvent[event.subevents];
    if(SystemEvent[event.subevent]){
        SystemEvent[event.subevent](event);
    }
};