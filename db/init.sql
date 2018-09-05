drop DATABASE if exists energymanage;
CREATE DATABASE energymanage CHARACTER SET utf8 COLLATE utf8_general_ci;
USE energymanage;

create table account
(
	uid bigint unsigned not null
		primary key,
	user varchar(128) default '' not null,
	passwd varchar(255) null,
	ctrlpasswd varchar(8) null,
	title varchar(32) default '' null,
	lastlogin bigint default '0' null,
	initpath varchar(255) default '' null,
	`character` varchar(32) default '' null,
	resource text null,
	expire bigint default '0' null,
	token varchar(255) default '' null,
	type enum('USER', 'APPID') null,
	mobile varchar(16) default '' null,
	email varchar(128) default '' null,
	timecreate bigint default '0' null,
	timedelete bigint default '0' null,
	timepause bigint default '0' null,
	description varchar(255) default '' null
)
engine=InnoDB
;

create index user
	on account (user)
;

create table account_copy1
(
	uid bigint unsigned not null
		primary key,
	user varchar(128) default '' not null,
	passwd varchar(255) null,
	ctrlpasswd varchar(8) null,
	title varchar(32) default '' null,
	lastlogin bigint default '0' null,
	initpath varchar(255) default '' null,
	`character` varchar(32) default '' null,
	resource text null,
	expire bigint default '0' null,
	token varchar(255) default '' null,
	type enum('USER', 'APPID') null,
	mobile varchar(16) default '' null,
	email varchar(128) default '' null,
	timecreate bigint default '0' null,
	timedelete bigint default '0' null,
	timepause bigint default '0' null,
	description varchar(255) default '' null
)
engine=InnoDB
;

create index user
	on account_copy1 (user)
;

create table apartmenthistory
(
	contractid bigint unsigned auto_increment
		primary key,
	uid bigint unsigned not null,
	tid bigint unsigned default '0' not null,
	projectid varchar(64) default '' not null,
	timefrom bigint unsigned default '0' not null,
	timeto bigint unsigned default '0' not null
)
engine=InnoDB
;

create table appidsecret
(
	id char(128) not null comment '用户ID'
		primary key,
	secret varchar(255) default '' not null comment '密码',
	lastlogin bigint default '0' not null comment '最后登录时间',
	`character` varchar(128) default '' not null comment '角色ID',
	resource text not null comment '资源',
	expire bigint default '0' not null comment '过期时间',
	description varchar(255) default '' not null comment '描述',
	constraint USERINDEX
		unique (id)
)
engine=InnoDB
;

create table apportionment
(
	cid varchar(64) not null,
	tid bigint default '0' not null,
	percent int(1) default '0' not null,
	projectid varchar(64) default '' not null,
	primary key (cid, tid)
)
engine=InnoDB
;

create table appservices
(
	`key` varchar(32) default '' not null
		primary key,
	url text null
)
engine=InnoDB
;

create table apptemplate
(
	id bigint unsigned auto_increment
		primary key,
	project char(64) null,
	template char(64) null,
	type varchar(16) null,
	parent bigint unsigned default '0' null,
	title varchar(16) null,
	content text null,
	`index` int unsigned default '0' null,
	enable tinyint(1) default '1' null
)
engine=InnoDB
;

create index template
	on apptemplate (template)
;

create index type
	on apptemplate (type)
;

create index parent
	on apptemplate (parent)
;

create table area
(
	code int not null
		primary key,
	name varchar(8) default '' not null,
	parentid int default '0' not null,
	type tinyint default '0' not null
)
engine=InnoDB
;

create table authcode
(
	id int default '0' not null comment '验证码',
	uid varchar(128) default '' not null,
	authtype enum('SMS') not null comment '验证码类型',
	timecreate bigint not null comment '验证码创建时间',
	primary key (id, uid),
	constraint IDUIDINDEX
		unique (id, uid)
)
engine=InnoDB
;

create index TYPETIMEINDEX
	on authcode (authtype, timecreate)
;

create table authresources
(
	user varchar(128) default '' not null,
	restype varchar(64) default '' not null,
	value varchar(255) default '' not null,
	enable tinyint default '1' not null,
	primary key (user, restype, value)
)
engine=InnoDB
;

create table bankinfo
(
	id varchar(8) default '' not null
		primary key,
	title varchar(64) null,
	earning bigint unsigned null,
	expense bigint unsigned null
)
engine=InnoDB
;

create table base
(
	id int(11) unsigned auto_increment
		primary key,
	sensor varchar(64) not null comment '传感器ID',
	timepoint bigint not null comment '数据上行时间',
	value decimal(18,2) not null comment '数据差值',
	total decimal(18,2) not null comment '数据刻度',
	constraint IDINDEX
		unique (id)
)
comment '基础数据存放，存放传感器上行基础数据' engine=InnoDB
;

create index SENSORTIMEPOINTINDEX
	on base (sensor, timepoint)
;

create table baseenergycategory
(
	id char(32) not null comment '能耗分类ID'
		primary key,
	title char(32) not null comment '能耗分类名称',
	unit char(16) not null comment '能耗分类',
	standcol decimal(8,4) not null comment '标准煤系数',
	description varchar(255) not null comment '描述',
	constraint IDINDEX
		unique (id)
)
comment '能耗分类表' engine=InnoDB
;

create table billingequiplink
(
	billingid bigint unsigned not null,
	euid varchar(128) not null,
	primary key (billingid, euid)
)
engine=InnoDB
;

create table billingequiplink_copy
(
	billingid bigint unsigned not null,
	euid varchar(128) not null,
	primary key (billingid, euid)
)
engine=InnoDB
;

create table billingservice
(
	id bigint(64) unsigned auto_increment comment '计费服务ID'
		primary key,
	title varchar(32) not null comment '计费服务名称',
	project varchar(64) not null comment '计费服务所属项目ID',
	devicetype text not null comment '计费服务所作用于仪表类型的JSON',
	rules text not null comment '计费规则JSON',
	description varchar(255) not null comment '描述',
	constraint IDINDEX
		unique (id)
)
comment '计费服务表' engine=InnoDB
;

create index PROJECTINDEX
	on billingservice (project)
;

create table billingshare
(
	id bigint unsigned auto_increment
		primary key,
	title varchar(64) null,
	project varchar(64) null,
	`from` varchar(128) null,
	`to` varchar(128) null,
	mode enum('BYEACH', 'BYCONSUMPTION', 'BYAREA') default 'BYEACH' null
)
engine=InnoDB
;

create table billingstrategy
(
	id bigint unsigned auto_increment
		primary key,
	title varchar(32) null,
	projectid varchar(64) null,
	rules text null,
	description varchar(255) null,
	timecreate bigint unsigned default '0' null,
	timeexpire bigint unsigned default '0' null
)
engine=InnoDB
;

create index projectid
	on billingstrategy (projectid)
;

create table buildings
(
	bid bigint unsigned auto_increment
		primary key,
	id varchar(64) default '' not null,
	title varchar(32) null,
	acreage int null,
	avgConsumption decimal(18,2) null,
	totalConsumption decimal(18,2) null,
	projectid varchar(64) null,
	location text null,
	description varchar(255) null
)
engine=InnoDB
;

create table cache_accountbalance
(
	account varchar(128) default '' not null,
	time char(8) default '' not null,
	project varchar(64) null,
	`from` decimal(18,4) default '0.0000' null,
	`to` decimal(18,4) default '0.0000' null,
	primary key (account, time)
)
engine=InnoDB
;

create index TPA
	on cache_accountbalance (time, project, account)
;

create table cache_accountbalance_copy
(
	account varchar(128) default '' not null,
	time char(8) default '' not null,
	project varchar(64) null,
	`from` decimal(18,4) default '0.0000' null,
	`to` decimal(18,4) default '0.0000' null,
	primary key (account, time)
)
engine=InnoDB
;

create index TPA
	on cache_accountbalance_copy (time, project, account)
;

create table cache_accountpushstatus
(
	uid varchar(128) not null
		primary key,
	cash decimal(18,2) not null,
	timeupdate bigint default '0' not null comment '更新时间'
)
engine=InnoDB
;

create table cache_calendar
(
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	energy varchar(64) null,
	value decimal(18,2) null,
	primary key (sensor, date)
)
engine=InnoDB
;

create index DATE
	on cache_calendar (date)
;

create table cache_sensorpushstatus
(
	channelid char(32) not null comment '通道设备ID'
		primary key,
	commexception bigint not null comment '上次推送通讯异常时间',
	dataexception decimal(18,2) not null comment '上次推送通讯异常时间',
	project varchar(64) null
)
engine=InnoDB
;

create table cache_userevents
(
	uid bigint unsigned default '0' not null
		primary key,
	balinsufficient bigint unsigned default '0' not null,
	arrearage bigint unsigned default '0' not null,
	remind bigint unsigned default '0' not null,
	createdAt datetime not null,
	updatedAt datetime not null
)
engine=InnoDB
;

create table channelaccount
(
	id bigint unsigned auto_increment
		primary key,
	usefor varchar(16) not null,
	belongto varchar(64) null,
	flow enum('EARNING', 'EXPENSE') null,
	name varchar(32) null,
	idcard varchar(20) null,
	account varchar(64) null,
	accounttype varchar(16) default 'PRIVATE' null,
	type varchar(32) null,
	origin varchar(32) default '' null,
	subbranch varchar(32) default '' null,
	locate text null,
	reservedmobile varchar(16) default '' null,
	reservedman varchar(16) null,
	linkman varchar(16) default '' null,
	mobile varchar(16) default '' null,
	proposer varchar(128) null,
	operator varchar(128) null,
	timecreate bigint null,
	timeenable bigint null,
	timeexpire bigint null,
	setting text null,
	rate decimal(10,4) unsigned default '0.0000' not null,
	share text null,
	status enum('FAILED', 'SUCCESS', 'CHECKING') default 'CHECKING' null,
	reason text null,
	amount decimal(18,2) null comment '渠道金额',
	`lock` tinyint default '0' null comment '是否锁定渠道',
	inuse tinyint default '0' null
)
engine=InnoDB
;

create table channelaccount_copy
(
	id bigint unsigned auto_increment
		primary key,
	usefor varchar(16) not null,
	belongto varchar(64) null,
	flow enum('EARNING', 'EXPENSE') null,
	name varchar(32) null,
	idcard varchar(20) null,
	account varchar(64) null,
	accounttype varchar(16) default 'PRIVATE' null,
	type varchar(32) null,
	origin varchar(32) default '' null,
	subbranch varchar(32) default '' null,
	locate text null,
	reservedmobile varchar(16) default '' null,
	reservedman varchar(16) null,
	linkman varchar(16) default '' null,
	mobile varchar(16) default '' null,
	proposer varchar(128) null,
	operator varchar(128) null,
	timecreate bigint null,
	timeenable bigint null,
	timeexpire bigint null,
	setting text null,
	rate bigint unsigned null,
	share text null,
	status enum('FAILED', 'SUCCESS', 'CHECKING') default 'CHECKING' null,
	reason text null,
	amount decimal(18,2) null comment '渠道金额',
	`lock` tinyint default '0' null comment '是否锁定渠道',
	inuse tinyint default '0' null
)
engine=InnoDB
;

create table channeldefine
(
	id varchar(3) not null
		primary key,
	name varchar(16) default '' not null,
	persist tinyint(1) default '0' not null,
	measure tinyint(1) default '0' not null,
	unit varchar(8) default '' not null
)
engine=InnoDB
;

create table `character`
(
	id char(64) default '' not null
		primary key,
	title varchar(32) null,
	rule text null,
	level int null
)
engine=InnoDB
;

create table collector
(
	id bigint unsigned auto_increment
		primary key,
	hid varchar(32) default '' not null,
	factory varchar(16) default '' not null,
	tag varchar(32) default '' not null,
	title varchar(32) default '' not null,
	projectid varchar(64) default '' not null,
	timecreate bigint unsigned default '0' not null,
	location geometry null,
	ext text null,
	debug tinyint(1) default '0' not null,
	lastupdate bigint unsigned default '0' not null,
	description varchar(255) default '' not null
)
engine=InnoDB
;

create table collectormonitor
(
	id varchar(20) not null
		primary key,
	hardware varchar(32) default '' not null,
	software varchar(32) default '' not null,
	ip varchar(30) default '' not null,
	port int default '0' not null,
	timecreate bigint unsigned not null,
	lastupdate bigint unsigned default '0' not null,
	enable tinyint(1) default '0' not null,
	ext text null
)
engine=InnoDB
;

create table costdaily201501
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201501 (project)
;

create index SENSOR
	on costdaily201501 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201501 (date, project, cost)
;

create index DATE
	on costdaily201501 (date)
;

create table costdaily201502
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201502 (project)
;

create index SENSOR
	on costdaily201502 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201502 (date, project, cost)
;

create index DATE
	on costdaily201502 (date)
;

create table costdaily201503
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201503 (project)
;

create index SENSOR
	on costdaily201503 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201503 (date, project, cost)
;

create index DATE
	on costdaily201503 (date)
;

create table costdaily201504
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201504 (project)
;

create index SENSOR
	on costdaily201504 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201504 (date, project, cost)
;

create index DATE
	on costdaily201504 (date)
;

create table costdaily201505
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201505 (project)
;

create index SENSOR
	on costdaily201505 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201505 (date, project, cost)
;

create index DATE
	on costdaily201505 (date)
;

create table costdaily201506
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201506 (project)
;

create index SENSOR
	on costdaily201506 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201506 (date, project, cost)
;

create index DATE
	on costdaily201506 (date)
;

create table costdaily201507
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201507 (project)
;

create index SENSOR
	on costdaily201507 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201507 (date, project, cost)
;

create index DATE
	on costdaily201507 (date)
;

create table costdaily201508
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201508 (project)
;

create index SENSOR
	on costdaily201508 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201508 (date, project, cost)
;

create index DATE
	on costdaily201508 (date)
;

create table costdaily201509
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201509 (project)
;

create index SENSOR
	on costdaily201509 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201509 (date, project, cost)
;

create index DATE
	on costdaily201509 (date)
;

create table costdaily201510
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201510 (project)
;

create index SENSOR
	on costdaily201510 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201510 (date, project, cost)
;

create index DATE
	on costdaily201510 (date)
;

create table costdaily201511
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201511 (project)
;

create index SENSOR
	on costdaily201511 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201511 (date, project, cost)
;

create index DATE
	on costdaily201511 (date)
;

create table costdaily201512
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201512 (project)
;

create index SENSOR
	on costdaily201512 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201512 (date, project, cost)
;

create index DATE
	on costdaily201512 (date)
;

create table costdaily201601
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201601 (project)
;

