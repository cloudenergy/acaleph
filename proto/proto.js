var grpc = require('grpc');
var config = require('config');
var Q = require('q');
var path = require('path');
var _ = require('underscore');

//load proto file
function LoadProto(filename, packageName) {
	var filePath = path.join(__dirname, filename);
	return grpc.load(filePath)[packageName];
}
function CreateClient(rpcModule, packageIns, serviceName) {
	if(!config[rpcModule]){
		return null;
	}
	let ipAddress = `${config[rpcModule].ip}:${config[rpcModule].port}`;
    return new packageIns[serviceName](ipAddress, grpc.credentials.createInsecure());
}

class RPCClient {
	constructor(rpcconfig, proto, pkg, service) {
		this.rpcconfig = rpcconfig;
		this.proto = proto;
		this.pkg = pkg;
		this.service = service;
		this.client = null;
	}

	create () {
		this.client = CreateClient(this.rpcconfig, LoadProto(this.proto, this.pkg), this.service);
		return this.client;
	}

    run (func, obj) {
		let _this = this;
        return new Promise((resolve, reject)=>{
        	if(!_this.client){
        		return reject(ErrorCode.ack(ErrorCode.Code.ACCESSDENIED));
			}
            try {
                _this.client[func](obj, function (err, response) {
                    if (err) {
                        reject(err);
                    }
                    else {
                        if(response.result.length) {
                            let result = null;
                            try {
                                result = JSON.parse(response.result);
                            }
                            catch (e) {
                            }
                            response.result = result;
                        }
                        else{
                        	response = _.omit(response, 'result');
						}
                        resolve(response);
                    }
                });
            }
            catch(e){
                log.error(e, this.rpcconfig, this.proto, this.pkg, this.service, obj);
            }
        });
    }
}

class RPCPool {
	constructor(){
		this.pool = {};
	}
	create (alias, rpcconfig, proto, pkg, service){
		if(this.pool[alias]){
			return this.pool[alias];
		}
        let client = new RPCClient(rpcconfig, proto, pkg, service);
        client.create();
		this.pool[alias] = client;
		return client;
	}
	get (alias) {
		return this.pool[alias];
	}
}
let pool = new RPCPool();

//建立RPC服务
exports = module.exports = function(){
	//Finance
	global.RPC = {
		Message:{
			Config:{
                List: (obj)=>{return pool.get(MESSAGECONFIG).run('list', obj); },
                Update: (obj)=>{return pool.get(MESSAGECONFIG).run('update', obj); },
			}
		}
	};

    const MESSAGECONFIG = 'CONFIG';
    pool.create(MESSAGECONFIG, 'rpc_message', 'message.proto', 'Message', 'Config');
};
