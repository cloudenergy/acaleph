/**
 * Created by Joey on 14-4-1.
 */
var mongo = require('mongoose');
var config = require('config');
var moment = require('moment');
var _ = require('underscore');
var Schema = mongo.Schema
    , ObjectId = Schema.ObjectId;

//var DBURI = 'mongodb://root:123456@127.0.0.1/igrow?poolSize=5';
//var DBURI = 'mongodb://root:123456@202.75.217.176/igrow?poolSize=5';

exports = module.exports = function(callback) {
    mongo.connect(config.db.url, function(err){
        if(err){
            log.info(err);
        }
        else{
            log.info('mongoose connect ['+config.db.url+'] successful');
        }
        callback && callback(err);
    })
};

exports.MiddleWare = function(schema)
{
    var mongoMiddleware = schema;
    this.where = function(queryFactor){
        mongoMiddleware = mongoMiddleware.where(queryFactor);
        return mongoMiddleware;
    };
    this.or = function (queryFactor) {
        mongoMiddleware = mongoMiddleware.or(queryFactor);
        return mongoMiddleware;
    };
    this.in = function(queryFactor){
        mongoMiddleware = mongoMiddleware.in(queryFactor);
        return mongoMiddleware;
    };
    this.find = function(queryFactor){
        mongoMiddleware = mongoMiddleware.find(queryFactor);
        console.log('searching: ', queryFactor);
        return mongoMiddleware;
    };
    this.findOne = function(queryFactor){
        mongoMiddleware = mongoMiddleware.findOne(queryFactor);
        return mongoMiddleware;
    };
    this.populate = function(queryFactor){
        mongoMiddleware = mongoMiddleware.populate(queryFactor);
        return mongoMiddleware;
    };
    this.exec = function(callback){
        mongoMiddleware = mongoMiddleware.exec(callback);
        return mongoMiddleware;
    };
    this.gt = function(callback){
        mongoMiddleware = mongoMiddleware.gt(callback);
        return mongoMiddleware;
    };
    this.gte = function(callback){
        mongoMiddleware = mongoMiddleware.gte(callback);
        return mongoMiddleware;
    };
    this.lt = function(callback){
        mongoMiddleware = mongoMiddleware.lt(callback);
        return mongoMiddleware;
    };
    this.lte = function(callback){
        mongoMiddleware = mongoMiddleware.lte(callback);
        return mongoMiddleware;
    };
    this.sort = function(callback){
        mongoMiddleware = mongoMiddleware.sort(callback);
        return mongoMiddleware;
    };
};
//能耗分类
var energyCategorySchema = new Schema({
    _id: String,
    title: String,
    unit: String,
    standcol: Schema.Types.Mixed,
    description: String
});
//项目
var projectSchema = new Schema({
    title:{
        type: String,
        require: true
    },
    description: String,
    level: Number,
    energy: Schema.Types.Mixed
});
//路径请求
var urlPathSchema = new Schema({
    _id: String,
    enable: {
        type: Boolean,
        default: true
    },
    needlogin:{
        type: Boolean,
        default: true
    },
    authtype: {
        type: String,
        require: true,
        default: 'NONE' //NONE/BYACCOUNT/BYAPPID
    },
    desc:{
        type: String
    }
});
var resourceSchema = new Schema({
    key: {
        type: String,
        require: true
    },
    value: String,
    begin: {
        type: Date,
        require: true,
        default: Date.now
    },
    end: {
        type: Date,
        require: true,
        default: Date.now
    },
    belongto: {
        type: String,
        require: true,
        ref: 'account'
    },
    type: String,
    desc: String
});
//账户
var accountSchema = new Schema({
    _id: {
        type: String,
        require: true
    },
    passwd: {
        type: String
    },
    title:{
        type: String
    },
    lastlogin: {
        type: Date,
        require: true,
        default: Date.now
    },
    initpath: {
        type: String
    },
    authtree: {
        type: Schema.Types.Mixed
    },
    level:{
        type: Number
    },
    character:{
        type: Schema.ObjectId,
        require: true,
        ref: 'character'
    },
    resource:{
        type: Schema.Types.Mixed,
        require: true,
        default: {}
    },
    expire: {
        type: Number
    },
    token: String,
    billingAccount:{
        type: ObjectId,
        ref: 'billingAccount'
    }
});
//APPID账户
var appidsecretSchema = new Schema({
    _id: {
        type: String,
        require: true,
        unique: true
    },
    secret: {
        type: String
    },
    authtree: {
        type: Schema.Types.Mixed
    },
    character:{
        type: Schema.ObjectId,
        require: true,
        ref: 'character'
    },
    resource:{
        type: Schema.Types.Mixed,
        require: true,
        default: {}
    },
    expire: {
        type: Number
    },
    desc: String
});
//角色
var characterSchema = new Schema({
    title: {
        type: String,
        require: true
    },
    rule:{
        type: Schema.Types.Mixed,
        require: true,
        default: {}
    },
    level: Number
});
//采集器
var collectorSchema = new Schema({
    _id:{
        type: String,
        require: true
    },
    title:{
        type: String,
        require: true
    },
    description: String,
    project:{
        type: ObjectId,
        require: true,
        ref: "project"
    }
});
//传感器
var sensorSchema = new Schema({
    sid:{
        type: String,
        require: true
    },
    title: {
        type:String,
        require: true
    },
    description: {
        type:String,
        default: ''
    },
    project:{
        type: ObjectId,
        require: true,
        ref: "project"
    },
    building: {
        type:String,
        require: true,
        ref: 'building'
    },
    socity:{
        type:Schema.Types.Mixed,
        ref: 'customer'
    },
    freq: {
        type: Number,
        default: 1800
    },
    lasttotal: {
        type: Number,
        require: true,
        default: 0
    },
    lastvalue: {
        type: Number,
        require: true,
        default: 0
    },
    lastupdate: {
        type: Date,
        require: true,
        default: Date.now()
    },
    energy: {
        type: String,
        require: true
    },
    energyPath: {
        type: String,
        require: true
    }
//    energyTitle: {
//        type: String,
//        require: true
//    }
});
//社会属性
var customerSchema = new Schema({
    title: {
        type: String,
        require: true
    },
    acreage: Number,
    socity:{
        type: Schema.Types.Mixed
    },
    project:{
        type: ObjectId,
        require: true,
        ref: "project"
    },
    description: {
        type: String
    }
});
//建筑
var buildingSchema = new Schema({
    _id: {
        type: String,
        require: true
    },
    title: String,
    description: String,
    acreage: {
        type: Number,
        require: true
    },
    avgConsumption: Number,
    totalConsumption: Number,
    geolocation: Schema.Types.Mixed,
    project:{
        type: ObjectId,
        require: true,
        ref: "project"
    }
});
//能耗类型
var energySchema = new Schema({
    title:{
        type: String,
        require: true
    },
    unitprice:{
        type: Schema.Types.Mixed,
        require: true
    },
    standcol:{
        type: Number,
        default: 0
    },
    description: String,
    childrens: Schema.Types.Mixed
});
//项目账户计费账户关系
var projectAccountBillingRelationShipSchema = new Schema({
    _id: String,
    project: {
        type: ObjectId,
        ref: "project"
    },
    account: {
        type: String,
        ref: "account"
    },
    billing:{
        type: String,
        ref: "billingAccount"
    },
    status:{
        type: String,
        require: true,
        default: 'BIND'
    }
});
//计费账户
var billingAccount = new Schema({
    title: String,
    cash: {
        type: Schema.Types.Mixed,
        require: true,
        default: 0
    },
    consume: {
        type: Schema.Types.Mixed,
        require: true,
        default: 0
    },
    expire: {
        type: Schema.Types.Mixed,
        require: true,
        default: 0
    }
});
//计费服务
var billingService = new Schema({
    title: String,
    energycategory: Schema.Types.Mixed, //能耗分类数组
    project: {
        type: ObjectId,
        ref: "project"
    },
    description: String,
    rules: Schema.Types.Mixed   //计费规则
});
//套餐计划
var packagePlan = new Schema({
    billingService: {
        type: ObjectId,
        ref: 'billingservice'
    },
    title: String,
    rent: {
        type: Schema.Types.Mixed,
        default: 0
    },
    price: {
        type: Schema.Types.Mixed,
        default: 0
    },
    period: String,
    freq: {
        type: Schema.Types.Mixed,
        default: 0
    },
    pkgtype: String,
    value: {
        type: Schema.Types.Mixed,
        default: 0
    },
    valuetype: String,
    priority: Schema.Types.Mixed
});
//用户套餐
var userPackage = new Schema({
    packageplan:{
        type: ObjectId,
        ref: 'packageplan'
    },
    user:{
        type: String,
        ref: 'account'
    },
    value: Schema.Types.Mixed,
    begin: Schema.Types.Mixed,
    end: Schema.Types.Mixed
});
//充值日志
var chargeLogSchema = new Schema({
    cash: {
        type: Number,
        require: true,
        default: 0
    },
    operator: {
        type: String,
        require: true,
        ref: "account"
    },
    account: {
        type: String,
        require: true,
        ref: "account"
    },
    openid:{
        type: String,
        ref: "wxopeniduser"
    },
    reverse: {
        type: Number,
        require: true,
        default: 0
    },
    timestamp: {
        type: Date,
        require: true,
        default: Date.now()
    },
    //充值来源(现金CASH/微信WX)
    source: {
        type: String,
        require: true,
        default: 'CASH'
    }
});

