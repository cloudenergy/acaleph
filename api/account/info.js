/**
 * Created by Joey on 14-7-18.
 */

var _ = require('underscore');
var mongodb = require('../../libs/mongodb.js');
var moment = require('moment');

exports = module.exports = function(req, res, next) {
    exports.Do(req, function(err, result){
        //
        res.send({
            err: err,
            result: result
        });
    });
};

exports.Do = function(req, func)
{
    //
    var body = req.body || req;
    var returnFunction = function(err, item){
        if(err){
            func && func(err, null)
        }
        else{
            if(!_.isArray(item)){
                func && func(null, item);
            }
            else {
                var valuableItem = new Array();
                _.each(item, function (v) {
                    if (v.character) {
                        valuableItem.push(v);
                    }
                });
                func && func(null, valuableItem);
            }
        }
    };

    var accountMiddleware = new mongodb.MiddleWare(mongodb.Account);
    var characterPopulate = {
        path: 'character',
        options: {sort:{'level':-1}}
    };
    if(body.users){
        //获取指定的id数组的数据
        accountMiddleware
            .find()
            .where('_id').in(body.ids || body.users);
    }
    else if(body.id != undefined){
        //获取单个数据
        accountMiddleware
            .findOne({'_id': body.id});
    }
    else if(body.idreg || body.titlereg){
        //通过ID&账户名称模糊查找
        var orArray = new Array();
        if(body.idreg != undefined){
            orArray.push({
                '_id': new RegExp(body.idreg, "i")
            })
        }
        if(body.titlereg != undefined){
            orArray.push({
                'title': new RegExp(body.titlereg, "i")
            })
        }
        accountMiddleware.find({$or: orArray})
    }
    else if(body.id == undefined){
        //获取所有数据
        var power = req.userinfo && req.userinfo.character && req.userinfo.character.level;
        if(power == undefined){
            power = Math.pow(2,32) - 1;
        }
        characterPopulate['match'] = {'level': {$gte: power}};
        accountMiddleware.find({});

//        accountMiddleware
//            .find()
//            .or([
//                {'_id': req.userinfo._id},
//                {'character.level': {$gte: req.userinfo.level}}
//            ]);
//            .find()
//            .where('level').gt(req.userinfo.level);
    }

    accountMiddleware
        .populate('billingAccount')
        .populate(characterPopulate)
        .exec(returnFunction);
};

exports.Token = '/info';