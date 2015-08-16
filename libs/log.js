var log4js = require('log4js');
var path = require('path');
var appRoot = require('app-root-path');
var fs = require('fs');
var config = require('config');

exports = module.exports = function(appName, logPath)
{
	var loggerPath = path.join(appRoot.path, logPath || '/log/');
    if(!fs.existsSync(loggerPath)){
        fs.mkdirSync(loggerPath);
    }

    loggerPath = path.join(loggerPath, appName || 'log');
    var appenders = [];
    if(config.printToConsole){
        appenders.push({"type": "console"});
    }
    if(config.printToLog){
        appenders.push({
            "type": "dateFile",
            "filename": loggerPath,
            "pattern": "-yyyy-MM-dd"
        });
    }
    log4js.configure({appenders:appenders});
    global.log = log4js.getLogger(appName);
};