//每小时/每分钟数据
var dataPerClassification = new Schema({
    sensor: {
        type: ObjectId,
        require: true,
        ref: 'sensor'
    },
    timepoint: {
        type: Date,
        require: true,
        default: Date.now
    },
    value: {
        type: Schema.Types.Mixed,
        require: true
    },
    total: {
        type: Schema.Types.Mixed,
        require: true
    }
});
var dataPerDayWeekMonthYear = new Schema({
    sensor: {
        type: ObjectId,
        require: true,
        ref: 'sensor'
    },
    timepoint: {
        type: Date,
        require: true,
        default: Date.now
    },
    value: {
        type: Schema.Types.Mixed,
        require: true,
        default: 0.0
    },
    timeslot: {
        type: Schema.Types.Mixed,
        require: true,
        default: {"0":0, "1":0, "2":0, "3":0, "4":0, "5":0, "6":0, "7":0, "8":0, "9":0, "10":0, "11":0, "12":0, "13":0, "14":0, "15":0, "16":0, "17":0, "18":0, "19":0, "20":0, "21":0, "22":0, "23":0}
    },
    total: {
        type: Schema.Types.Mixed,
        require: true,
        default: 0.0
    }
});

var dataPoint = new Schema({
    sensor: {
        type: String,
        require: true,
        ref: 'sensor'
    },
    timestamp: {
        type: Date,
        require: true,
        default: Date.now
    },
    value: {
        type: Schema.Types.Mixed,
        require: true
    },
    total: {
        type: Schema.Types.Mixed,
        require: true
    }
});

