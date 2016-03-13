# Centralized-logs-sharing

Welcome to the Centralized-logs-sharing wiki! Problem Statement:while working with client, I have realized that when development team needs logs(webspher,IHS , app specific ,etc) for doing troubleshooting,They need to contact support team for the same and Support team provides the logs . In this process development team lost precious time and delivery time increases.

To address this issue, I have worked on this project and after deployment projects provides following benefits.

1> it will provide central web portal for downloading the logs. 2> We can collect logs from different server and display it to central web portal. 3> you can keep backdated logs for any number of days,this project maintains it's very own log repository.

Terminologies:

Master Node: we will have one master node , which will be responsible for deploying the logs on application server/web server from central logs repository(available on Common NAS location). Child Node: Child Node is responsible for copying the log from application location to central NAS location.

Limitation: I have tested this project on Linux/Unix(AIX) system. For windows you can use cygwin utility to deploy it, yet it might need little customization.

Tools needed:

1> we need one conman NAS volume on all the server. 2> we need one application server(web sphere/tomcat) running on master node. 3> job scheduler(crontab,Autosys etc).

Project files: 1> Input.txt-- This input file holds the details of logs path on the server . Following will be format.

Example: rahcluster1_root_var_logs|var logs on rahcluster1 server|/var/log

{Server_Initials}{userid/fid}{any_unique_Identifier}|{Description about log}|{log directory path}

In Above example : Server name: rahcluster1 userid/fid: root any_unique_Identifier:root_var_logs Description about log: var logs on rahcluster1 server
log directory path:/var/log

In case you are are doing setup for more than two server.Entries will be like as following. rahcluster1_root_var_logs|var logs on rahcluster1 server|/var/log rahcluster1_root_web_logs|Web Sphere logs for 100u|/opt/root_Runtime/profiles/rootCell/root/logs/rootServer1 rahcluster2_root_var_logs|var logs on rahcluster2 server|/var/log

2>scrinput.txt: this file will contains few input parameters, which will be used be shell scripts. Following are parameters. DEPLOYMENT_DIR: This is the directory where your web application running on application server. usally you will have directory like below . /opt/rks/rks_Runtime/profiles/rksCell/rks/installedApps/rksCell/rkscentral.ear/rkscentral.war rkscentral.ear: this is one web application running on my system. you can use any web application for the deployment.

you need to create "share_it" directory inside rkscentral.war" directory. Link: link to access your web application. Like below- https://rkscluster.rks.rksclusters.net:11121/rkscentral/

add "share_it" at the end. https://rkscluster.rks.rksclusters.net:11121/rkscentral/share_it

NUMBER_OF_DAYS: Number of past days for which you want to display logs. NUMBER_OF_DAYS=7 $ cat scrinput.txt DEPLOYMENT_DIR=/opt/rks/rks_Runtime/profiles/rksCell/rks/installedApps/rksCell/rkscentral.ear/rkscentral.war/share_it LINK=https://rkscluster.rks.rksclusters.net:11121/rkscentral/share_it NUMBER_OF_DAYS=7

3> copy.ksh: this shell script is responsible for copying logs from app location to shared NAS location.

4>deploy.ksh> this shell script is responsible for deploying logs on application server.

5> cen_html.ksh > this script is responsible for generating HTML file, which will list logs from all servers.

6> delete.ksh> this script is responsible for deleting unused files.

Folders:

logs: this folder contails logs from all server. deploy.ksh script deploys content of this folder in application server.

archive: this folder will contains old logs.

delete: this folder contains unused file, which will be deleted by delete.ksh.

Scheduling: copy.ksh: schedule this on every server with time interval of 30 minutes.

deploy.ksh: Schedule this on only master node with time interval of 35 minutes.

delete.ksh: Schedule this on only master node with time interval of 40 minutes.

Setup:

1>Clone the git repository inside NAS location.

2>Navigate to cloned folder inside NAS and run following command.

grep -rl 'NAS_LOCATION' ./|xargs sed -i 's|NAS_LOCATION|your_NAS_name|g'

basically it will update ROOT_DIR varible , while is present inside every script.
ROOT_DIR=/NAS_LOCATION/share_it

