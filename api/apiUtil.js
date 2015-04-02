/**
 * Created by Joey on 14-7-20.
 */
var _ = require('underscore');
var url = require('url');
var mongodb = require('../libs/mongodb');
var moment = require('moment');
var Q = require('q');

exports.LoadModule = function(server, method, module, parentPrefix)
{
    switch (method){
        case 'POST':
            server.post(parentPrefix + module.Token, module);
            break;
        case 'GET':
            server.get(parentPrefix + module.Token, module);
            break;
        case 'DELETE':
            server.del(parentPrefix + module.Token, module);
            break;
    }
}

exports.ParameterFilter = function(paramters, blackList)
{
    var setObj = {};
    var setIgnore = {
        id:'',_id:''
    }
    //Set WhiteList
    _.each(blackList, function(item){
        //
        setIgnore[item] = '';
    });

    _.map(paramters, function(v, k){
        if(setIgnore[k] == '' || v == undefined){
            return;
        }
        setObj[k] = v;
    });
    return setObj;
}

//把非null/undefined参数写入Obj中
exports.ParameterFill = function(paramList)
{
}

exports.IsAccessAble = function(user, urlpath)
{
    console.log('Accessable Of [',urlpath,'] in [',user._id,']');
    if( !user || !user.character){
        console.log("user or user's character is null");
        return null;
    }

    var pathRoute =urlpath.split('/');
    var path = user.character.rule['/'];
    for(var i in pathRoute){
        var point = pathRoute[i];
        if(point.length> 0){
            if(path[point] == undefined){
                console.log("can't find ["+point+"] in "+path);
                return null;
            }
            else{
                path = path[point];
            }
        }
    }
    return path;
};

exports.UrlPathResource = function(user, req)
{
    //
    return user.resource;
    var path = url.parse(req.url).pathname;
    if( !user || !user.character ){
        return null;
    }

    var resourceQueue = new Array();
    var pathRoute =path.split('/');
    var path = user.character.rule['/'];
    resourceQueue.push(path.resource);
    for(var i in pathRoute){
        var point = pathRoute[i];
        if(point.length> 0){
            if(path[point] != undefined){
                path = path[point];
                if(!_.isEmpty(path["_resource"])){
                    resourceQueue.push(path["_resource"]);
                }
            }
        }
    }

    if(resourceQueue.length == 0){
        return null;
    }
    else{
        return resourceQueue[resourceQueue.length-1];
    }
};

exports.ResourceUnion = function(req, reqResource, baseResource) {
    var deferred = Q.defer();
    var resultResource = {
        project: baseResource.project,
        customer: [],
        building: [],
        sensor: []
    };

    var BuildingGet = function (buildingIDs) {
        var defer = Q.defer();
        if (!buildingIDs || _.isArray(buildingIDs)) {
            return;
            defer.resolve([]);
        }
        mongodb.Building
            .find({})
            .where('_id').in(buildingIDs || [])
            .exec(function (err, item) {
                if (err) {
                    defer.reject(err);
                }
                else {
                    defer.resolve(item);
                }
            });
        return defer.promise;
    };
    var SensorGet = function (sensorIDs) {
        var defer = Q.defer();
        mongodb.Sensor
            .find({})
            .where('_id').in(sensorIDs || [])
            .exec(function (err, item) {
                if (err) {
                    defer.reject(err);
                }
                else {
                    defer.resolve(item);
                }
            });
        return defer.promise;
    };

    Q.all([
        BuildingGet(reqResource && reqResource.building || [])
        , SensorGet(reqResource && reqResource.sensor || [])
    ]).then(
        function (result) {
            //判断建筑
            _.each(result[0], function (building) {
                if (_.contains(baseResource.project, building.project)) {
                    resultResource.building.push(building._id);
                }
            });

            //判断传感器
            _.each(result[1], function (sensor) {
                if (_.contains(baseResource.project, sensor.project.toString())) {
                    resultResource.sensor.push(sensor._id);
                }
            });

            deferred.resolve(resultResource);
        }
    );

    return deferred.promise;
};