create index SENSOR
	on costdaily201601 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201601 (date, project, cost)
;

create index DATE
	on costdaily201601 (date)
;

create table costdaily201602
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201602 (project)
;

create index SENSOR
	on costdaily201602 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201602 (date, project, cost)
;

create index DATE
	on costdaily201602 (date)
;

create table costdaily201603
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201603 (project)
;

create index SENSOR
	on costdaily201603 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201603 (date, project, cost)
;

create index DATE
	on costdaily201603 (date)
;

create table costdaily201604
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201604 (project)
;

create index SENSOR
	on costdaily201604 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201604 (date, project, cost)
;

create index DATE
	on costdaily201604 (date)
;

create table costdaily201605
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201605 (project)
;

create index SENSOR
	on costdaily201605 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201605 (date, project, cost)
;

create index DATE
	on costdaily201605 (date)
;

create table costdaily201606
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201606 (project)
;

create index SENSOR
	on costdaily201606 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201606 (date, project, cost)
;

create index DATE
	on costdaily201606 (date)
;

create table costdaily201607
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201607 (project)
;

create index SENSOR
	on costdaily201607 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201607 (date, project, cost)
;

create index DATE
	on costdaily201607 (date)
;

create table costdaily201608
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201608 (project)
;

create index SENSOR
	on costdaily201608 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201608 (date, project, cost)
;

create index DATE
	on costdaily201608 (date)
;

create table costdaily201609
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201609 (project)
;

create index SENSOR
	on costdaily201609 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201609 (date, project, cost)
;

create index DATE
	on costdaily201609 (date)
;

create table costdaily201610
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201610 (project)
;

create index SENSOR
	on costdaily201610 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201610 (date, project, cost)
;

create index DATE
	on costdaily201610 (date)
;

create table costdaily201611
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201611 (project)
;

create index SENSOR
	on costdaily201611 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201611 (date, project, cost)
;

create index DATE
	on costdaily201611 (date)
;

create table costdaily201612
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201612 (project)
;

create index SENSOR
	on costdaily201612 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201612 (date, project, cost)
;

create index DATE
	on costdaily201612 (date)
;

create table costdaily201701
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201701 (project)
;

create index SENSOR
	on costdaily201701 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201701 (date, project, cost)
;

create index DATE
	on costdaily201701 (date)
;

create table costdaily201702
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201702 (project)
;

create index SENSOR
	on costdaily201702 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201702 (date, project, cost)
;

create index DATE
	on costdaily201702 (date)
;

create table costdaily201703
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201703 (project)
;

create index SENSOR
	on costdaily201703 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201703 (date, project, cost)
;

create index DATE
	on costdaily201703 (date)
;

create table costdaily201704
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201704 (project)
;

create index SENSOR
	on costdaily201704 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201704 (date, project, cost)
;

create index DATE
	on costdaily201704 (date)
;

create table costdaily201705
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201705 (project)
;

create index SENSOR
	on costdaily201705 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201705 (date, project, cost)
;

create index DATE
	on costdaily201705 (date)
;

create table costdaily201706
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201706 (project)
;

create index SENSOR
	on costdaily201706 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201706 (date, project, cost)
;

create index DATE
	on costdaily201706 (date)
;

create table costdaily201707
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201707 (project)
;

create index SENSOR
	on costdaily201707 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201707 (date, project, cost)
;

create index DATE
	on costdaily201707 (date)
;

create table costdaily201708
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201708 (project)
;

create index SENSOR
	on costdaily201708 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201708 (date, project, cost)
;

create index DATE
	on costdaily201708 (date)
;

create table costdaily201709
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned default '0' null,
	`hour.1` bigint unsigned default '0' null,
	`hour.2` bigint unsigned default '0' null,
	`hour.3` bigint unsigned default '0' null,
	`hour.4` bigint unsigned default '0' null,
	`hour.5` bigint unsigned default '0' null,
	`hour.6` bigint unsigned default '0' null,
	`hour.7` bigint unsigned default '0' null,
	`hour.8` bigint unsigned default '0' null,
	`hour.9` bigint unsigned default '0' null,
	`hour.10` bigint unsigned default '0' null,
	`hour.11` bigint unsigned default '0' null,
	`hour.12` bigint unsigned default '0' null,
	`hour.13` bigint unsigned default '0' null,
	`hour.14` bigint unsigned default '0' null,
	`hour.15` bigint unsigned default '0' null,
	`hour.16` bigint unsigned default '0' null,
	`hour.17` bigint unsigned default '0' null,
	`hour.18` bigint unsigned default '0' null,
	`hour.19` bigint unsigned default '0' null,
	`hour.20` bigint unsigned default '0' null,
	`hour.21` bigint unsigned default '0' null,
	`hour.22` bigint unsigned default '0' null,
	`hour.23` bigint unsigned default '0' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201709 (project)
;

create index SENSOR
	on costdaily201709 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201709 (date, project, cost)
;

create index DATE
	on costdaily201709 (date)
;

create table costdaily201710
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned null,
	`hour.1` bigint unsigned null,
	`hour.2` bigint unsigned null,
	`hour.3` bigint unsigned null,
	`hour.4` bigint unsigned null,
	`hour.5` bigint unsigned null,
	`hour.6` bigint unsigned null,
	`hour.7` bigint unsigned null,
	`hour.8` bigint unsigned null,
	`hour.9` bigint unsigned null,
	`hour.10` bigint unsigned null,
	`hour.11` bigint unsigned null,
	`hour.12` bigint unsigned null,
	`hour.13` bigint unsigned null,
	`hour.14` bigint unsigned null,
	`hour.15` bigint unsigned null,
	`hour.16` bigint unsigned null,
	`hour.17` bigint unsigned null,
	`hour.18` bigint unsigned null,
	`hour.19` bigint unsigned null,
	`hour.20` bigint unsigned null,
	`hour.21` bigint unsigned null,
	`hour.22` bigint unsigned null,
	`hour.23` bigint unsigned null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201710 (project)
;

create index SENSOR
	on costdaily201710 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201710 (date, project, cost)
;

create index DATE
	on costdaily201710 (date)
;

create table costdaily201711
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned null,
	`hour.1` bigint unsigned null,
	`hour.2` bigint unsigned null,
	`hour.3` bigint unsigned null,
	`hour.4` bigint unsigned null,
	`hour.5` bigint unsigned null,
	`hour.6` bigint unsigned null,
	`hour.7` bigint unsigned null,
	`hour.8` bigint unsigned null,
	`hour.9` bigint unsigned null,
	`hour.10` bigint unsigned null,
	`hour.11` bigint unsigned null,
	`hour.12` bigint unsigned null,
	`hour.13` bigint unsigned null,
	`hour.14` bigint unsigned null,
	`hour.15` bigint unsigned null,
	`hour.16` bigint unsigned null,
	`hour.17` bigint unsigned null,
	`hour.18` bigint unsigned null,
	`hour.19` bigint unsigned null,
	`hour.20` bigint unsigned null,
	`hour.21` bigint unsigned null,
	`hour.22` bigint unsigned null,
	`hour.23` bigint unsigned null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201711 (project)
;

create index SENSOR
	on costdaily201711 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201711 (date, project, cost)
;

create index DATE
	on costdaily201711 (date)
;

create table costdaily201712
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned null,
	`hour.1` bigint unsigned null,
	`hour.2` bigint unsigned null,
	`hour.3` bigint unsigned null,
	`hour.4` bigint unsigned null,
	`hour.5` bigint unsigned null,
	`hour.6` bigint unsigned null,
	`hour.7` bigint unsigned null,
	`hour.8` bigint unsigned null,
	`hour.9` bigint unsigned null,
	`hour.10` bigint unsigned null,
	`hour.11` bigint unsigned null,
	`hour.12` bigint unsigned null,
	`hour.13` bigint unsigned null,
	`hour.14` bigint unsigned null,
	`hour.15` bigint unsigned null,
	`hour.16` bigint unsigned null,
	`hour.17` bigint unsigned null,
	`hour.18` bigint unsigned null,
	`hour.19` bigint unsigned null,
	`hour.20` bigint unsigned null,
	`hour.21` bigint unsigned null,
	`hour.22` bigint unsigned null,
	`hour.23` bigint unsigned null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201712 (project)
;

create index SENSOR
	on costdaily201712 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201712 (date, project, cost)
;

create index DATE
	on costdaily201712 (date)
;

create table costdaily201801
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned null,
	`hour.1` bigint unsigned null,
	`hour.2` bigint unsigned null,
	`hour.3` bigint unsigned null,
	`hour.4` bigint unsigned null,
	`hour.5` bigint unsigned null,
	`hour.6` bigint unsigned null,
	`hour.7` bigint unsigned null,
	`hour.8` bigint unsigned null,
	`hour.9` bigint unsigned null,
	`hour.10` bigint unsigned null,
	`hour.11` bigint unsigned null,
	`hour.12` bigint unsigned null,
	`hour.13` bigint unsigned null,
	`hour.14` bigint unsigned null,
	`hour.15` bigint unsigned null,
	`hour.16` bigint unsigned null,
	`hour.17` bigint unsigned null,
	`hour.18` bigint unsigned null,
	`hour.19` bigint unsigned null,
	`hour.20` bigint unsigned null,
	`hour.21` bigint unsigned null,
	`hour.22` bigint unsigned null,
	`hour.23` bigint unsigned null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201801 (project)
;

create index SENSOR
	on costdaily201801 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201801 (date, project, cost)
;

create index DATE
	on costdaily201801 (date)
;

create table costdaily201802
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned null,
	`hour.1` bigint unsigned null,
	`hour.2` bigint unsigned null,
	`hour.3` bigint unsigned null,
	`hour.4` bigint unsigned null,
	`hour.5` bigint unsigned null,
	`hour.6` bigint unsigned null,
	`hour.7` bigint unsigned null,
	`hour.8` bigint unsigned null,
	`hour.9` bigint unsigned null,
	`hour.10` bigint unsigned null,
	`hour.11` bigint unsigned null,
	`hour.12` bigint unsigned null,
	`hour.13` bigint unsigned null,
	`hour.14` bigint unsigned null,
	`hour.15` bigint unsigned null,
	`hour.16` bigint unsigned null,
	`hour.17` bigint unsigned null,
	`hour.18` bigint unsigned null,
	`hour.19` bigint unsigned null,
	`hour.20` bigint unsigned null,
	`hour.21` bigint unsigned null,
	`hour.22` bigint unsigned null,
	`hour.23` bigint unsigned null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201802 (project)
;

create index SENSOR
	on costdaily201802 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201802 (date, project, cost)
;

create index DATE
	on costdaily201802 (date)
;

create table costdaily201803
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned null,
	`hour.1` bigint unsigned null,
	`hour.2` bigint unsigned null,
	`hour.3` bigint unsigned null,
	`hour.4` bigint unsigned null,
	`hour.5` bigint unsigned null,
	`hour.6` bigint unsigned null,
	`hour.7` bigint unsigned null,
	`hour.8` bigint unsigned null,
	`hour.9` bigint unsigned null,
	`hour.10` bigint unsigned null,
	`hour.11` bigint unsigned null,
	`hour.12` bigint unsigned null,
	`hour.13` bigint unsigned null,
	`hour.14` bigint unsigned null,
	`hour.15` bigint unsigned null,
	`hour.16` bigint unsigned null,
	`hour.17` bigint unsigned null,
	`hour.18` bigint unsigned null,
	`hour.19` bigint unsigned null,
	`hour.20` bigint unsigned null,
	`hour.21` bigint unsigned null,
	`hour.22` bigint unsigned null,
	`hour.23` bigint unsigned null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201803 (project)
;

create index SENSOR
	on costdaily201803 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201803 (date, project, cost)
;

create index DATE
	on costdaily201803 (date)
;

create table costdaily201804
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned null,
	`hour.1` bigint unsigned null,
	`hour.2` bigint unsigned null,
	`hour.3` bigint unsigned null,
	`hour.4` bigint unsigned null,
	`hour.5` bigint unsigned null,
	`hour.6` bigint unsigned null,
	`hour.7` bigint unsigned null,
	`hour.8` bigint unsigned null,
	`hour.9` bigint unsigned null,
	`hour.10` bigint unsigned null,
	`hour.11` bigint unsigned null,
	`hour.12` bigint unsigned null,
	`hour.13` bigint unsigned null,
	`hour.14` bigint unsigned null,
	`hour.15` bigint unsigned null,
	`hour.16` bigint unsigned null,
	`hour.17` bigint unsigned null,
	`hour.18` bigint unsigned null,
	`hour.19` bigint unsigned null,
	`hour.20` bigint unsigned null,
	`hour.21` bigint unsigned null,
	`hour.22` bigint unsigned null,
	`hour.23` bigint unsigned null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201804 (project)
;

create index SENSOR
	on costdaily201804 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201804 (date, project, cost)
;

create index DATE
	on costdaily201804 (date)
;

create table costdaily201805
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned null,
	`hour.1` bigint unsigned null,
	`hour.2` bigint unsigned null,
	`hour.3` bigint unsigned null,
	`hour.4` bigint unsigned null,
	`hour.5` bigint unsigned null,
	`hour.6` bigint unsigned null,
	`hour.7` bigint unsigned null,
	`hour.8` bigint unsigned null,
	`hour.9` bigint unsigned null,
	`hour.10` bigint unsigned null,
	`hour.11` bigint unsigned null,
	`hour.12` bigint unsigned null,
	`hour.13` bigint unsigned null,
	`hour.14` bigint unsigned null,
	`hour.15` bigint unsigned null,
	`hour.16` bigint unsigned null,
	`hour.17` bigint unsigned null,
	`hour.18` bigint unsigned null,
	`hour.19` bigint unsigned null,
	`hour.20` bigint unsigned null,
	`hour.21` bigint unsigned null,
	`hour.22` bigint unsigned null,
	`hour.23` bigint unsigned null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201805 (project)
;

create index SENSOR
	on costdaily201805 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201805 (date, project, cost)
;

create index DATE
	on costdaily201805 (date)
;

create table costdaily201806
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned null,
	`hour.1` bigint unsigned null,
	`hour.2` bigint unsigned null,
	`hour.3` bigint unsigned null,
	`hour.4` bigint unsigned null,
	`hour.5` bigint unsigned null,
	`hour.6` bigint unsigned null,
	`hour.7` bigint unsigned null,
	`hour.8` bigint unsigned null,
	`hour.9` bigint unsigned null,
	`hour.10` bigint unsigned null,
	`hour.11` bigint unsigned null,
	`hour.12` bigint unsigned null,
	`hour.13` bigint unsigned null,
	`hour.14` bigint unsigned null,
	`hour.15` bigint unsigned null,
	`hour.16` bigint unsigned null,
	`hour.17` bigint unsigned null,
	`hour.18` bigint unsigned null,
	`hour.19` bigint unsigned null,
	`hour.20` bigint unsigned null,
	`hour.21` bigint unsigned null,
	`hour.22` bigint unsigned null,
	`hour.23` bigint unsigned null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201806 (project)
