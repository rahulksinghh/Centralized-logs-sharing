########################################################################
###Developed By: rahulksinghh@gmail.com                         ########
########################################################################
ROOT_DIR=/NAS_LOCATION/share_it
DEPLOYMENT_DIR=$(cat ${ROOT_DIR}/scrinput.txt|grep "DEPLOYMENT_DIR"|cut -d '=' -f2)
LINK=$(cat ${ROOT_DIR}/scrinput.txt|grep "LINK"|cut -d '=' -f2)
Send_data=$(echo  " <html>  <head> <title>${COMPONENT_DESCRIPTION}</title> </head> <body bgcolor=#FFFFFF> <br><br><H3 align=center>Logs Dashboard for UAT</H3> <br><br><br><p><table border=1 bgcolor=#F5FAFF><tr align=center><th>Server Name</th><th>Logs Link </th></tr>")
cat in*|awk -F "_" '{ print $1 }'|sort -rn|uniq|while read LINE
do
cd ${ROOT_DIR}/logs
ls|grep "${LINE}"|grep html
if [ $? -eq 0 ]; then
LINK_FINAL=""
ls|grep "${LINE}"|grep html|while read LOGS
do
LINK_NAME=$(echo "${LOGS}"|cut -d '.' -f1)
LINK_FINAL=$(echo "${LINK_FINAL} <a href="${LINK}/${LOGS}" target="_blank">${LINK_NAME}</a><br>")
done
Send_data=$(echo "${Send_data}<tr><td>${LINE}</td><td>${LINK_FINAL}</td></tr>")
fi
done
Send_data=$(echo "${Send_data}</table></p></body></html>")
echo "${Send_data}" > ${DEPLOYMENT_DIR}/CFO_UAT_LOGS.html

