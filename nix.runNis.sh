#!/bin/bash

cd nis
java -Xms512M -Xmx1G -XX:+PrintGCDateStamps -XX:+PrintGCDetails -Xloggc:./var/log/nis_gc.log -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFile=5 -XX:GCLogFileSize=1m -cp ".:./*:../libs/*" org.nem.deploy.CommonStarter
cd -