;

create index SENSOR
	on costdaily201806 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201806 (date, project, cost)
;

create index DATE
	on costdaily201806 (date)
;

create table costdaily201807
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	cost decimal(18,2) default '0.00' null,
	`hour.0` bigint unsigned null,
	`hour.1` bigint unsigned null,
	`hour.2` bigint unsigned null,
	`hour.3` bigint unsigned null,
	`hour.4` bigint unsigned null,
	`hour.5` bigint unsigned null,
	`hour.6` bigint unsigned null,
	`hour.7` bigint unsigned null,
	`hour.8` bigint unsigned null,
	`hour.9` bigint unsigned null,
	`hour.10` bigint unsigned null,
	`hour.11` bigint unsigned null,
	`hour.12` bigint unsigned null,
	`hour.13` bigint unsigned null,
	`hour.14` bigint unsigned null,
	`hour.15` bigint unsigned null,
	`hour.16` bigint unsigned null,
	`hour.17` bigint unsigned null,
	`hour.18` bigint unsigned null,
	`hour.19` bigint unsigned null,
	`hour.20` bigint unsigned null,
	`hour.21` bigint unsigned null,
	`hour.22` bigint unsigned null,
	`hour.23` bigint unsigned null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on costdaily201807 (project)
;

create index SENSOR
	on costdaily201807 (sensor)
;

create index DATEPROJECTCOST
	on costdaily201807 (date, project, cost)
;

create index DATE
	on costdaily201807 (date)
;

create table customer
(
	id varchar(64) not null
		primary key,
	project varchar(64) not null,
	socities text not null,
	constraint INDEX_ID
		unique (id)
)
comment '社会属性表' engine=InnoDB
;

create table customerflatten
(
	project varchar(64) not null comment '社会属性对应的项目ID',
	`key` varchar(128) not null comment '社会属性的ID',
	parent varchar(128) not null comment '社会属性父级ID',
	title varchar(64) default '' not null comment '社会属性名称',
	area int default '0' not null comment '社会属性面积',
	primary key (project, `key`, parent)
)
engine=InnoDB
;

create index PROJECTKEYPARENTINDEX
	on customerflatten (project, `key`, parent)
;

create index PROJECTKEYINDEX
	on customerflatten (project, `key`)
;

create index PROJECTINDEX
	on customerflatten (project)
;

create table databuffer
(
	id char(32) not null
		primary key,
	sensor char(32) not null,
	value decimal(18,2) not null,
	total decimal(18,2) not null,
	timestamp bigint(11) not null
)
engine=InnoDB charset=latin1
;

create index SENSORTIMESTAMPINDEX
	on databuffer (sensor, timestamp)
;

create table datadaily
(
	id bigint unsigned auto_increment,
	sensor varchar(64) not null comment '传感器ID',
	timepoint bigint default '0' not null comment '数据时间戳',
	value decimal(18,2) default '0.00' not null comment '当日总用量',
	total decimal(18,2) default '0.00' not null comment '当日最后刻度',
	`hour.0` decimal(18,2) default '0.00' not null,
	`hour.1` decimal(18,2) default '0.00' not null,
	`hour.2` decimal(18,2) default '0.00' not null,
	`hour.3` decimal(18,2) default '0.00' not null,
	`hour.4` decimal(18,2) default '0.00' not null,
	`hour.5` decimal(18,2) default '0.00' not null,
	`hour.6` decimal(18,2) default '0.00' not null,
	`hour.7` decimal(18,2) default '0.00' not null,
	`hour.8` decimal(18,2) default '0.00' not null,
	`hour.9` decimal(18,2) default '0.00' not null,
	`hour.10` decimal(18,2) default '0.00' not null,
	`hour.11` decimal(18,2) default '0.00' not null,
	`hour.12` decimal(18,2) default '0.00' not null,
	`hour.13` decimal(18,2) default '0.00' not null,
	`hour.14` decimal(18,2) default '0.00' not null,
	`hour.15` decimal(18,2) default '0.00' not null,
	`hour.16` decimal(18,2) default '0.00' not null,
	`hour.17` decimal(18,2) default '0.00' not null,
	`hour.18` decimal(18,2) default '0.00' not null,
	`hour.19` decimal(18,2) default '0.00' not null,
	`hour.20` decimal(18,2) default '0.00' not null,
	`hour.21` decimal(18,2) default '0.00' not null,
	`hour.22` decimal(18,2) default '0.00' not null,
	`hour.23` decimal(18,2) default '0.00' not null,
	primary key (id, sensor, timepoint),
	constraint IDINDEX
		unique (id),
	constraint TIMEPOINTSENSORINDEX
		unique (sensor, timepoint)
)
comment '数据分表 日表' engine=InnoDB
;

create index TIMEPOINTINDEX
	on datadaily (timepoint, id)
;

create table dataprotocol
(
	id int unsigned auto_increment
		primary key,
	`key` varchar(32) not null,
	type int default '0' not null,
	mType int default '0' not null,
	ext varchar(8) default '0' not null,
	code varchar(128) not null,
	name varchar(64) default '' not null,
	devicetype text null
)
engine=InnoDB
;

create index `key`
	on dataprotocol (`key`)
;

create index type
	on dataprotocol (type)
;

create table dataprotocolchannel
(
	dpid int unsigned default '0' not null,
	code varchar(128) default '' not null,
	emchannel int(8) null,
	enable tinyint default '0' null,
	remark varchar(64) default '' null,
	primary key (dpid, code)
)
engine=InnoDB
;

create table department
(
	tid bigint unsigned default '0' not null
		primary key,
	title varchar(64) default '' null,
	tag varchar(64) default '' null,
	area decimal(18) null,
	onduty char(8) default '08:00' null,
	offduty char(8) default '17:00' null,
	account varchar(128) null,
	project varchar(64) null,
	timecreate bigint unsigned default '0' null,
	timedelete bigint unsigned default '0' null,
	timepause bigint unsigned default '0' null,
	resource text null,
	arrearagetime bigint unsigned default '0' null,
	remindercount int default '0' null,
	rechargeable tinyint(1) null,
	description varchar(255) default '' null,
	status int default '0' not null
)
engine=InnoDB
;

create index project
	on department (project)
;

create table departmentflatten
(
	id varchar(128) not null,
	`key` varchar(64) not null comment '权限资源Key',
	value varchar(255) default '' not null comment '权限资源值',
	type varchar(16) not null comment '资源类型(project/building/sensor)',
	timefrom bigint default '0' not null comment '有效期起始',
	timeto bigint default '0' not null comment '有效期截止',
	description varchar(255) not null comment '描述',
	primary key (id, `key`, value, type)
)
comment '用户权限资源表' engine=InnoDB
;

create index KEY_ACCOUNT_INDEX
	on departmentflatten (`key`)
;

create table departmentgroup
(
	id bigint unsigned auto_increment
		primary key,
	title varchar(64) null,
	project varchar(64) null,
	description varchar(255) null
)
engine=InnoDB
;

create table departmentgrouplists
(
	id bigint unsigned default '0' not null,
	department varchar(64) default '' not null,
	primary key (id, department)
)
engine=InnoDB
;

create table departmenthistory
(
	id bigint unsigned auto_increment
		primary key,
	account varchar(128) null,
	title varchar(64) null,
	project varchar(64) null,
	`from` bigint unsigned null,
	`to` bigint unsigned null
)
engine=InnoDB
;

create table devicecommandqueue
(
	cmdid varchar(64) default '' not null
		primary key,
	session varchar(64) null,
	operator varchar(128) null,
	buildingid char(4) null,
	gatewayid char(2) null,
	addrid char(14) null,
	meterid char(3) null,
	word varchar(32) null,
	auid varchar(128) null,
	request text null,
	response text null,
	code int null,
	timecreate bigint null,
	timeprocess bigint null,
	timedone bigint null
)
engine=InnoDB
;

create table devicetype
(
	id bigint unsigned auto_increment
		primary key,
	name varchar(16) default '' null,
	`key` varchar(32) default '' null,
	code varchar(8) default '' null,
	channelids text null,
	measure text null,
	paycategory varchar(32) default '' not null
)
engine=InnoDB
;

create table ecdaily201501
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201501 (project)
;

create index SENSOR
	on ecdaily201501 (sensor)
;

create index DATE
	on ecdaily201501 (date)
;

create table ecdaily201502
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201502 (project)
;

create index SENSOR
	on ecdaily201502 (sensor)
;

create index DATE
	on ecdaily201502 (date)
;

create table ecdaily201503
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201503 (project)
;

create index SENSOR
	on ecdaily201503 (sensor)
;

create index DATE
	on ecdaily201503 (date)
;

create table ecdaily201504
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201504 (project)
;

create index SENSOR
	on ecdaily201504 (sensor)
;

create index DATE
	on ecdaily201504 (date)
;

create table ecdaily201505
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201505 (project)
;

create index SENSOR
	on ecdaily201505 (sensor)
;

create index DATE
	on ecdaily201505 (date)
;

create table ecdaily201506
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201506 (project)
;

create index SENSOR
	on ecdaily201506 (sensor)
;

create index DATE
	on ecdaily201506 (date)
;

create table ecdaily201507
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201507 (project)
;

create index SENSOR
	on ecdaily201507 (sensor)
;

create index DATE
	on ecdaily201507 (date)
;

create table ecdaily201508
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201508 (project)
;

create index SENSOR
	on ecdaily201508 (sensor)
;

create index DATE
	on ecdaily201508 (date)
;

create table ecdaily201509
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201509 (project)
;

create index SENSOR
	on ecdaily201509 (sensor)
;

create index DATE
	on ecdaily201509 (date)
;

create table ecdaily201510
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201510 (project)
;

create index SENSOR
	on ecdaily201510 (sensor)
;

create index DATE
	on ecdaily201510 (date)
;

create table ecdaily201511
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201511 (project)
;

create index SENSOR
	on ecdaily201511 (sensor)
;

create index DATE
	on ecdaily201511 (date)
;

create table ecdaily201512
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201512 (project)
;

create index SENSOR
	on ecdaily201512 (sensor)
;

create index DATE
	on ecdaily201512 (date)
;

create table ecdaily201601
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201601 (project)
;

create index SENSOR
	on ecdaily201601 (sensor)
;

create index DATE
	on ecdaily201601 (date)
;

create table ecdaily201602
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201602 (project)
;

create index SENSOR
	on ecdaily201602 (sensor)
;

create index DATE
	on ecdaily201602 (date)
;

create table ecdaily201603
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201603 (project)
;

create index SENSOR
	on ecdaily201603 (sensor)
;

create index DATE
	on ecdaily201603 (date)
;

create table ecdaily201604
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201604 (project)
;

create index SENSOR
	on ecdaily201604 (sensor)
;

create index DATE
	on ecdaily201604 (date)
;

create table ecdaily201605
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201605 (project)
;

create index SENSOR
	on ecdaily201605 (sensor)
;

create index DATE
	on ecdaily201605 (date)
;

create table ecdaily201606
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201606 (project)
;

create index SENSOR
	on ecdaily201606 (sensor)
;

create index DATE
	on ecdaily201606 (date)
;

create table ecdaily201607
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201607 (project)
;

create index SENSOR
	on ecdaily201607 (sensor)
;

create index DATE
	on ecdaily201607 (date)
;

create table ecdaily201608
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201608 (project)
;

create index SENSOR
	on ecdaily201608 (sensor)
;

create index DATE
	on ecdaily201608 (date)
;

create table ecdaily201609
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201609 (project)
;

create index SENSOR
	on ecdaily201609 (sensor)
;

create index DATE
	on ecdaily201609 (date)
;

create table ecdaily201610
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201610 (project)
;

create index SENSOR
	on ecdaily201610 (sensor)
;

create index DATE
	on ecdaily201610 (date)
;

create table ecdaily201611
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201611 (project)
;

create index SENSOR
	on ecdaily201611 (sensor)
;

create index DATE
	on ecdaily201611 (date)
;

create table ecdaily201612
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201612 (project)
;

create index SENSOR
	on ecdaily201612 (sensor)
;

create index DATE
	on ecdaily201612 (date)
;

create table ecdaily201701
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201701 (project)
;

create index SENSOR
	on ecdaily201701 (sensor)
;

create index DATE
	on ecdaily201701 (date)
;

create table ecdaily201702
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201702 (project)
;

create index SENSOR
	on ecdaily201702 (sensor)
;

create index DATE
	on ecdaily201702 (date)
;

create table ecdaily201703
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201703 (project)
;

create index SENSOR
	on ecdaily201703 (sensor)
;

create index DATE
	on ecdaily201703 (date)
;

create table ecdaily201704
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201704 (project)
;

create index SENSOR
	on ecdaily201704 (sensor)
;

create index DATE
	on ecdaily201704 (date)
;

create table ecdaily201705
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201705 (project)
;

create index SENSOR
	on ecdaily201705 (sensor)
;

create index DATE
	on ecdaily201705 (date)
;

create table ecdaily201706
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201706 (project)
;

create index SENSOR
	on ecdaily201706 (sensor)
;

create index DATE
	on ecdaily201706 (date)
;

create table ecdaily201707
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201707 (project)
;

create index SENSOR
	on ecdaily201707 (sensor)
;

create index DATE
	on ecdaily201707 (date)
;

create table ecdaily201708
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201708 (project)
;

create index SENSOR
	on ecdaily201708 (sensor)
;

create index DATE
	on ecdaily201708 (date)
;

create table ecdaily201709
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201709 (project)
;

create index SENSOR
	on ecdaily201709 (sensor)
;

create index DATE
	on ecdaily201709 (date)
;

create table ecdaily201710
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201710 (project)
;

create index SENSOR
	on ecdaily201710 (sensor)
;

create index DATE
	on ecdaily201710 (date)
;

create table ecdaily201711
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201711 (project)
;

create index SENSOR
	on ecdaily201711 (sensor)
;

create index DATE
	on ecdaily201711 (date)
;

create table ecdaily201712
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201712 (project)
;

create index SENSOR
	on ecdaily201712 (sensor)
;

create index DATE
	on ecdaily201712 (date)
;

create table ecdaily201801
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201801 (project)
;

create index SENSOR
	on ecdaily201801 (sensor)
;

create index DATE
	on ecdaily201801 (date)
;

create table ecdaily201802
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201802 (project)
;

