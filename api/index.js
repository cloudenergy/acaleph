/**
 * Created by Joey on 14-7-18.
 */

var prefix = '/api';

function loadModule(server, localPath)
{
    require("./"+localPath)(server, prefix+"/"+localPath);
}

module.exports = exports = function(server){
    loadModule(server, 'account');
};