var SensorCacheSchema = new Schema({
    _id: String,
    data: Schema.Types.Mixed,
    timestamp: Date
});


//微信ID==>用户ID
var WXOpenIDUserSchema = new Schema({
    _id: String,
    platformid: {
        type: String,
        ref: 'wxplatform'
    },
    user: {
        type: String,
        ref: 'account'
    }
});

//
var WXPlatformSchema = new Schema({
    _id: String,
    name: String,
    map: String,
    appid: String,
    appsecret: String
});

//事件规则
var eventService = new Schema({
    title: String,
    events: Schema.Types.Mixed, //适用事件
    project: {
        type: ObjectId,
        ref: "project"
    },
    description: String,
    rules: Schema.Types.Mixed   //事件规则
});

//事件日志
var eventSchema = new Schema({
    timestamp: {
        type: Date,
        require: true,
        default: Date.now(),
        index: true
    },
    gateway: String, //消息发送网关
    message: String,
    target: String  //发送至目录
});

//事件分类(最多15种一级事件)
var eventCategorySchema = new Schema({
    _id: String,
    templateid: String,
    title:String,
    subevents: Schema.Types.Mixed
});

exports.ObjectId = ObjectId;
exports.NewObjectId = function()
{
    return new mongo.Types.ObjectId;
};

exports.Account = mongo.model('account', accountSchema);
exports.AppIDSecret = mongo.model('appidsecret', appidsecretSchema);
exports.Character = mongo.model('character', characterSchema);
exports.Project = mongo.model('project', projectSchema);
exports.EnergyCategory = mongo.model('energycategory', energyCategorySchema);
exports.Resource = mongo.model('resource', resourceSchema);
exports.UrlPath = mongo.model('urlpath', urlPathSchema);
exports.DataBuffer = mongo.model('dataBuffer', dataPoint);
exports.Building = mongo.model('building', buildingSchema);
exports.Customer = mongo.model('customer', customerSchema);
exports.Sensor = mongo.model('sensor', sensorSchema);
exports.Collector = mongo.model('collector', collectorSchema);
exports.Energy = mongo.model('energy', energySchema);
exports.EventCategory = mongo.model('eventCategory', eventCategorySchema);
exports.EventService = mongo.model('eventService', eventService);
exports.Event = mongo.model('event', eventSchema);