create index SENSOR
	on ecdaily201802 (sensor)
;

create index DATE
	on ecdaily201802 (date)
;

create table ecdaily201803
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201803 (project)
;

create index SENSOR
	on ecdaily201803 (sensor)
;

create index DATE
	on ecdaily201803 (date)
;

create table ecdaily201804
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201804 (project)
;

create index SENSOR
	on ecdaily201804 (sensor)
;

create index DATE
	on ecdaily201804 (date)
;

create table ecdaily201805
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201805 (project)
;

create index SENSOR
	on ecdaily201805 (sensor)
;

create index DATE
	on ecdaily201805 (date)
;

create table ecdaily201806
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201806 (project)
;

create index SENSOR
	on ecdaily201806 (sensor)
;

create index DATE
	on ecdaily201806 (date)
;

create table ecdaily201807
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on ecdaily201807 (project)
;

create index SENSOR
	on ecdaily201807 (sensor)
;

create index DATE
	on ecdaily201807 (date)
;

create table entfundaccount
(
	id varchar(64) not null comment '企业ID（项目ID）'
		primary key,
	cash decimal(18,2) not null comment '可提现金额'
)
engine=InnoDB
;

create table event
(
	id varchar(64) not null comment '事件ID'
		primary key,
	project varchar(64) not null comment '事件归属项目ID',
	type varchar(16) not null comment '事件类型',
	uid varchar(128) not null comment '发起事件的用户ID',
	detail text not null comment '事件主体JSON',
	constraint IDINDEX
		unique (id)
)
comment '事件表' engine=InnoDB
;

create index IDTYPEUIDINDEX
	on event (type, uid, id)
;

create table eventqueue
(
	id bigint unsigned auto_increment
		primary key,
	type bigint unsigned not null,
	timestamp bigint unsigned not null,
	param text null
)
engine=InnoDB
;

create table eventschedule
(
	project varchar(64) not null comment '项目ID',
	templateid bigint not null comment '事件模板id',
	gateway varchar(128) not null comment '事件支持网关',
	primary key (project, templateid)
)
engine=InnoDB
;

create table eventservice
(
	id varchar(64) not null
		primary key,
	title varchar(128) not null,
	events text not null comment '适用事件列表',
	project varchar(64) not null comment '项目ID',
	description varchar(255) not null,
	rules text not null comment '规则'
)
engine=InnoDB
;

create table eventtemplate
(
	id bigint unsigned auto_increment comment '主键'
		primary key,
	name varchar(64) not null comment '事件名称',
	`key` varchar(64) not null comment '事件关键字',
	type enum('TIMER', 'EVENT') null comment '事件类型(TIMER定时/EVENT事件)',
	gateway varchar(128) not null comment '支持网关类型',
	`desc` text not null comment '描述'
)
engine=InnoDB
;

create table formula
(
	id bigint unsigned auto_increment
		primary key,
	title varchar(64) null,
	formula text null,
	`desc` text null
)
engine=InnoDB
;

create table fundaccount
(
	uid varchar(128) default '' not null
		primary key,
	cash bigint default '0' null,
	consume bigint default '0' null,
	frozen bigint default '0' null,
	expire bigint default '0' null,
	alerthreshold bigint default '0' null,
	timeupdate bigint default '0' null,
	timedelete bigint default '0' null
)
engine=InnoDB
;

create table fundaccount_copy
(
	uid varchar(128) default '' not null
		primary key,
	cash bigint default '0' null,
	consume bigint default '0' null,
	frozen bigint default '0' null,
	expire bigint default '0' null,
	alerthreshold bigint default '0' null,
	timeupdate bigint default '0' null,
	timedelete bigint default '0' null
)
engine=InnoDB
;

create table funddetails
(
	id char(46) default '' not null
		primary key,
	category varchar(32) null,
	orderno varchar(64) default '' null,
	`from` varchar(128) null,
	`to` varchar(128) null,
	project varchar(64) null,
	chargeid varchar(64) null,
	transaction varchar(128) null,
	channelaccount bigint unsigned null,
	amount decimal(18,4) null,
	balance decimal(18,4) null,
	proposer varchar(128) null,
	checker varchar(128) null,
	operator varchar(128) null,
	subject varchar(32) null,
	body varchar(128) null,
	description varchar(255) null,
	metadata text null,
	timecreate bigint default '0' null,
	timecheck bigint default '0' null,
	timepaid bigint default '0' null,
	timereversal bigint default '0' null,
	status enum('CHECKING', 'PROCESSING', 'SUCCESS', 'FAILED', 'CHECKFAILED') null
)
engine=InnoDB
;

create index WITHDRAW
	on funddetails (category, `from`, timecreate, status)
;

create index ACCOUNTBAL
	on funddetails (category, `to`, timecreate, status)
;

create index ORDERNO
	on funddetails (orderno)
;

create index FROMTO
	on funddetails (`from`, `to`)
;

create index PROJECT
	on funddetails (project, status, category, timecreate)
;

create index TIMECREATE
	on funddetails (timecreate)
;

create table funddetails_2015
(
	id char(46) default '' not null
		primary key,
	category varchar(32) null,
	orderno varchar(64) default '' null,
	`from` varchar(128) null,
	`to` varchar(128) null,
	project varchar(64) null,
	chargeid varchar(64) null,
	transaction varchar(128) null,
	channelaccount bigint unsigned null,
	amount decimal(18,4) null,
	balance decimal(18,4) null,
	proposer varchar(128) null,
	checker varchar(128) null,
	operator varchar(128) null,
	subject varchar(32) null,
	body varchar(128) null,
	description varchar(255) null,
	metadata text null,
	timecreate bigint default '0' null,
	timecheck bigint default '0' null,
	timepaid bigint default '0' null,
	timereversal bigint default '0' null,
	status enum('CHECKING', 'PROCESSING', 'SUCCESS', 'FAILED', 'CHECKFAILED') null
)
engine=InnoDB
;

create index WITHDRAW
	on funddetails_2015 (category, `from`, timecreate, status)
;

create index ACCOUNTBAL
	on funddetails_2015 (category, `to`, timecreate, status)
;

create index ORDERNO
	on funddetails_2015 (orderno)
;

create index FROMTO
	on funddetails_2015 (`from`, `to`)
;

create index PROJECT
	on funddetails_2015 (project, status, category, timecreate)
;

create index TIMECREATE
	on funddetails_2015 (timecreate)
;

create table interactionconfig
(
	projectid varchar(128) not null,
	mid bigint unsigned not null,
	sms tinyint(1) default '1' not null,
	wechat tinyint(1) default '1' not null,
	app tinyint(1) default '1' not null,
	email tinyint(1) default '1' not null,
	web tinyint(1) default '1' not null,
	primary key (projectid, mid)
)
engine=InnoDB
;

create table interactiondetail
(
	id bigint unsigned auto_increment
		primary key,
	session varchar(64) default '' null,
	`from` varchar(128) default '' null,
	`to` varchar(128) default '' null,
	content text null,
	project varchar(64) null,
	timecreate bigint unsigned null,
	timeread bigint unsigned null,
	timepost bigint unsigned null,
	operator varchar(128) default '' null,
	type int unsigned default '0' null
)
engine=InnoDB
;

create table interactiontypes
(
	mid bigint unsigned not null
		primary key,
	title varchar(16) default '' not null,
	sms tinyint(1) default '0' not null,
	wechat tinyint(1) default '0' not null,
	app tinyint(1) default '0' not null,
	email tinyint(1) default '0' not null,
	web tinyint(1) default '0' not null
)
engine=InnoDB
;

create table moduleeventconfig
(
	id bigint unsigned auto_increment
		primary key,
	projectid varchar(64) default '' not null,
	module varchar(16) not null,
	`key` varchar(16) not null,
	value varchar(20) not null
)
engine=InnoDB
;

create table notifymessage
(
	id char(22) default '' not null
		primary key,
	session char(23) default '' null,
	`from` varchar(64) default '' null,
	`to` varchar(64) default '' null,
	content text null,
	link varchar(255) null,
	projectid varchar(64) default '' null,
	timecreate bigint unsigned default '0' null,
	timeread bigint unsigned default '0' null,
	timedelete bigint unsigned default '0' null,
	operator varchar(128) default '' null,
	type int unsigned default '0' null
)
engine=InnoDB
;

create table notifymessage201703
(
	id char(22) default '' not null
		primary key,
	session char(23) default '' null,
	`from` varchar(128) default '' null,
	`to` varchar(128) default '' null,
	content text null,
	link varchar(255) null,
	project varchar(64) null,
	timecreate bigint unsigned default '0' null,
	timeread bigint unsigned default '0' null,
	timedelete bigint unsigned default '0' null,
	operator varchar(128) default '' null,
	type int unsigned default '0' null
)
engine=InnoDB
;

create index session
	on notifymessage201703 (session)
;

create index `from`
	on notifymessage201703 (`from`)
;

create index `to`
	on notifymessage201703 (`to`)
;

create index project
	on notifymessage201703 (project)
;

create index type
	on notifymessage201703 (type)
;

create table notifymessage201704
(
	id char(22) default '' not null
		primary key,
	session char(23) default '' null,
	`from` varchar(128) default '' null,
	`to` varchar(128) default '' null,
	content text null,
	link varchar(255) null,
	project varchar(64) null,
	timecreate bigint unsigned default '0' null,
	timeread bigint unsigned default '0' null,
	timedelete bigint unsigned default '0' null,
	operator varchar(128) default '' null,
	type int unsigned default '0' null
)
engine=InnoDB
;

create index session
	on notifymessage201704 (session)
;

create index `from`
	on notifymessage201704 (`from`)
;

create index `to`
	on notifymessage201704 (`to`)
;

create index project
	on notifymessage201704 (project)
;

create index type
	on notifymessage201704 (type)
;

create table notifymessage201705
(
	id char(22) default '' not null
		primary key,
	session char(23) default '' null,
	`from` varchar(128) default '' null,
	`to` varchar(128) default '' null,
	content text null,
	link varchar(255) null,
	project varchar(64) null,
	timecreate bigint unsigned default '0' null,
	timeread bigint unsigned default '0' null,
	timedelete bigint unsigned default '0' null,
	operator varchar(128) default '' null,
	type int unsigned default '0' null
)
engine=InnoDB
;

create index session
	on notifymessage201705 (session)
;

create index `from`
	on notifymessage201705 (`from`)
;

create index `to`
	on notifymessage201705 (`to`)
;

create index project
	on notifymessage201705 (project)
;

create index type
	on notifymessage201705 (type)
;

create table notifymessage201706
(
	id char(22) default '' not null
		primary key,
	session char(23) default '' null,
	`from` varchar(128) default '' null,
	`to` varchar(128) default '' null,
	content text null,
	link varchar(255) null,
	project varchar(64) null,
	timecreate bigint unsigned default '0' null,
	timeread bigint unsigned default '0' null,
	timedelete bigint unsigned default '0' null,
	operator varchar(128) default '' null,
	type int unsigned default '0' null
)
engine=InnoDB
;

create index session
	on notifymessage201706 (session)
;

create index `from`
	on notifymessage201706 (`from`)
;

create index `to`
	on notifymessage201706 (`to`)
;

create index project
	on notifymessage201706 (project)
;

create index type
	on notifymessage201706 (type)
;

create table notifymessage201707
(
	id char(22) default '' not null
		primary key,
	session char(23) default '' null,
	`from` varchar(128) default '' null,
	`to` varchar(128) default '' null,
	content text null,
	link varchar(255) null,
	project varchar(64) null,
	timecreate bigint unsigned default '0' null,
	timeread bigint unsigned default '0' null,
	timedelete bigint unsigned default '0' null,
	operator varchar(128) default '' null,
	type int unsigned default '0' null
)
engine=InnoDB
;

create index session
	on notifymessage201707 (session)
;

create index `from`
	on notifymessage201707 (`from`)
;

create index `to`
	on notifymessage201707 (`to`)
;

create index project
	on notifymessage201707 (project)
;

create index type
	on notifymessage201707 (type)
;

create table notifymessage201708
(
	id char(22) default '' not null
		primary key,
	session char(23) default '' null,
	`from` varchar(128) default '' null,
	`to` varchar(128) default '' null,
	content text null,
	link varchar(255) null,
	project varchar(64) null,
	timecreate bigint unsigned default '0' null,
	timeread bigint unsigned default '0' null,
	timedelete bigint unsigned default '0' null,
	operator varchar(128) default '' null,
	type int unsigned default '0' null
)
engine=InnoDB
;

create index session
	on notifymessage201708 (session)
;

create index `from`
	on notifymessage201708 (`from`)
;

create index `to`
	on notifymessage201708 (`to`)
;

create index project
	on notifymessage201708 (project)
;

create index type
	on notifymessage201708 (type)
;

create table origindaily201501
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201501 (project)
;

create index SENSOR
	on origindaily201501 (sensor)
;

create index DATE
	on origindaily201501 (date)
;

create table origindaily201502
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201502 (project)
;

create index SENSOR
	on origindaily201502 (sensor)
;

create index DATE
	on origindaily201502 (date)
;

create table origindaily201512
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201512 (project)
;

create index SENSOR
	on origindaily201512 (sensor)
;

create index DATE
	on origindaily201512 (date)
;

create table origindaily201601
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201601 (project)
;

create index SENSOR
	on origindaily201601 (sensor)
;

create index DATE
	on origindaily201601 (date)
;

create table origindaily201602
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201602 (project)
;

create index SENSOR
	on origindaily201602 (sensor)
;

create index DATE
	on origindaily201602 (date)
;

create table origindaily201603
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201603 (project)
;

create index SENSOR
	on origindaily201603 (sensor)
;

create index DATE
	on origindaily201603 (date)
;

create table origindaily201604
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201604 (project)
;

create index SENSOR
	on origindaily201604 (sensor)
;

create index DATE
	on origindaily201604 (date)
;

create table origindaily201605
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201605 (project)
;

create index SENSOR
	on origindaily201605 (sensor)
;

create index DATE
	on origindaily201605 (date)
;

create table origindaily201606
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201606 (project)
;

create index SENSOR
	on origindaily201606 (sensor)
;

create index DATE
	on origindaily201606 (date)
;

create table origindaily201607
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201607 (project)
;

create index SENSOR
	on origindaily201607 (sensor)
;

create index DATE
	on origindaily201607 (date)
;

create table origindaily201608
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201608 (project)
;

create index SENSOR
	on origindaily201608 (sensor)
;

create index DATE
	on origindaily201608 (date)
;

create table origindaily201609
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201609 (project)
;

create index SENSOR
	on origindaily201609 (sensor)
;

create index DATE
	on origindaily201609 (date)
;