exports.findEnergy = function(energy, id, path)
{
    //
    var findEnergyByPath = function(node, pathStep, step)
    {
        if(pathStep.length <= step){
            return node;
        }
        var index = parseInt(pathStep[step]);
        if(node.childrens && node.childrens.length > index ){
            return findEnergyByPath(node.childrens[index], pathStep, step+1);
        }
        return undefined;
    }

    var node = undefined
    _.each(energy, function(e){
        if(e._id == id){
            //
            node = findEnergyByPath(e, path.split(','), 1);
        }
    });
//    return findEnergyByPath(energy, path.split(','), 0);
    return node;
}

exports.findEnergyByID = function(energy, id)
{
    //
    var findEnergyByID = function(node)
    {
        if(!node){
            return undefined;
        }

        for(var i in node){
            var e = node[i];
            if(e._id == id){
                return e;
            }
            var returnNode = findEnergyByID(e.childrens);
            if(returnNode){
                return returnNode;
            }
        }

        return undefined;
    }

    return findEnergyByID(energy);
}

exports.enumEnergyID = function(energy)
{
    var energyIDArray = new Array();
    _.each(energy, function(e){
        energyIDArray.push(e._id);
    });
    return energyIDArray;
}

exports.energyFilter = function(energy, rules)
{
    var iterationEnergyFind = function(node, stepArray, step, result)
    {
        if(stepArray.length <= step){
            return;
        }
        _.each(node, function(n, index){
            if(n.title == stepArray[step]){
                result.path.push(index);
                result.id.push(n._id);
                iterationEnergyFind(n.childrens, stepArray, step+1, result);
            }
        });
    }



    var energyResult = new Array();
    _.each(rules, function(rule){
        ruleArray = rule.split('.');
        result = {
            path: new Array(),
            id: new Array()
        };
        iterationEnergyFind(energy, ruleArray, 0, result);
        if(result.id.length > 0){
            energyResult.push(result);
        }
    });

    return energyResult;
};

exports.ResourceToSensor = function(resource)
{
    //
    var deferred = Q.defer();

    var onProcessSensors = function(err, data){
        if(err){
            deferred.reject(err);
//            func && func(err, null);
            return;
        }

        sensorArray = new Array();
        _.each(data, function(v){
            //
            sensorArray.push(v._id);
        });
        sensorArray = _.uniq(sensorArray);
        deferred.resolve(sensorArray);
    };

    //
    var sensorMiddleware = new mongodb.MiddleWare(mongodb.Sensor);

    if(Array.isArray(resource.sensor) && !_.isEmpty(resource.sensor)){
        sensorMiddleware.where('_id').in(resource.sensor);
    }
    if(Array.isArray(resource.customer) && !_.isEmpty(resource.customer)){
        sensorMiddleware.find({'socity':{$in:resource.customer}});
    }
    else{
        sensorMiddleware.find();
    }

    if(Array.isArray(resource.project)  && !_.isEmpty(resource.project)){
        mongodb.Building.where('project').in(resource.project).exec(function(err, data){
            var buildingIDs = [];
            _.each(data, function(v){
                buildingIDs.push(v._id);
            });
            if(Array.isArray(resource.building)){
                buildingIDs = _.union(buildingIDs, resource.building);
            }
            sensorMiddleware.where('building').in(buildingIDs).exec(onProcessSensors);
        });
    }
    else{
        //
        if(Array.isArray(resource.building)){
            sensorMiddleware.where('building').in(resource.building);
        }
        sensorMiddleware.exec(onProcessSensors)
    }

    return deferred.promise;
};