exports.ProjectAccountBillingRelationShip = mongo.model('pabRelationship', projectAccountBillingRelationShipSchema);
exports.BillingAccount = mongo.model('billingAccount', billingAccount);
exports.BillingService = mongo.model('billingService', billingService);
exports.PackagePlan = mongo.model('packagePlan', packagePlan);
exports.UserPackage = mongo.model('userpackage', userPackage);
//exports.ChargeLog = mongo.model('chargeLog', chargeLogSchema);

exports.WXOpenIDUser = mongo.model('wxopeniduser', WXOpenIDUserSchema);
exports.WXPlatform = mongo.model('wxplatform', WXPlatformSchema);

exports.PERMINUTE = 'PERMINUTE';
exports.PERHOUR = 'PERHOUR';
exports.PERDAY = 'PERDAY';
exports.PERWEEK = 'PERWEEK';
exports.PERMONTH = 'PERMONTH';
exports.PERYEAR = 'PERYEAR';

var TimeTypeToCollection = {
    'PERMINUTE': {
        name: 'dataperminute',
        timeformat: 'YYYYMM',
        pointformat: 'YYYYMMDDHHmm00',
        schema: dataPerClassification
    },
    'PERHOUR': {
        name: 'dataperhour',
        timeformat: 'YYYYMM',
        pointformat: 'YYYYMMDDHH',
        schema: dataPerClassification
    },
    'PERDAY': {
        name: 'dataperday',
        timeformat: 'YYYYMM',
        pointformat: 'YYYYMMDD',
        schema: dataPerDayWeekMonthYear
    },
    'PERWEEK': {
        name: 'dataperweek',
        timeformat: 'YYYY',
        pointformat: 'YYYYWW',
        schema: dataPerDayWeekMonthYear
    },
    'PERMONTH': {
        name: 'datapermonth',
        timeformat: 'YYYY',
        pointformat: 'YYYYMM',
        schema: dataPerDayWeekMonthYear
    },
    'PERYEAR': {
        name: 'dataperyear',
        timeformat: 'YYYY',
        pointformat: 'YYYY',
        schema: dataPerDayWeekMonthYear
    }
};

var CacheCollection = {
    'DAYCACHE': {
        name: 'cache.day.',
        timeformat: 'YYYYMM',
        schema: SensorCacheSchema
    },
    'WEEKCACHE': {
        name: 'cache.week.',
        timeformat: 'YYYY',
        schema: SensorCacheSchema
    },
    'MONTHCACHE': {
        name: 'cache.month.',
        timeformat: 'YYYY',
        schema: SensorCacheSchema
    },
    'YEARCACHE': {
        name: 'cache.year.',
        timeformat: 'YYYY',
        schema: SensorCacheSchema
    }
};

var PaymentLogBase = {
    amount: {
        type: Number,
        require: true,
        default: 0
    },
    account: {
        type: String,
        require: true,
        ref: 'account',
        index: true
    },
    billingAccount: {
        type: Schema.ObjectId,
        require: true,
        ref: "billingaccount",
        index: true
    },
    sensor: {
        type: Schema.ObjectId,
        require: true,
        ref: "sensor",
        index: true
    },
    project: {
        type: ObjectId,
        require: true,
        ref: "project"
    },
    data: {
        type: Schema.Types.Mixed,
        require: true
    },
    timestamp: {
        type: Date,
        require: true,
        default: Date.now()
    }
};

//计费日志（天）
var PaymentLogByDaySchema;
{
    var PaymentLog = PaymentLogBase;
    PaymentLog['data'] = new Array(24);
    for (var i = 0; i < 24; i++) {
        PaymentLog.data[i] = 0.0;
    }
    PaymentLogByDaySchema = new Schema(PaymentLog);
}
//计费日志（周）
var PaymentLogByWeekSchema;
{
    var PaymentLog = PaymentLogBase;
    PaymentLog['data'] = new Array(7);
    for (var i = 0; i < 7; i++) {
        PaymentLog.data[i] = 0.0;
    }
    PaymentLogByWeekSchema = new Schema(PaymentLog);
}
//计费日志（月）
var PaymentLogByMonthSchema;
{
    var PaymentLog = PaymentLogBase;
    PaymentLog['data'] = new Array(31);
    for (var i = 0; i < 31; i++) {
        PaymentLog.data[i] = 0.0;
    }
    PaymentLogByMonthSchema = new Schema(PaymentLog);
}
//计费日志（年）
var PaymentLogByYearSchema;
{
    var PaymentLog = PaymentLogBase;
    PaymentLog['data'] = new Array(12);
    for (var i = 0; i < 12; i++) {
        PaymentLog.data[i] = 0.0;
    }
    PaymentLogByYearSchema = new Schema(PaymentLog);
}