create table origindaily201610
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,2) null,
	total decimal(18,2) null,
	`hour.0` decimal(18,2) default '0.00' null,
	`hour.1` decimal(18,2) default '0.00' null,
	`hour.2` decimal(18,2) default '0.00' null,
	`hour.3` decimal(18,2) default '0.00' null,
	`hour.4` decimal(18,2) default '0.00' null,
	`hour.5` decimal(18,2) default '0.00' null,
	`hour.6` decimal(18,2) default '0.00' null,
	`hour.7` decimal(18,2) default '0.00' null,
	`hour.8` decimal(18,2) default '0.00' null,
	`hour.9` decimal(18,2) default '0.00' null,
	`hour.10` decimal(18,2) default '0.00' null,
	`hour.11` decimal(18,2) default '0.00' null,
	`hour.12` decimal(18,2) default '0.00' null,
	`hour.13` decimal(18,2) default '0.00' null,
	`hour.14` decimal(18,2) default '0.00' null,
	`hour.15` decimal(18,2) default '0.00' null,
	`hour.16` decimal(18,2) default '0.00' null,
	`hour.17` decimal(18,2) default '0.00' null,
	`hour.18` decimal(18,2) default '0.00' null,
	`hour.19` decimal(18,2) default '0.00' null,
	`hour.20` decimal(18,2) default '0.00' null,
	`hour.21` decimal(18,2) default '0.00' null,
	`hour.22` decimal(18,2) default '0.00' null,
	`hour.23` decimal(18,2) default '0.00' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201610 (project)
;

create index SENSOR
	on origindaily201610 (sensor)
;

create index DATE
	on origindaily201610 (date)
;

create table origindaily201611
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201611 (project)
;

create index SENSOR
	on origindaily201611 (sensor)
;

create index DATE
	on origindaily201611 (date)
;

create table origindaily201612
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201612 (project)
;

create index SENSOR
	on origindaily201612 (sensor)
;

create index DATE
	on origindaily201612 (date)
;

create table origindaily201701
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201701 (project)
;

create index SENSOR
	on origindaily201701 (sensor)
;

create index DATE
	on origindaily201701 (date)
;

create table origindaily201702
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201702 (project)
;

create index SENSOR
	on origindaily201702 (sensor)
;

create index DATE
	on origindaily201702 (date)
;

create table origindaily201703
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201703 (project)
;

create index SENSOR
	on origindaily201703 (sensor)
;

create index DATE
	on origindaily201703 (date)
;

create table origindaily201704
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201704 (project)
;

create index SENSOR
	on origindaily201704 (sensor)
;

create index DATE
	on origindaily201704 (date)
;

create table origindaily201705
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201705 (project)
;

create index SENSOR
	on origindaily201705 (sensor)
;

create index DATE
	on origindaily201705 (date)
;

create table origindaily201706
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201706 (project)
;

create index SENSOR
	on origindaily201706 (sensor)
;

create index DATE
	on origindaily201706 (date)
;

create table origindaily201707
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201707 (project)
;

create index SENSOR
	on origindaily201707 (sensor)
;

create index DATE
	on origindaily201707 (date)
;

create table origindaily201708
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) default '0.0000' null,
	`hour.1` decimal(18,4) default '0.0000' null,
	`hour.2` decimal(18,4) default '0.0000' null,
	`hour.3` decimal(18,4) default '0.0000' null,
	`hour.4` decimal(18,4) default '0.0000' null,
	`hour.5` decimal(18,4) default '0.0000' null,
	`hour.6` decimal(18,4) default '0.0000' null,
	`hour.7` decimal(18,4) default '0.0000' null,
	`hour.8` decimal(18,4) default '0.0000' null,
	`hour.9` decimal(18,4) default '0.0000' null,
	`hour.10` decimal(18,4) default '0.0000' null,
	`hour.11` decimal(18,4) default '0.0000' null,
	`hour.12` decimal(18,4) default '0.0000' null,
	`hour.13` decimal(18,4) default '0.0000' null,
	`hour.14` decimal(18,4) default '0.0000' null,
	`hour.15` decimal(18,4) default '0.0000' null,
	`hour.16` decimal(18,4) default '0.0000' null,
	`hour.17` decimal(18,4) default '0.0000' null,
	`hour.18` decimal(18,4) default '0.0000' null,
	`hour.19` decimal(18,4) default '0.0000' null,
	`hour.20` decimal(18,4) default '0.0000' null,
	`hour.21` decimal(18,4) default '0.0000' null,
	`hour.22` decimal(18,4) default '0.0000' null,
	`hour.23` decimal(18,4) default '0.0000' null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201708 (project)
;

create index SENSOR
	on origindaily201708 (sensor)
;

create index DATE
	on origindaily201708 (date)
;

create table origindaily201709
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201709 (project)
;

create index SENSOR
	on origindaily201709 (sensor)
;

create index DATE
	on origindaily201709 (date)
;

create table origindaily201710
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201710 (project)
;

create index SENSOR
	on origindaily201710 (sensor)
;

create index DATE
	on origindaily201710 (date)
;

create table origindaily201711
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201711 (project)
;

create index SENSOR
	on origindaily201711 (sensor)
;

create index DATE
	on origindaily201711 (date)
;

create table origindaily201712
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201712 (project)
;

create index SENSOR
	on origindaily201712 (sensor)
;

create index DATE
	on origindaily201712 (date)
;

create table origindaily201801
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201801 (project)
;

create index SENSOR
	on origindaily201801 (sensor)
;

create index DATE
	on origindaily201801 (date)
;

create table origindaily201802
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201802 (project)
;

create index SENSOR
	on origindaily201802 (sensor)
;

create index DATE
	on origindaily201802 (date)
;

create table origindaily201803
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201803 (project)
;

create index SENSOR
	on origindaily201803 (sensor)
;

create index DATE
	on origindaily201803 (date)
;

create table origindaily201804
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201804 (project)
;

create index SENSOR
	on origindaily201804 (sensor)
;

create index DATE
	on origindaily201804 (date)
;

create table origindaily201805
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201805 (project)
;

create index SENSOR
	on origindaily201805 (sensor)
;

create index DATE
	on origindaily201805 (date)
;

create table origindaily201806
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201806 (project)
;

create index SENSOR
	on origindaily201806 (sensor)
;

create index DATE
	on origindaily201806 (date)
;

create table origindaily201807
(
	project varchar(64) default '' not null,
	sensor varchar(128) default '' not null,
	date int default '0' not null,
	value decimal(18,4) null,
	total decimal(18,4) null,
	`hour.0` decimal(18,4) null,
	`hour.1` decimal(18,4) null,
	`hour.2` decimal(18,4) null,
	`hour.3` decimal(18,4) null,
	`hour.4` decimal(18,4) null,
	`hour.5` decimal(18,4) null,
	`hour.6` decimal(18,4) null,
	`hour.7` decimal(18,4) null,
	`hour.8` decimal(18,4) null,
	`hour.9` decimal(18,4) null,
	`hour.10` decimal(18,4) null,
	`hour.11` decimal(18,4) null,
	`hour.12` decimal(18,4) null,
	`hour.13` decimal(18,4) null,
	`hour.14` decimal(18,4) null,
	`hour.15` decimal(18,4) null,
	`hour.16` decimal(18,4) null,
	`hour.17` decimal(18,4) null,
	`hour.18` decimal(18,4) null,
	`hour.19` decimal(18,4) null,
	`hour.20` decimal(18,4) null,
	`hour.21` decimal(18,4) null,
	`hour.22` decimal(18,4) null,
	`hour.23` decimal(18,4) null,
	primary key (project, sensor, date)
)
engine=InnoDB
;

create index PROJECT
	on origindaily201807 (project)
;

create index SENSOR
	on origindaily201807 (sensor)
;

create index DATE
	on origindaily201807 (date)
;

create table packageplan
(
	id bigint unsigned auto_increment
		primary key,
	title varchar(64) null,
	project varchar(64) null,
	price decimal(18,2) default '0.00' null,
	rent text null,
	value decimal(18,2) default '0.00' null,
	type varchar(32) null,
	timecreate bigint unsigned default '0' null,
	timeexpire bigint unsigned default '0' null
)
engine=InnoDB
;

create table packagestrategy
(
	id bigint unsigned auto_increment
		primary key,
	packageid bigint unsigned default '0' null,
	validmonth bigint unsigned default '0' null,
	validfrom bigint unsigned default '0' null,
	validto bigint unsigned default '0' null,
	flag int default '0' null,
	month int default '0' null,
	week int default '0' null,
	day int default '0' null,
	hour int default '0' null,
	minute int default '0' null
)
engine=InnoDB
;

create table plttransferdetails
(
	id char(46) default '' not null
		primary key,
	orderno varchar(64) null,
	project varchar(64) null,
	transaction varchar(128) null,
	channelaccount bigint unsigned null,
	transferchannel varchar(16) null,
	amount decimal(18,2) null,
	subject varchar(32) null,
	description varchar(255) null,
	timecreate bigint default '0' null,
	timepaid bigint default '0' null,
	timedone bigint default '0' null,
	timereversal bigint default '0' null,
	status enum('CHECKING', 'PROCESSING', 'SUCCESS', 'FAILED', 'CHECKFAILED') null
)
engine=InnoDB
;

create table project
(
	id char(64) not null comment '项目ID'
		primary key,
	title varchar(32) default '' not null comment '项目名称',
	level int default '0' not null comment '项目级别',
	energy text not null comment '项目下辖的能耗分类',
	onduty char(8) not null comment '上班时间',
	offduty char(8) not null comment '下班时间',
	description varchar(255) default '' not null comment '项目描述',
	constraint IDINDEX
		unique (id)
)
comment '项目表' engine=InnoDB
;

create table projectauditsettings
(
	id bigint unsigned auto_increment
		primary key,
	projectId varchar(64) not null,
	time bigint unsigned not null,
	value text null,
	createdAt datetime null,
	updatedAt datetime null,
	deletedAt datetime null
)
engine=InnoDB
;

create table projectbuildings
(
	projectid char(64) default '' not null,
	buildingid char(64) default '' not null,
	primary key (projectid, buildingid)
)
engine=InnoDB
;

create index projectid
	on projectbuildings (projectid)
;

create index buildingid
	on projectbuildings (buildingid)
;

create table resource
(
	id varchar(128) not null,
	`key` varchar(64) not null comment '权限资源Key',
	value varchar(255) default '' not null comment '权限资源值',
	type varchar(16) not null comment '资源类型(project/building/sensor)',
	timefrom bigint default '0' not null comment '有效期起始',
	timeto bigint default '0' not null comment '有效期截止',
	description varchar(255) not null comment '描述',
	primary key (id, `key`, value, type)
)
comment '用户权限资源表' engine=InnoDB
;

create index KEY_ACCOUNT_INDEX
	on resource (`key`)
;

create table resourcebase
(
	id varchar(128) not null,
	`key` varchar(64) not null comment '权限资源Key',
	value varchar(255) default '' not null comment '权限资源值',
	type varchar(16) not null comment '资源类型(project/building/sensor)',
	timefrom bigint default '0' not null comment '有效期起始',
	timeto bigint default '0' not null comment '有效期截止',
	description varchar(255) not null comment '描述',
	primary key (id, `key`, value)
)
comment '用户权限资源表' engine=InnoDB
;

create index KEY_ACCOUNT_INDEX
	on resourcebase (`key`)
;

create table rtqueue
(
	id bigint unsigned auto_increment
		primary key,
	type int not null,
	timestamp bigint unsigned not null,
	message text null
)
engine=InnoDB
;

create table sensor
(
	id varchar(128) not null comment '传感器通道ID'
		primary key,
	channelid varchar(64) not null comment '传感器通道ID（可变）',
	tag varchar(32) default '' not null comment '传感器标识',
	title varchar(32) not null comment '传感器名称',
	description varchar(255) default '' not null comment '传感器通道描述',
	project varchar(64) not null comment '项目ID',
	building varchar(64) not null comment '建筑ID',
	socity text not null comment '社会属性JSON结构',
	paystatus char(16) default 'NONE' not null comment '计费形式',
	mask tinyint(1) default '0' not null comment '是否屏蔽传感器',
	freq int default '1800' not null comment '传感器更新频率',
	lasttotal decimal(18,2) default '0.00' not null comment '最近一次读数刻度',
	lastvalue decimal(18,2) default '0.00' not null comment '最近一次差值',
	lastupdate bigint default '0' not null comment '最近一次读数更新时间',
	realdata decimal(18,2) default '0.00' not null comment '传感器实时读数',
	energy varchar(128) not null comment '传感器通道能耗分类',
	energypath varchar(255) default '' not null comment '传感器通道能耗子分类'
)
comment '传感器通道表' engine=InnoDB
;

create index SIDINDEX
	on sensor (channelid)
;

create index PROJECTINDEX
	on sensor (project)
;

create index PROJECTBUILDINGINDEX
	on sensor (building, project)
;

create table sensor_copy
(
	id varchar(128) not null comment '传感器通道ID'
		primary key,
	sensorid varchar(64) not null comment '传感器通道ID（可变）',
	title varchar(32) not null comment '传感器名称',
	channel varchar(32) default '' not null comment '通道名称',
	description varchar(255) default '' not null comment '传感器通道描述',
	project varchar(64) not null comment '项目ID',
	building varchar(64) not null comment '建筑ID',
	socity text not null comment '社会属性JSON结构',
	paystatus char(16) default '''NONE''' not null comment '计费形式',
	mask tinyint(1) default '0' not null comment '是否屏蔽传感器',
	freq int default '1800' not null comment '传感器更新频率',
	lasttotal decimal(18,2) default '0.00' not null comment '最近一次读数刻度',
	lastvalue decimal(18,2) default '0.00' not null comment '最近一次差值',
	lastupdate bigint default '0' not null comment '最近一次读数更新时间',
	realdata decimal(18,2) default '0.00' not null comment '传感器实时读数',
	energy varchar(128) not null comment '传感器通道能耗分类',
	energypath varchar(255) default '' not null comment '传感器通道能耗子分类',
	constraint IDINDEX
		unique (id)
)
comment '传感器通道表' engine=InnoDB
;

create index SIDINDEX
	on sensor_copy (sensorid)
;

create index PROJECTINDEX
	on sensor_copy (project)
;

create table sensorattribute
(
	id varchar(64) not null comment '传感器ID'
		primary key,
	addrid varchar(32) not null comment '传感器设备ID',
	devicetype varchar(32) not null comment '设备类型',
	tag varchar(64) not null comment '传感器标识',
	title varchar(64) not null comment '传感器名称',
	driver varchar(255) not null comment '驱动文件',
	ext text not null comment '传感器扩展属性',
	project varchar(64) not null comment '传感器所属项目ID',
	auid varchar(128) not null comment '采集器标识',
	status text not null comment '传感器状态',
	lastupdate bigint not null,
	constraint IDINDEX
		unique (id)
)
comment '传感器属性信息表' engine=InnoDB
;