var QueryByType = {};
//Year Data
QueryByType[mongodb.PERYEAR] = function(from, to, sensors)
{
    var deferred = Q.defer();
    //不分表
    var queryFrom = moment(from).startOf('year');
    var queryTo = moment(queryFrom).endOf('year');
    console.log(queryFrom.format('YYYY-MM-DD HH:mm:ss'), queryTo.format('YYYY-MM-DD HH:mm:ss'));

    var collection = mongodb.CollectionByTimeType(mongodb.PERYEAR, queryFrom);
    collection.model
        .find()
        .where('sensor').in(sensors)
        .where('timepoint').gte(queryFrom).lte(queryTo)
        .populate('sensor')
        .sort({timepoint: 1})
        .exec(function(err, data){
            if(err){
                deferred.reject(err);
//                callback && callback(err, null);
            }
            else{
                deferred.resolve(data);
//                callback && callback(null, data);
            }
        });
    return deferred.promise;
};
//Month Data
QueryByType[mongodb.PERMONTH] = function(from, to, sensors)
{
    var deferred = Q.defer();
    //按月分表
    var queryFrom = moment(from).startOf('month').startOf('day');
    var queryTo = moment(queryFrom).endOf('month').endOf('day');

    var dataArray = new Array();

    var RunQuery = function(qf, qt)
    {
        //
        var isEnd = false;
        if(qt.unix() > to.unix() ){
            qt = moment(to);
            isEnd = true;
        }
        console.log(qf.format('YYYY-MM-DD HH:mm:ss'), qt.format('YYYY-MM-DD HH:mm:ss'));

        var collection = mongodb.CollectionByTimeType(mongodb.PERMONTH, qf);
        collection.model
            .find()
            .where('sensor').in(sensors)
            .where('timepoint').gte(qf.toDate()).lte(qt.toDate())
            .populate('sensor')
            .sort({timepoint: 1})
            .exec(function(err, data){
//                console.log(err, data);
                if(err){}
                else{
                    //dataArray = dataArray union data
                    dataArray = _.union(dataArray, data);

                    qf = moment(qf).add('month', 1);
                    qt = moment(qf).endOf('month').endOf('day');
                    if(isEnd){
                        //return data
                        deferred.resolve(dataArray);
//                        callback && callback(null, dataArray);
                    }
                    else{
                        return RunQuery(qf, qt);
                    }
                }
            });
    };

    RunQuery(queryFrom, queryTo);
    return deferred.promise;
};
//Week Data
QueryByType[mongodb.PERWEEK] = function(from, to, sensors)
{
    var deferred = Q.defer();
    //按月分表
    var queryFrom = moment(from).startOf('isoweek').startOf('day');
    var queryTo = moment(queryFrom).endOf('isoweek').endOf('day');

    var dataArray = new Array();

    var RunQuery = function(qf, qt)
    {
        //
        var isEnd = false;
        if(qt.unix() > to.unix() ){
            qt = moment(to).endOf('isoweek').endOf('day');
            isEnd = true;
        }
        console.log(qf.format('YYYY-MM-DD HH:mm:ss'), qt.format('YYYY-MM-DD HH:mm:ss'));

        var collection = mongodb.CollectionByTimeType(mongodb.PERWEEK, qf);
        collection.model
            .find()
            .where('sensor').in(sensors)
            .where('timepoint').gte(qf.toDate()).lte(qt.toDate())
            .populate('sensor')
            .sort({timepoint: 1})
            .exec(function(err, data){
                if(err){
                    deferred.reject(err);
//                    callback && callback(err, null);
                    return;
                }
                else{
                    dataArray = _.union(dataArray, data);
                    qf = moment(qf).add('weeks', 1);
                    qt = moment(qf).endOf('isoweek').endOf('day');
                    if(isEnd){
                        //return data
                        deferred.resolve(dataArray);
//                        callback && callback(null, dataArray);
                    }
                    else{
                        return RunQuery(qf, qt);
                    }
                }
            });
    };

    RunQuery(queryFrom, queryTo);
    return deferred.promise;
};
//Days Data
QueryByType[mongodb.PERDAY] = function(from, to, sensors)
{
    var deferred = Q.defer();
    //按月分表,按月递增
    var queryFrom = moment(from).startOf('day');
    var queryTo = moment(queryFrom).endOf('month').endOf('day');
    console.log('Query: ', queryFrom.format('YYYY-MM-DD HH:mm:ss'), queryTo.format('YYYY-MM-DD HH:mm:ss'));

    var dataArray = new Array();
    var RunQuery = function(qf, qt)
    {
        //
        isEnd = false;
        if(qt.unix() > to.unix() ){
            qt = moment(to).endOf('day');
            isEnd = true;
        }
        console.log(qf.format('YYYY-MM-DD HH:mm:ss'), qt.format('YYYY-MM-DD HH:mm:ss'), isEnd);

        var collection = mongodb.CollectionByTimeType(mongodb.PERDAY, qf);
        collection.model
            .find()
            .where('sensor').in(sensors)
            .where('timepoint').gte(qf.toDate()).lte(qt.toDate())
            .populate('sensor')
            .sort({timepoint: 1})
            .exec(function(err, data){
                if(err){
                    deferred.reject(err);
                    return;
                }
                else{
                    //dataArray = dataArray union data
                    dataArray = _.union(dataArray, data);

                    qf = moment(qt).add(1, 'day').startOf('day');
                    qt = moment(qf).endOf('month').endOf('day');
                    if(isEnd){
                        //return data
                        deferred.resolve(dataArray);
                    }
                    else{
                        return RunQuery(qf, qt);
                    }
                }
            });
    };

    RunQuery(queryFrom, queryTo);
    return deferred.promise;
};
//PerHour
QueryByType[mongodb.PERHOUR] = function(from, to, sensors)
{
    var deferred = Q.defer();
    //按月分表,按月递增
    var queryFrom = moment(from).startOf('day');
    var queryTo = moment(queryFrom).endOf('month').endOf('day');

    var dataArray = new Array();

    var RunQuery = function(qf, qt)
    {
        //
        var isEnd = false;
        if(qt.unix() > to.unix() ){
            qt = moment(to).endOf('day');
            isEnd = true;
        }
        console.log(qf.format('YYYY-MM-DD HH:mm:ss'), qt.format('YYYY-MM-DD HH:mm:ss'));

        var collection = mongodb.CollectionByTimeType(mongodb.PERHOUR, qf);
        collection.model
            .find()
            .where('sensor').in(sensors)
            .where('timepoint').gte(qf.toDate()).lte(qt.toDate())
            .populate('sensor')
//            .populate('sensor.building')
            .sort({timepoint: 1})
            .exec(function(err, data){
                if(err){
                    deferred.reject(err);
//                    callback && callback(err, null);
                    return;
                }
                else{
                    //dataArray = dataArray union data
                    dataArray = _.union(dataArray, data);

                    qf = moment(qt).add('day', 1).startOf('day');
                    qt = moment(qf).endOf('month').endOf('day');
                    if(isEnd){
                        //return data
                        deferred.resolve(dataArray);
//                        callback && callback(null, dataArray);
                    }
                    else{
                        return RunQuery(qf, qt);
                    }
                }
            });
    };

    RunQuery(queryFrom, queryTo);
    return deferred.promise;
};
//PerMinutes
QueryByType[mongodb.PERMINUTE] = function(from, to, sensors)
{
    var deferred = Q.defer();
    //按月分表,按月递增
    var queryFrom = moment(from).startOf('day');
    var queryTo = moment(queryFrom).endOf('month').endOf('day');

    var dataArray = new Array();

    var RunQuery = function(qf, qt)
    {
        //
        var isEnd = false;
        if(qt.unix() > to.unix() ){
            qt = moment(to).endOf('day');
            isEnd = true;
        }
        console.log(qf.format('YYYY-MM-DD HH:mm:ss'), qt.format('YYYY-MM-DD HH:mm:ss'));

        var collection = mongodb.CollectionByTimeType(mongodb.PERMINUTE, qf);
        collection.model
            .find()
            .where('sensor').in(sensors)
            .where('timepoint').gte(qf.toDate()).lte(qt.toDate())
            .populate('sensor')
            .sort({timepoint: 1})
            .exec(function(err, data){
                if(err){
                    deferred.reject(err);
                    return;
                }
                else{
                    if(data.length > 0){
                        dataArray = _.union(dataArray, data);
                    }

                    qf = moment(qt).add('day', 1).startOf('day');
                    qt = moment(qf).endOf('month').endOf('day');
                    if(isEnd){
                        //return data
                        deferred.resolve(dataArray);
                    }
                    else{
                        return RunQuery(qf, qt);
                    }
                }
            });
    };

    RunQuery(queryFrom, queryTo);
    return deferred.promise;
};

exports.QueryByTimeType = QueryByType;