//计费日志分表结构
var PaymentLogCollection = {
    'DAY': {
        name: 'payment.day.',
        timeformat: 'YYYYMM',
        dataindex: 'HH',
        dataindexoffset: 0,
        timepointFormat: 'YYYYMMDD',
        schema: PaymentLogByDaySchema
    },
    'WEEK':{
        name: 'payment.week.',
        timeformat: 'YYYYMM',
        dataindex: 'E',
        dataindexoffset: -1,
        timepointFormat: 'YYYYWW',
        schema: PaymentLogByWeekSchema
    },
    'MONTH':{
        name: 'payment.month.',
        timeformat: 'YYYYMM',
        dataindex: 'DD',
        dataindexoffset: -1,
        timepointFormat: 'YYYYMM',
        schema: PaymentLogByMonthSchema
    },
    'YEAR':{
        name: 'payment.year.',
        timeformat: 'YYYY',
        dataindex: 'MM',
        dataindexoffset: -1,
        timepointFormat: 'YYYY',
        schema: PaymentLogByYearSchema
    }
};

exports.DailyData = function()
{
    var collectionName = 'dailyData' + moment().format('YYYYMMDD');
    return mongo.model(collectionName, dataPoint);
};

exports.CollectionByTimeType = function(type, dataTime)
{
    //
    var collection = TimeTypeToCollection[type];
    if(collection == undefined){
        log.info('Unknow TimeType: ', type);
        return null;
    }
    var timepoint = '';
    if(collection.timeformat.length != 0){
        timepoint = dataTime.format(collection.timeformat);
    }
    var collectionName = collection.name + timepoint;
    log.info(type, collectionName);

    timepoint = moment(dataTime).format(collection.pointformat);
    timepoint = moment(timepoint, collection.pointformat).toDate();

    return {
        model: mongo.model(collectionName, collection.schema),
//        timepoint: dataTime.format(collection.pointformat)
        timepoint: timepoint
    }
};

exports.SchemaByTimeType = function(type, dataTime)
{
    //
    var collection = TimeTypeToCollection[type];
    if(collection == undefined){
        log.info('Unknow TimeType: ', type);
        return null;
    }
    var collectionSchema = new collection.schema;
    if(dataTime != null || dataTime != undefined){
        collectionSchema.timepoint = dateTime.format(collection.timeformat);
    }
    return collectionSchema;
};

exports.CollectionBySensorCacheType = function(type, dataTime)
{
    //
    var collection = CacheCollection[type];
    if(collection == undefined){
        log.info('Unknow CacheType: ', type);
        return undefined;
    }
    var collectionName = 'sensor.' + collection.name;
    if(dataTime && collection.timeformat.length != 0){
        //
        collectionName += dataTime.format(collection.timeformat);
    }
    log.info(type, collectionName);

    return mongo.model(collectionName, collection.schema);
};

exports.ChargeLogCollection = function()
{
//    var timeQuantum = moment().format('YYYYMM');
    var collectionName = 'chargelog';
    var chargeLogModel = mongo.model(collectionName, chargeLogSchema);
    var chargeLog ={
        schema: chargeLogModel,
        model: new chargeLogModel()
    };
    return chargeLog;
};
exports.PaymentLogCollection = function(type, logTime)
{
    var collection = PaymentLogCollection[type];
    if(!collection){
        return null;
    }

    var timeQuantum = logTime || moment();
    var collectionName = collection.name+timeQuantum.format(collection.timeformat);
    var timepoint = moment(timeQuantum).format(collection.timepointFormat);
    timepoint = moment(timepoint, collection.timepointFormat).toDate();
    var collectionObj = {
        timepoint: timepoint,
        timearea: timeQuantum.format(collection.timeformat),
        index: Number(timeQuantum.format(collection.dataindex)) + collection.dataindexoffset,
        model: mongo.model(collectionName, collection.schema)
    };

    return collectionObj;
};