create index PROJECTINDEX
	on sensorattribute (project)
;

create index AUIDINDEX
	on sensorattribute (auid)
;

create table sensorchannel
(
	id varchar(128) default '' not null
		primary key,
	eid varchar(64) null,
	sid varchar(64) null,
	description varchar(255) null,
	project varchar(64) null,
	building varchar(64) null,
	mask tinyint(1) null,
	timecreate bigint unsigned null,
	timedelete bigint unsigned null
)
engine=InnoDB
;

create index EID
	on sensorchannel (eid)
;

create table sensorcommandqueue
(
	id bigint unsigned auto_increment
		primary key,
	uid varchar(16) not null,
	status varchar(8) not null,
	meterid varchar(4) not null,
	buildingid varchar(10) not null,
	gatewayid varchar(2) not null,
	addrid varchar(14) not null,
	command text null,
	retry int default '3' not null,
	auid varchar(128) not null,
	code int default '0' not null,
	reqdata text null,
	respdata text null,
	timecreate bigint not null,
	timeprocess bigint default '0' not null,
	timedone bigint default '0' not null
)
engine=InnoDB
;

create table sensors
(
	id varchar(64) default '' not null
		primary key,
	manufacturer int unsigned default '0' null,
	equipment int unsigned default '0' null,
	tag varchar(64) default '' null,
	title varchar(64) default '' null,
	project varchar(64) null,
	freq int unsigned default '0' null,
	energy varchar(32) null,
	energypath varchar(128) null,
	auid varchar(128) default '' null,
	status text null,
	share varchar(16) null,
	timeupdate bigint unsigned default '0' null,
	timecreate bigint unsigned default '0' null,
	timedelete bigint unsigned default '0' null
)
engine=InnoDB
;

create index TAG
	on sensors (tag)
;

create index TITLE
	on sensors (title)
;

create index PROJECT
	on sensors (project)
;

create table socities
(
	id bigint unsigned auto_increment,
	`key` varchar(255) default '' null,
	parent bigint unsigned default '0' null,
	path varchar(255) default '' null,
	project varchar(64) default '' not null,
	title varchar(255) default '' null,
	type varchar(16) default '' null,
	category varchar(32) default '' null,
	formula text null,
	enable tinyint default '0' null,
	primary key (id, project)
)
engine=InnoDB
;

create index PATHTYPEKEY
	on socities (project, `key`, path, type)
;

create table socities_copy
(
	id bigint unsigned auto_increment,
	`key` varchar(255) default '' null,
	parent bigint unsigned default '0' null,
	path varchar(255) default '' null,
	project varchar(64) default '' not null,
	title varchar(255) default '' null,
	type enum('NODE', 'DEV') default 'NODE' null,
	category enum('TOPOLOGY') default 'TOPOLOGY' null,
	primary key (id, project)
)
engine=InnoDB
;

create index PATHTYPEKEY
	on socities_copy (project, `key`, path, type)
;

create table subentrytype
(
	id varchar(32) not null
		primary key,
	name varchar(16) default '' null,
	code varchar(16) default '' null,
	standcol decimal(8,4) default '1.0000' null
)
engine=InnoDB
;

create table topology
(
	id varchar(64) not null comment '传感器ID',
	project varchar(64) not null comment '项目ID',
	type varchar(64) not null comment '拓扑类型',
	level varchar(16) not null comment '拓扑级别',
	under varchar(16) not null comment '归属于拓扑级别',
	primary key (id, project)
)
engine=InnoDB
;


create table userauthority
(
	uid varchar(128) not null,
	project varchar(64) not null,
	url varchar(255) not null,
	enable tinyint(1) null,
	primary key (uid, project, url)
)
engine=InnoDB
;

create table usermoduleeventconfig
(
	id bigint unsigned auto_increment
		primary key,
	projectid varchar(64) default '' not null,
	module varchar(16) not null,
	uid bigint unsigned not null,
	`key` varchar(16) not null,
	value varchar(20) not null
)
engine=InnoDB
;

create table userpackage
(
	uid varchar(128) default '' not null,
	packageplan bigint unsigned default '0' not null,
	value bigint default '0' null,
	`from` bigint default '0' null,
	`to` bigint default '0' null,
	primary key (uid, packageplan)
)
engine=InnoDB
;

create table withdrawpending
(
	id varchar(64) default '' not null
		primary key,
	cnt int null
)
engine=InnoDB
;

create table wxopeniduser
(
	openid varchar(64) default '' not null
		primary key,
	platformid varchar(64) null,
	user varchar(128) null
)
engine=InnoDB
;

create table wxplatform
(
	platformid varchar(32) default '' not null
		primary key,
	name varchar(64) null,
	map varchar(32) null,
	appid varchar(64) null,
	appsecret varchar(128) null,
	token varchar(512) default '' not null,
	enable tinyint(1) default '0' not null,
	timeupdate bigint unsigned default '0' not null,
	jsapiticket varchar(128) default '' not null
)
engine=InnoDB
;

