/**
 * Created with JetBrains WebStorm.
 * User: christozhou
 * Date: 14-7-17
 * Time: 下午9:02
 * To change this template use File | Settings | File Templates.
 */

var apiUtil = require('../apiUtil.js');
var add =require('./add.js');
var info =require('./info.js');
var update =require('./update.js');
var del =require('./delete.js');

module.exports = exports = function(server, parentPrefix){
    apiUtil.LoadModule(server, 'POST', add, parentPrefix);
    apiUtil.LoadModule(server, 'POST', info, parentPrefix);
    apiUtil.LoadModule(server, 'POST', update, parentPrefix);
    apiUtil.LoadModule(server, 'POST', del, parentPrefix);
}