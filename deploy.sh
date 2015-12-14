#!/bin/sh

npm install

app="acaleph.js"

appExists=`forever list | grep $app`
echo "$appExists"

if [ "$appExists" ];
then
	forever restart $app
else
	forever start $app
fi