create table if not exists `vendorAccounts`
(
	`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
`projectId` bigint(20) UNSIGNED NOT NULL,
`loginURL` varchar(255) NULL,
`vendorProject` varchar(255) NULL,
`username` varchar(32) NULL,
`password` varchar(255) NULL,
`memo` TEXT,
`createdAt` datetime(0) NOT NULL,
`updatedAt` datetime(0) NOT NULL,
`deletedAt` datetime(0) NULL,
PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB;


create view viewaccounts as
SELECT
    `ac`.`uid`         AS `uid`,
    `ac`.`user`        AS `user`,
    `ac`.`passwd`      AS `passwd`,
    `ac`.`ctrlpasswd`  AS `ctrlpasswd`,
    `ac`.`title`       AS `title`,
    `ac`.`lastlogin`   AS `lastlogin`,
    `ac`.`character`   AS `character`,
    `ac`.`resource`    AS `resource`,
    `ac`.`expire`      AS `expire`,
    `ac`.`token`       AS `token`,
    `ac`.`type`        AS `type`,
    `ac`.`mobile`      AS `mobile`,
    `ac`.`email`       AS `email`,
    `ac`.`timecreate`  AS `timecreate`,
    `ac`.`timedelete`  AS `timedelete`,
    `ac`.`timepause`   AS `timepause`,
    `ac`.`description` AS `description`,
    `ca`.`title`       AS `charactertitle`,
    `ca`.`rule`        AS `rule`,
    `ca`.`level`       AS `level`
  FROM (`energymanage`.`account` `ac`
    JOIN `energymanage`.`character` `ca` ON ((`ca`.`id` = `ac`.`character`)));

create view viewbillingstrategy as
SELECT
    `bs`.`id`          AS `id`,
    `bel`.`euid`       AS `euid`,
    `bs`.`title`       AS `title`,
    `bs`.`projectid`   AS `projectid`,
    `bs`.`rules`       AS `rules`,
    `bs`.`description` AS `description`,
    `bs`.`timecreate`  AS `timecreate`,
    `bs`.`timeexpire`  AS `timeexpire`
  FROM (`energymanage`.`billingequiplink` `bel` LEFT JOIN `energymanage`.`billingstrategy` `bs`
      ON ((`bel`.`billingid` = `bs`.`id`)));

create view viewchannels as
SELECT
    `energymanage`.`sensor`.`id`                                                                              AS `id`,
    `energymanage`.`sensor`.`channelid`                                                                       AS `channelid`,
    left(`energymanage`.`sensor`.`channelid`,
         27)                                                                                                  AS `sensorid`,
    concat(left(`energymanage`.`sensor`.`channelid`, 12), substr(`energymanage`.`sensor`.`channelid`, 24,
                                                                 3))                                          AS `ctpid`,
    `energymanage`.`sensor`.`title`                                                                           AS `title`,
    `energymanage`.`sensor`.`tag`                                                                             AS `tag`,
    `energymanage`.`sensor`.`socity`                                                                          AS `socity`,
    `energymanage`.`sensor`.`paystatus`                                                                       AS `paystatus`,
    `energymanage`.`sensor`.`mask`                                                                            AS `mask`,
    `energymanage`.`sensor`.`freq`                                                                            AS `freq`,
    `energymanage`.`sensor`.`lasttotal`                                                                       AS `lasttotal`,
    `energymanage`.`sensor`.`lastvalue`                                                                       AS `lastvalue`,
    `energymanage`.`sensor`.`lastupdate`                                                                      AS `lastupdate`,
    `energymanage`.`sensor`.`realdata`                                                                        AS `realdata`,
    `energymanage`.`sensor`.`energy`                                                                          AS `energy`,
    `energymanage`.`sensor`.`energypath`                                                                      AS `energypath`,
    `energymanage`.`buildings`.`id`                                                                            AS `buildingid`,
    `energymanage`.`buildings`.`title`                                                                         AS `buildingtitle`,
    `energymanage`.`buildings`.`acreage`                                                                          AS `area`,
    `energymanage`.`buildings`.`avgconsumption`                                                                AS `avgconsumption`,
    `energymanage`.`project`.`id`                                                                             AS `projectid`,
    `energymanage`.`project`.`title`                                                                          AS `projecttitle`,
    `energymanage`.`project`.`energy`                                                                         AS `projectenergy`
  FROM ((`energymanage`.`sensor`
    JOIN `energymanage`.`buildings` ON ((`energymanage`.`sensor`.`building` = `energymanage`.`buildings`.`id`))) JOIN
    `energymanage`.`project` ON ((`energymanage`.`sensor`.`project` = `energymanage`.`project`.`id`)));

create view viewdepartments as
SELECT
    `dp`.`tid`           AS `tid`,
    `dp`.`title`         AS `title`,
    `dp`.`tag`           AS `tag`,
    `dp`.`area`          AS `area`,
    `dp`.`onduty`        AS `onduty`,
    `dp`.`offduty`       AS `offduty`,
    `dp`.`account`       AS `account`,
    `dp`.`project`       AS `project`,
    `dp`.`timecreate`    AS `timecreate`,
    `dp`.`timedelete`    AS `timedelete`,
    `dp`.`timepause`     AS `timepause`,
    `dp`.`resource`      AS `resource`,
    `dp`.`arrearagetime` AS `arrearagetime`,
    `dp`.`remindercount` AS `remindercount`,
    `dp`.`rechargeable`  AS `rechargeable`,
    `dp`.`description`   AS `description`,
    `dp`.`status`        AS `status`,
    `ac`.`uid`           AS `uid`,
    `ac`.`passwd`        AS `passwd`,
    `ac`.`title`         AS `usertitle`,
    `ac`.`mobile`        AS `mobile`,
    `ac`.`email`         AS `email`,
    `ac`.`timecreate`    AS `rentstarttime`,
    `ac`.`timedelete`    AS `accounttimedelete`,
    `ac`.`lastlogin`     AS `lastlogin`,
    `fa`.`cash`          AS `cash`,
    `fa`.`frozen`        AS `frozen`,
    `fa`.`alerthreshold` AS `alerthreshold`
  FROM
    ((`energymanage`.`department` `dp` LEFT JOIN `energymanage`.`account` `ac` ON ((`dp`.`account` = `ac`.`user`))) JOIN
      `energymanage`.`fundaccount` `fa` ON ((`dp`.`tid` = `fa`.`uid`)));

create view viewpackagestrategy as
SELECT
    `ps`.`id`         AS `id`,
    `ps`.`packageid`  AS `packageid`,
    `ps`.`validmonth` AS `validmonth`,
    `ps`.`validfrom`  AS `validfrom`,
    `ps`.`validto`    AS `validto`,
    `ps`.`flag`       AS `flag`,
    `ps`.`month`      AS `month`,
    `ps`.`week`       AS `week`,
    `ps`.`day`        AS `day`,
    `ps`.`hour`       AS `hour`,
    `ps`.`minute`     AS `minute`,
    `pp`.`title`      AS `title`,
    `pp`.`project`    AS `project`,
    `pp`.`price`      AS `price`,
    `pp`.`rent`       AS `rent`,
    `pp`.`value`      AS `value`,
    `pp`.`type`       AS `type`,
    `pp`.`timecreate` AS `timecreate`,
    `pp`.`timeexpire` AS `timeexpire`
  FROM (`energymanage`.`packagestrategy` `ps`
    JOIN `energymanage`.`packageplan` `pp` ON ((`ps`.`packageid` = `pp`.`id`)));

create table if not exists `NBReading`
(
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `content` TEXT NULL,
  `createdAt` datetime(0) NULL,
  `updatedAt` datetime(0) NULL,
  `deletedAt` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB;


CREATE TABLE energymanage.urlpath
(
    id varchar(255) DEFAULT '' PRIMARY KEY NOT NULL,
    enable tinyint(1) DEFAULT '0' NOT NULL,
    needlogin tinyint(1) DEFAULT '1' NOT NULL,
    needauth tinyint(1) DEFAULT '1' NOT NULL,
    inproject tinyint(1) DEFAULT '1' NOT NULL,
    description varchar(128) DEFAULT '' NOT NULL
);
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/account', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/account/amount', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/account/create', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/account/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/account/edit', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/account/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/account/roleres', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/appidsecret', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/appidsecret/create', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/appidsecret/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/appidsecret/edit', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/appidsecret/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/appidsecret/roleres', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/billingservice', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/billingservice/add', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/billingservice/adddaily', 1, 1, 0, 1, '日常计费-添加');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/billingservice/dailyinfo', 1, 1, 0, 1, '日常计费');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/billingservice/dailyupdate', 1, 1, 0, 1, '日常计费-更新');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/billingservice/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/billingservice/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/billingservice/manage', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/billingservice/update', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/building', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/building/create', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/building/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/building/edit', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/building/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/byapart', 1, 1, 1, 1, '分户属性');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/byapart/index', 1, 1, 1, 1, '主页面');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/bycategory', 1, 1, 1, 1, '分项属性');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/bycategory/index', 1, 1, 1, 1, '主页面');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/byitem', 1, 1, 1, 1, '分类属性');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/byitem/index', 1, 1, 1, 1, '主页面');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/character', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/character/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/character/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/character/manage', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/collector', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/collector/create', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/collector/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/collector/edit', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/collector/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/customer', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/customer/collectorsensor', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/customer/create', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/customer/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/customer/edit', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/customer/index', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/customer/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/department', 1, 1, 0, 1, '商户管理');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/department/create', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/department/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/department/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/department/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/device', 1, 1, 0, 1, '传感器类型管理');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/device/index', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/driver', 1, 1, 0, 1, '驱动设置');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/driver/index', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/energy', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/energy/index', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/energycategory', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/energycategory/add', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/energycategory/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/energycategory/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/energycategory/update', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/eventcategory', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/eventcategory/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/eventcategory/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/eventcategory/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/eventcategory/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/finance', 1, 1, 0, 1, '财务');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/finance/card', 1, 1, 0, 1, '银行卡');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/finance/card/detail', 1, 1, 0, 1, '申请详情');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/finance/index', 1, 1, 0, 1, '财务管理');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/finance/project', 1, 1, 0, 1, '项目列表');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/finance/project/info', 1, 1, 0, 1, '项目首页');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/finance/project/info/record', 1, 1, 0, 1, '收支明细');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/finance/project/info/withdraw', 1, 1, 0, 1, '转账');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/finance/record', 1, 1, 0, 1, '收支');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/finance/record/in', 1, 1, 0, 1, '收入');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/finance/record/in/project', 1, 1, 0, 1, '项目');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/finance/record/out', 1, 1, 0, 1, '支出');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/finance/record/out/project', 1, 1, 0, 1, '项目');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/finance/record/out/project/detail', 1, 1, 0, 1, '申请信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/login', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/main', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/pab', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/pab/add', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/pab/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/pab/edit', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/pab/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/project', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/project/auth', 1, 1, 0, 1, '权限');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/project/create', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/project/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/project/edit', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/project/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/property', 1, 1, 0, 1, '物业财务');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/property/consume', 1, 1, 0, 1, '消耗明细');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/property/index', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/property/record', 1, 1, 0, 1, '收支明细');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/property/statement', 1, 1, 0, 1, '对账单');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/property/withdraw', 1, 1, 0, 1, '申请提现');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/senioraccount', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/senioraccount/create', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/senioraccount/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/senioraccount/edit', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/senioraccount/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/senioraccount/roleres', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/sensor', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/sensor/create', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/sensor/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/sensor/edit', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/sensor/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/sensor/mask', 1, 1, 0, 1, '屏蔽传感器');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/sensor/syncdata', 1, 1, 0, 1, '异常同步');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/urlpath', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/urlpath/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/webapp', 1, 1, 0, 1, '物业中心');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/admin/webapp/index', 1, 1, 0, 1, '首页配置');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/account/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/account/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/account/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/account/passwd', 1, 1, 1, 1, '密码修改');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/account/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/appidsecret', 1, 1, 1, 1, 'APPID/SECRET');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/appidsecret/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/appidsecret/apply', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/appidsecret/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/appidsecret/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/appidsecret/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/apportionment', 1, 1, 0, 1, '分摊接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/apportionment/bind', 1, 1, 1, 1, '绑定分摊关系');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/apportionment/info', 1, 1, 1, 1, '查询分摊关系');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/apptemplate', 1, 1, 0, 1, 'app网页模板');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/apptemplate/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/apptemplate/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/apptemplate/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/apptemplate/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/auth/check', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/auth/login', 1, 0, 1, 1, '用户登录接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/auth/logout', 1, 0, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/auth/resource', 1, 1, 1, 1, '获取权限树');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/auth/updateproject', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/bank', 1, 1, 0, 1, '银行相关接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/bank/info', 1, 1, 1, 1, '支持的银行列表');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/bill', 1, 1, 0, 1, '账单接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/bill/add', 1, 1, 1, 1, '添加账单');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/bill/get', 1, 1, 1, 1, '查询账单状态');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/bill/list', 1, 1, 1, 1, '账单列表');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingaccount', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingaccount/add', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingaccount/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingaccount/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingaccount/update', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingservice', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingservice/add', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingservice/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingservice/equipments', 1, 1, 1, 1, '计费策略选表');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingservice/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingservice/switch', 1, 1, 1, 1, '交换优先级');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingservice/update', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingshare/add', 1, 1, 1, 1, '添加分摊策略');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingshare/delete', 1, 1, 1, 1, '删除分摊策略');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingshare/info', 1, 1, 1, 1, '分摊策略信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/billingshare/update', 1, 1, 1, 1, '修改分摊策略');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/broadcast/add', 1, 1, 0, 1, '创建广播');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/broadcast/info', 1, 1, 0, 1, '广播查询');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/building/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/building/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/building/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/building/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business', 1, 1, 0, 1, '业务接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/accountbalance', 1, 1, 1, 1, '账户资金详情');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/buildingstatistic', 1, 1, 1, 1, '建筑能耗费用统计');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/calendar', 1, 1, 1, 1, '月日历数据显示');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/channeldetail', 1, 1, 1, 1, '通道详细数据');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/channelstatistic', 1, 1, 1, 1, '通道数据统计');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/dailychargelog', 1, 1, 1, 1, '日充值信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/dailycost', 1, 1, 1, 1, '日费用显示');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/dailyfundsummary', 1, 1, 1, 1, '账务日汇总');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/dailyreport', 1, 1, 1, 1, '日能耗报表');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/dailysensordetail', 1, 1, 1, 1, '日传感器能耗显示');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/dailyusage', 1, 1, 1, 1, '日常用量');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/departmentconsumptiondetail', 1, 1, 1, 1, '商户消耗明细');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/departmentconsumptionstatistic', 1, 1, 1, 1, '商户消耗统计');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/departmentreport', 1, 1, 1, 1, '商户报表');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/departments', 1, 1, 1, 1, '商户信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/departmentusage', 1, 1, 1, 1, '商户能耗');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/devicedata', 1, 1, 1, 1, '设备日数据');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/energyconstitute', 1, 1, 1, 1, '能耗构成显示');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/energyconsumptioncost', 1, 1, 1, 1, '能耗费用');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/energydetail', 1, 1, 1, 1, '能耗分类详情');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/energyeffectiverate', 1, 1, 1, 1, '能效比');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/energyincomerate', 1, 1, 1, 1, '能耗收入比');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/energytimeline', 1, 1, 1, 1, '能耗时间轴');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/enterprisecash', 1, 1, 1, 1, '企业账户余额');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/fundconsumptiondetail', 1, 1, 1, 1, '项目消耗明细');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/fundflow', 1, 1, 1, 1, '资金流水');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/groupanalysis', 1, 1, 1, 1, '集团分析');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/monitor', 1, 1, 1, 1, '监控显示');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/monthlyaccountelectricusage', 1, 1, 1, 1, '账户所属商户用电统计');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/monthlycost', 1, 1, 1, 1, '月费用');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/monthlyfundsummary', 1, 1, 1, 1, '账务月汇总');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/monthlykgce', 1, 1, 1, 1, '月综合能耗显示');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/monthlyreport', 1, 1, 1, 1, '月能耗报表');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/monthlysensordetail', 1, 1, 1, 1, '月传感器能耗详情');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/monthlyusage', 1, 1, 1, 1, '月能耗用度');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/ordernodetail', 1, 1, 1, 1, '订单详情');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/pltfundflow', 1, 1, 1, 1, '平台资金流水');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/projectdetail', 1, 1, 1, 1, '项目详情');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/projectfundflowstatistic', 1, 1, 1, 1, '项目各项信息统计');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/projectreport', 1, 1, 1, 1, '项目总用能报表');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/projectYearKGCE', 1, 1, 1, 1, '项目年总能耗');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/recentchargelog', 1, 1, 1, 1, '近期充值信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/recentmonthcost', 1, 1, 1, 1, '近期月份费用');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/sensorusage', 1, 1, 1, 1, '传感器用量');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/settlereport', 1, 1, 1, 1, '结算报表');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/socitydetail', 1, 1, 1, 1, '社会属性能耗详情显示');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/socitystatistic', 1, 1, 1, 1, '社会属性能耗费用统计');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/socitytimeline', 1, 1, 1, 1, '社会属性能耗时间曲线');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/timequantumstatistic', 1, 1, 1, 1, '时间段能耗统计');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/userfundflow', 1, 1, 1, 1, '用户流水查询');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/business/userinfo', 1, 1, 1, 1, '用户信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/cache', 1, 0, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/cache/build', 1, 0, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/cache/build/day', 1, 0, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/cache/build/month', 1, 0, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/cache/build/week', 1, 0, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/cache/build/year', 1, 0, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/cache/get', 1, 0, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/cache/get/day', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/cache/sensor', 1, 0, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/cache/sensor/day', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/channelaccount', 1, 1, 0, 1, '渠道账户');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/channelaccount/', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/channelaccount/add', 1, 1, 1, 1, '添加账户');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/channelaccount/checking', 1, 1, 1, 1, '账户验证');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/channelaccount/delete', 1, 1, 1, 1, '删除账户');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/channelaccount/info', 1, 1, 1, 1, '账户信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/channelaccount/update', 1, 1, 1, 1, '更新账户');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/channelaccount/verifycode', 1, 1, 1, 1, '绑卡验证码');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/character', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/character/add', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/character/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/character/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/character/update', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/collector', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/collector/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/collector/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/collector/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/collector/status', 1, 1, 1, 1, '采集器状态切换');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/collector/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/control', 1, 1, 0, 1, '控制接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/control/driverinfo', 1, 1, 1, 1, '驱动信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/control/send', 1, 1, 1, 1, '发送控制指令');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/control/sensorcommand', 1, 1, 1, 1, '控制指令');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/control/statusquery', 1, 1, 1, 1, '查询控制命令状态');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/control/statussync', 1, 1, 1, 1, '同步传感器状态');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/control/syncscale', 1, 1, 1, 1, '同步刻度');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/control/syncsensor', 1, 1, 1, 1, '更新传感器属性');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/control/through', 1, 1, 1, 1, '指令透传');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/customer/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/customer/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/customer/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/customer/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/data/save', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/department', 1, 1, 0, 1, '户');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/department/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/department/contractflow', 1, 1, 1, 1, '合同相关的流水');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/department/contracts', 1, 1, 1, 1, '获取已经完成的商户合同');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/department/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/department/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/department/rent', 1, 1, 1, 1, '承租');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/department/reset', 1, 1, 1, 1, '重置账户');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/department/reuse', 1, 1, 1, 1, '重新启用账户');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/department/surrender', 1, 1, 1, 1, '退租');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/department/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/departmentgroup/add', 1, 1, 1, 1, '商户分组添加');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/departmentgroup/delete', 1, 1, 1, 1, '商户分组删除');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/departmentgroup/info', 1, 1, 1, 1, '商户分组查询');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/departmentgroup/update', 1, 1, 1, 1, '商户分组修改');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/departmentgrouplists/info', 1, 1, 1, 1, '商户分组列表查询');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/departmentgrouplists/update', 1, 1, 1, 1, '商户分组列表更新');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/device', 1, 1, 0, 1, '设备接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/device/type', 1, 1, 1, 1, '设备类型');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/driver', 1, 1, 0, 1, '驱动');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/driver/enum', 1, 1, 1, 1, '驱动枚举');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eca', 1, 1, 0, 1, '能耗分析');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eca/analysis', 1, 1, 1, 1, '查询分析结果');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eca/info', 1, 1, 1, 1, '查询分析节点');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eca/refresh', 1, 1, 1, 1, '自动生成节点');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eca/update', 1, 1, 1, 1, '操作能耗分析节点');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/energy/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/energy/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/energy/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/energy/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/energycategory', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/energycategory/add', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/energycategory/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/energycategory/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/energycategory/update', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/equipment', 1, 1, 0, 1, '厂家设备信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/equipment/info', 1, 1, 1, 1, '获取设备信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/event', 1, 1, 0, 1, '事件配置');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/event/info', 1, 1, 1, 1, '事件获取');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/event/update', 1, 1, 1, 1, '事件更新');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eventcategory', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eventcategory/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eventcategory/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eventcategory/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eventcategory/update', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eventservice', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eventservice/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eventservice/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eventservice/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/eventservice/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export', 1, 1, 0, 1, '导出相关接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export/consumptiondetail', 1, 1, 1, 1, '消耗明细');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export/dailyreport', 1, 1, 1, 1, '日报表导出');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export/departmentsinfo', 1, 1, 1, 1, '商户信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export/departmentstatistic', 1, 1, 1, 1, '商户导出');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export/equipments', 1, 1, 1, 1, '仪表信息导出');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export/monthlyreport', 1, 1, 1, 1, '月报表导出');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export/projectdailybill', 1, 1, 1, 1, '导出物业日账单');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export/projectdailyreceipt', 1, 1, 1, 1, '日对账回单');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export/projectflow', 1, 1, 1, 1, '导出资金流水');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export/projectmonthlybill', 1, 1, 1, 1, '导出物业月账单');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export/projectmonthlyreceipt', 1, 1, 1, 1, '月对账回单');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export/rechargerecipt', 1, 1, 1, 1, '充值回单');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export/sensorchannel', 1, 1, 1, 1, '传感器信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/export/settlereport', 1, 1, 1, 1, '结算报表导出');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/import', 1, 1, 0, 1, '导入相关接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/import/auditParameter', 1, 1, 1, 1, '审计参数导入');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/import/equipments', 1, 1, 1, 1, '导入仪表信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/import/importbatchrecharge', 1, 1, 1, 1, '批量充值');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/import/importdepartment', 1, 1, 1, 1, '导入商户');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/import/importsensorchannel', 1, 1, 1, 1, '导入传感器');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/interaction', 1, 1, 0, 1, '消息接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/interaction/remove', 1, 1, 1, 1, '删除资源');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/interaction/uploadtoken', 1, 1, 1, 1, '七牛云上传token');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/log', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/log/account', 1, 1, 1, 1, '账户日志查询');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/log/charge', 1, 1, 1, 1, '充值日志接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/manufacturer', 1, 1, 0, 1, '厂家信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/manufacturer/info', 1, 1, 1, 1, '获取厂家信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/material/add', 1, 1, 0, 1, '素材添加');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/material/delete', 1, 1, 0, 1, '素材删除');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/material/info', 1, 1, 0, 1, '素材查询');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/material/token', 1, 1, 0, 1, '素材上传token获取');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/material/update', 1, 1, 0, 1, '素材修改');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message', 1, 1, 0, 1, '消息推送');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/accountarrears', 1, 1, 1, 1, '欠费提醒');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/accountcreate', 1, 1, 1, 1, '账户建立');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/amountchange', 1, 1, 1, 1, '余额变动');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/amountshortage', 1, 1, 1, 1, '余额不足');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/arreargereminder', 1, 1, 1, 1, '欠费催缴');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/arrearsservices', 1, 1, 1, 1, '恢复&停止服务');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/authcode', 1, 1, 1, 1, '验证码');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/balanceinsufficient', 1, 1, 1, 1, '余额不足');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/channelexception', 1, 1, 1, 1, '通道异常');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/charge', 1, 1, 1, 1, '充值消息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/config', 1, 1, 0, 1, '消息配置');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/config/list', 1, 1, 1, 1, '消息配置列表');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/config/update', 1, 1, 1, 1, '更新消息配置');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/dataexception', 1, 1, 1, 1, '数据异常');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/delete', 1, 1, 1, 1, '删除消息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/deviceexception', 1, 1, 1, 1, '传感器异常');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/list', 1, 1, 1, 1, '查询消息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/projectarrears', 1, 1, 1, 1, '项目商户欠费统计');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/readed', 1, 1, 1, 1, '设置消息已读');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/recharge', 1, 1, 1, 1, '充值成功通知');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/remindrecharge', 1, 1, 1, 1, '催缴费用');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/message/withdrawapply', 1, 1, 1, 1, '提现支出');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/moduleevent', 1, 1, 1, 1, '模块事件配置');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/moduleevent/info', 1, 1, 1, 1, '查询配置');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/moduleevent/update', 1, 1, 1, 1, '更新配置');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/pab', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/pab/add', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/pab/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/pab/edit', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/pab/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/packageplan', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/packageplan/add', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/packageplan/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/packageplan/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/packageplan/update', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/payment', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/payment/all', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/payment/channelinfo', 1, 1, 1, 1, '渠道信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/payment/charge', 1, 1, 1, 1, '充值接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/payment/chargestatus', 1, 0, 0, 1, '充值接口状态');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/payment/handlingcharge', 1, 1, 1, 1, '手续费计算');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/payment/info', 1, 1, 1, 1, '充值计费查询');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/payment/payment', 1, 1, 1, 1, '对单个传感器进行计费');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/payment/reversal', 1, 1, 1, 1, '冲正');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/pltfinance', 1, 1, 0, 1, '平台财务');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/pltfinance/billinginfo', 1, 1, 1, 1, '项目财务信息');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/pltfinance/billingupdate', 1, 1, 1, 1, '项目财务信息更新');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/project', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/project/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/project/auditParameter', 1, 1, 1, 1, '项目审计设置');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/project/authority', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/project/authority/check', 1, 1, 1, 1, '校验项目权限');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/project/authority/info', 1, 1, 1, 1, '查询项目权限');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/project/authority/update', 1, 1, 1, 1, '更新项目权限');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/project/bindequipment', 1, 1, 1, 1, '绑定设备');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/project/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/project/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/project/status', 1, 1, 1, 1, '项目状态');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/project/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/projectattribute', 1, 1, 0, 1, '项目属性');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/projectattribute/delete', 1, 1, 1, 1, '删除');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/projectattribute/info', 1, 1, 1, 1, '查询');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/projectattribute/update', 1, 1, 1, 1, '添加更新');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/resource/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/resource/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensor/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensor/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensor/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensor/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensorattrib', 1, 1, 0, 1, '传感器属性');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensorattrib/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensorattrib/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensorattrib/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensorattrib/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensorchannel', 1, 1, 0, 1, '传感器通道相关接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensorchannel/add', 1, 1, 1, 1, '添加通道');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensorchannel/delete', 1, 1, 1, 1, '删除通道');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensorchannel/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensorchannel/syncdata', 1, 1, 1, 1, '同步异常数据');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensorchannel/update', 1, 1, 1, 1, '更新通道');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/statistic', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/statistic/basedata', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/statistic/byenergytype', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/urlpath/add', 0, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/urlpath/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/urlpath/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/urlpath/update', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/userpackage', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/userpackage/add', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/userpackage/delete', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/userpackage/info', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/userpackage/update', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/weather', 1, 1, 0, 1, '天气接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/weather/recent', 1, 1, 1, 1, '近期天气');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/webhook/fundchannels/alipay', 1, 0, 0, 1, '支付宝手机充值');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/webhook/fundchannels/jyt', 1, 0, 0, 1, '金运通');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/webhook/fundchannels/wx', 1, 0, 0, 1, '微信手机充值');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/withdraw', 1, 1, 0, 1, '提现接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/withdraw/apply', 1, 1, 1, 1, '申请提现');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/withdraw/checking', 1, 1, 1, 1, '提现审核');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/withdraw/details', 1, 1, 1, 1, '提现详情');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/withdraw/done', 1, 1, 1, 1, '提现成功');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/withdraw/info', 1, 1, 1, 1, '提现信息查询');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/withdraw/transferfailed', 1, 1, 1, 1, '提现失败');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/workorder', 1, 1, 0, 1, '工单接口');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/workorder/add', 1, 1, 1, 1, '添加一个工单');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/workorder/info', 1, 1, 1, 1, '查询工单');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/workorder/patch', 1, 1, 1, 1, '修改工单属性');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/wxaccount', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/wxaccount/add', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/wxaccount/bind', 1, 0, 1, 1, '绑定账户');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/wxaccount/delete', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/wxaccount/info', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/wxaccount/unbind', 1, 1, 1, 1, '解绑账户');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/project', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/project/popchart', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/wx', 1, 1, 0, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/wx/electric', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/wx/electricbill', 1, 1, 1, 1, '');
INSERT INTO energymanage.urlpath (id, enable, needlogin, needauth, inproject, description) VALUES ('/api/sensor/reading', 1, 0, 0, 0, 'NB表报告');


INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (0, '电表', 'ELECTRICITYMETER', '001', '["11", "12", "32", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]', '["11"]', 'PAYELECTRICITY');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (2, '冷水表', 'COLDWATERMETER', '002', '["01"]', '["01"]', 'PAYCOLDWATER');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (3, '热水表', 'HOTWATERMETER', '003', '["03"]', '["03"]', 'PAYHOTWATER');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (4, '热能表', 'HEATENERGYMETER', '004', '["04","05","06","07","08","10"]', '["07","08"]', 'PAYHEATENERGY');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (5, '温控器', 'TEMPERATURECONTROL', '005', '["33","34","35","36","37","38","39","40","41"]', '["33"]', 'PAYACPANEL');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (6, '时间采集器', 'TIMERMETER', '006', '["07","08","38","41"]', '["07","08"]', 'PAYTIMER');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (7, '压力表', 'PRESSUREMETER', '007', '["10"]', '[]', 'PAYPRESSUREMETER');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (8, '超声波水表', 'ULTRACOLDWATERMETER', '008', '["04","05","09"]', '["04"]', 'PAYULTRACOLDWATER');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (9, '直饮水', 'DDWATERMETER', '009', '["02"]', '["02"]', 'PAYDDWATER');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (10, '能量表', 'ENERGYMETER', '010', '["04","05","06","07","08","09","10"]', '["07","08"]', 'PAYACENERGY');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (11, 'T型温控器', 'TTYPETEMPCONTROL', '011', '["33","34","35","36","37","38","39","40","41"]', '["33"]', 'PAYACPANEL');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (12, '氧气表', 'OXYGENMETER', '012', '["46"]', '["46"]', 'PAYOXYGEN');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (13, '多功能电表', 'MELECTRICITYMETER', '013', '["11", "15","16","17","18","19","20"]', '["11"]', 'PAYELECTRICITY');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (14, '温湿度表', 'TEMPHUMMETER', '014', '["48","49"]', '[]', 'PAYTEMPHUM');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (15, 'Z型温控器', 'ZTYPETEMPCONTROL', '015', '["33","34","35","36","37","38","39","40","41"]', '["33"]', 'PAYACPANEL');
INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (16, '燃气表', 'GASMETER', '016', '["04"]', '["04"]', 'PAYGAS');

INSERT INTO energymanage.devicetype (id, name, `key`, code, channelids, measure, paycategory) VALUES (17, 'NB冷水表', 'NBCOLDWATERMETER', '017', '["01","51","52","53"]', '["01"]', 'PAYCOLDWATER');

INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('01', '冷水刻度', 1, 1, 'm3');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('02', '纯净水刻度', 1, 1, '升');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('03', '热水刻度', 1, 1, 'm3');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('04', '累积流量', 1, 1, 'm3');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('05', '供水温度', 1, 0, '℃');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('06', '回水温度', 1, 0, '℃');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('07', '总冷量', 1, 1, 'kWh');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('08', '总热量', 1, 1, 'kWh');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('09', '流速', 0, 0, 'm3');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('10', '状态', 0, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('11', '正向有功', 1, 1, 'kWh');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('12', '反向有功', 1, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('13', '正向无功', 1, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('14', '反向无功', 1, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('15', 'A相电压', 1, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('16', 'B相电压', 1, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('17', 'C相电压', 1, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('18', 'A相电流', 1, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('19', 'B相电流', 1, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('20', 'C相电流', 1, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('21', '瞬时有功功率', 0, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('22', 'A相有功功率', 0, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('23', 'B相有功功率', 0, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('24', 'C相有功功率', 0, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('25', '总功率因素', 0, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('26', 'A相功率因素', 0, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('27', 'B相功率因素', 0, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('28', 'C相功率因素', 0, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('29', '尖电能', 1, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('30', '峰电能', 1, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('31', '平电能', 1, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('32', '谷电能', 1, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('33', '能量系数', 1, 1, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('34', '低档能量系数', 0, 1, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('35', '中档能量系数', 0, 1, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('36', '高档能量系数', 0, 1, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('37', '设定温度', 0, 0, '℃');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('38', '档位', 0, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('39', '模式', 0, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('40', '室内温度', 0, 0, '℃');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('41', '二通阀开关', 0, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('42', '分时通道1', 1, 1, 'kWh');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('43', '分时通道2', 1, 1, 'kWh');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('44', '分时通道3', 1, 1, 'kWh');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('45', '分时通道4', 1, 1, 'kWh');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('46', '氧气', 1, 1, 'm3');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('47', '面板状态', 0, 0, '');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('48', '环境温度', 1, 0, '℃');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('49', '环境湿度', 1, 0, '%RH');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('50', '压力', 1, 0, 'Mpa');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('51', '电池电压', 1, 0, 'V');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('52', '信号值', 1, 0, 'dbm');
INSERT INTO energymanage.channeldefine (id, name, persist, measure, unit) VALUES ('53', '累积工作时间', 1, 0, '秒');

INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (1, 'NETDAU', 1, 0, '00', '{{di}}', 'DLT645-97', 'function(devInfo){return ''ELECTRICITYMETER'';}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (2, 'NETDAU', 2, 0, '00', '{{di}}', 'DLT645-07', 'function(devInfo){return ''ELECTRICITYMETER'';}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (3, 'NETDAU', 3, 0, '10', '{{di}}:{{offset}}', 'CJ-T188 水表', 'function(devInfo){return ''COLDWATERMETER'';}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (4, 'NETDAU', 3, 0, '11', '{{di}}:{{offset}}', 'CJ-T188 热表', 'function(devInfo){return ''HOTWATERMETER'';}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (5, 'NETDAU', 4, 0, '00', '{{fnId}}', 'MODBUS-RTU', 'function(devInfo){return ''ELECTRICITYMETER'';}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (6, 'NETDAU', 5, 0, '20', '{{regAddr}}:{{regNum}}', 'GB/T 19582', 'function(devInfo){return ''HOTWATERMETER'';}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (7, 'NETDAU', 6, 0, '00', '{{code}}:{{di}}', '柏诚协议', 'function(devInfo){switch(devInfo.item.type){case ''10'': return ''COLDWATERMETER'';case ''11'': return ''DDWATERMETER'';case ''12'': return ''HOTWATERMETER'';case ''20'': return ''HEATENERGYMETER''; case ''32'': return ''OXYGENMETER''; case ''28'':case ''29'':return ''ENERGYMETER'';case ''86'':return ''TEMPERATURECONTROL'';case ''82'':return ''TTYPETEMPCONTROL'';case ''24'':return ''TIMERMETER'';}}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (8, 'NETDAU', 7, 0, '10', '{{di}}:{{offset}}', 'CJ-T188-2004-2 水表', 'function(devInfo){return ''COLDWATERMETER'';}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (9, 'NETDAU', 7, 0, '11', '{{di}}:{{offset}}', 'CJ-T188-2004-2 热表', 'function(devInfo){return ''HOTWATERMETER'';}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (10, 'NETDAU', 8, 0, '00', '{{bind}}:{{offset}}', '欧标EN1434', 'function(devInfo){return ''COLDWATERMETER'';}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (11, 'NETDAU', 9, 0, '20', '{{cmd}}:{{offset}}', 'WxD水表', 'function(devInfo){return ''HOTWATERMETER'';}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (12, 'NETDAU', 3, 0, '19', '{{di}}:{{offset}}', 'CJ-T188 冷热水表', 'function(devInfo){return ''COLDWATERMETER'';}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (13, 'NETDAU', 3, 0, '20', '{{di}}:{{offset}}', 'CJ-T188 能量表', 'function(devInfo){return ''HEATENERGYMETER'';}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (14, 'NETDAU', 10, 0, '00', '{{fnId}}', 'MODBUS-TCP', 'function(devInfo){return ''ELECTRICITYMETER'';}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (15, 'NETDAU', 0, 2, '0', '{{id}}', '冷水表', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (16, 'NETDAU', 0, 3, '0', '{{id}}', '热水表', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (17, 'NETDAU', 0, 1, '0', '{{id}}', '电表', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (18, 'NETDAU', 0, 11, '0', '{{id}}', 'T温控', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (19, 'NETDAU', 0, 13, '0', '{{id}}', '多功能电表', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (20, 'NETDAU', 0, 5, '0', '{{id}}', '温控器', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (21, 'NETDAU', 0, 6, '0', '{{id}}', '时间采集器', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (22, 'NETDAU', 0, 8, '0', '{{id}}', '超声波水表', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (23, 'NETDAU', 11, 0, '00', '{{di}}', '美格DLT645-97', 'function(devInfo){return ''MELECTRICITYMETER'';}');
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (24, 'NETDAU', 0, 14, '0', '{{id}}', '温湿度表', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (25, 'NETDAU', 0, 4, '0', '{{id}}', '热能表', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (26, 'NETDAU', 0, 10, '0', '{{id}}', '能量表', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (27, 'NETDAU', 0, 12, '0', '{{id}}', '氧气表', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (28, 'NETDAU', 0, 15, '0', '{{id}}', 'Z型温控器', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (29, 'NETDAU', 0, 7, '0', '{{id}}', '压力表', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (30, 'NETDAU', 0, 16, '0', '{{id}}', '燃气表', null);
INSERT INTO energymanage.dataprotocol (id, `key`, type, mType, ext, code, name, devicetype) VALUES (31, 'NETDAU', 0, 2, '0', '{{id}}', 'NB冷水表', 'function(devInfo){return ''NBCOLDWATERMETER'';}');