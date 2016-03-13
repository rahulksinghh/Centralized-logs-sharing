ROOT_DIR=/NAS_LOCATION/share_it
CURRENT_DATE=$(date|awk '{ print $2" "$3 }')
LINK=$(cat ${ROOT_DIR}/scrinput.txt|grep "LINK"|cut -d '=' -f2)
mkdir -pm 777 ${ROOT_DIR}/logs
mkdir -pm 777 ${ROOT_DIR}/archive
mkdir -pm 777 ${ROOT_DIR}/delete
STATUS=0
cat ${ROOT_DIR}/input.txt|grep "$(uname -n)_${LOGNAME}_"|while read LINE
do
DATE_AGO=$(date +"%b %e")
COMPONENT_NAME=$(echo "${LINE}"|cut -d '|' -f1)
COMPONENT_PATH=$(echo "${LINE}"|cut -d '|' -f3)
COMPONENT_DESCRIPTION=$(echo "${LINE}"|cut -d '|' -f2)
HTML_FILE=${ROOT_DIR}/logs/${COMPONENT_NAME}.html
COUNT=0
NUMBER_OF_DAYS=$(cat ${ROOT_DIR}/scrinput.txt|grep "NUMBER_OF_DAYS"|cut -d '=' -f2)
echo  " <html>  <head> <title>${COMPONENT_DESCRIPTION}</title> </head> <body bgcolor=#FFFFFF> <br><br><H3 align=center>Logs for ${COMPONENT_DESCRIPTION}</H3> <br><br><br><p><table border=1 bgcolor=#F5FAFF><tr align=center><th>Logs Link </th></tr>" > ${HTML_FILE}
mkdir -pm 777 ${ROOT_DIR}/logs/${COMPONENT_NAME}
mkdir -pm 777 ${ROOT_DIR}/archive/${COMPONENT_NAME}
mkdir -pm 777 ${ROOT_DIR}/delete/logs
mkdir -pm 777 ${ROOT_DIR}/delete/archive
echo "-----------------${COMPONENT_NAME}---------------------${COMPONENT_NAME}----------------------"
#cp /dev/null ${ROOT_DIR}/logs/${COMPONENT_NAME}.log
cp /dev/null ${ROOT_DIR}/archive/${COMPONENT_NAME}_file_listed.txt
echo "-----------------------------------${COMPONENT_NAME}--------------------------${COMPONENT_DESCRIPTION}---------------------"
while [ ${COUNT} -lt ${NUMBER_OF_DAYS} ];
do 
echo "collecting logs ${COMPONENT_NAME}-----date--${DATE_AGO}--------------"
cd ${COMPONENT_PATH}
if echo ${COMPONENT_NAME}| grep -q "iserver"; then
SEARCH="DSSErrors"
elif  echo ${COMPONENT_NAME}| grep -q "web"; then
SEARCH="log"
else
SEARCH="log"
fi

ls -ltr|grep "${SEARCH}"|grep "${DATE_AGO}" >> ${ROOT_DIR}/archive/${COMPONENT_NAME}_file_listed.txt
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ls -ltr|grep "${SEARCH}"|grep "${DATE_AGO}"
ls -ltr|grep "${SEARCH}"|grep "${DATE_AGO}"|awk '{ print $9 }'|while read FILE
do
echo "--------${FIle}------------------${DATE_AGO}-------"
IDENTIFIER=$(ls -ltr ${FILE}|awk '{ print $6 " "$7" "$8" "$9 }')
IDENTIFIER_INI=$(echo "${IDENTIFIER}"|tr -s ' ' '_')
cp -p ${FILE} ${ROOT_DIR}/logs/${COMPONENT_NAME}
CURRENT_DIR=$(pwd)
cd ${ROOT_DIR}/logs/${COMPONENT_NAME}
mv ${FILE} ${IDENTIFIER_INI}
cd ${CURRENT_DIR}
TEMP_LINK=${LINK}/${COMPONENT_NAME}/${IDENTIFIER_INI}
echo " <tr><td><a href="${TEMP_LINK}" target="_blank">${IDENTIFIER_INI}</a>" >> ${HTML_FILE}
echo "------------------------+++++++++++++++++++++++${Send_data}"
ls -ltr ${ROOT_DIR}/archive/${COMPONENT_NAME}|grep "${IDENTIFIER}"
if [ $? -eq 0 ]; then
echo "File exise in archive"
else
cp -p ${FILE} ${ROOT_DIR}/archive/${COMPONENT_NAME}
fi
done
cd ${ROOT_DIR}/archive/${COMPONENT_NAME}
ls -ltr|grep "${DATE_AGO}"|awk '{ print $9 }'|while read FILE
do
IDENTIFIER=$(ls -ltr ${FILE}|awk '{ print $6 " "$7" "$8" "$9 }')
cat ${ROOT_DIR}/archive/${COMPONENT_NAME}_file_listed.txt|grep "${IDENTIFIER}"
if [ $? -eq 0 ];
then
echo "file already added in logs ${IDENTIFIER}"
else
echo "file not exise---adding---${IDENTIFIER}-----------------"
IDENTIFIER_INI=$(echo "${IDENTIFIER}"|tr -s ' ' '_')
cp -p ${LINE} ${ROOT_DIR}/logs/${COMPONENT_NAME}/${IDENTIFIER_INI}
TEMP_LINK=${LINK}/${COMPONENT_NAME}/${IDENTIFIER_INI}
echo "<tr><td><a href="${TEMP_LINK}" target="_blank">${IDENTIFIER_INI}</a>" >> ${HTML_FILE}
echo "${Send_data}++++archive++++++++++++++++++++++++++++++++++"
ls -ltr ${FILE} >> ${ROOT_DIR}/archive/${COMPONENT_NAME}_file_listed.txt
fi
done
COUNT=$( expr ${COUNT} + 1 )
DATE_AGO=$(date +"%b %e" --date="${COUNT} day ago")
echo "===================================${Send_data}"
done
echo "</p></table></body></html>" >> ${HTML_FILE}
echo "cleaning old archive file-------------------------------------------------------------------"
cd ${ROOT_DIR}/archive/${COMPONENT_NAME}
ls -ltr|while read FILE_DELETE
do
IDENTIFIER=$(echo "${FILE_DELETE}"|awk '{ print $6 " "$7" "$8" "$9 }')
cat ${ROOT_DIR}/archive/${COMPONENT_NAME}_file_listed.txt|grep "${IDENTIFIER}"
if [ $? -eq 0 ]; then
echo "good file"
else
echo "Deleting old file from archive ${FILE_DELETE}"
#rm ${ROOT_DIR}/archive/${COMPONENT_NAME}/$(echo "${FILE_DELETE}"|awk '{ print $9 }')
cd ${ROOT_DIR}/archive/${COMPONENT_NAME}
FILE_NAME=$(echo "${FILE_DELETE}"|awk '{ print $9 }')
mv ${FILE_NAME} ${ROOT_DIR}/delete/${FILE_NAME}_$$
fi
done
echo "cleaning old logs file-------------------------------------------------------------------"
cd ${ROOT_DIR}/logs/${COMPONENT_NAME}
SEARCH_DATA=$(cat  ${ROOT_DIR}/archive/${COMPONENT_NAME}_file_listed.txt|tr -s ' ' ' '|awk '{ print $6"_"$7"_"$8"_"$9 }')
ls -ltr|awk '{ print $9 }'|while read FILE_DELETE
do
echo "${FILE_DELETE}"
#IDENTIFIER=$(echo "${FILE_DELETE}"|awk '{ print $6 " "$7" "$8" "$9 }')

echo "${SEARCH_DATA}"|grep "${FILE_DELETE}"
if [ $? -eq 0 ]; then
echo "good file"
else
echo "Deleting old file from log ${FILE_DELETE}"
#rm ${ROOT_DIR}/archive/${COMPONENT_NAME}/$(echo "${FILE_DELETE}"|awk '{ print $9 }')
cd ${ROOT_DIR}/logs/${COMPONENT_NAME}/
#FILE_NAME=$(echo "${FILE_DELETE}"|awk '{ print $9 }')
mv ${FILE_DELETE} ${ROOT_DIR}/delete/${FILE_DELETE}_$$
fi
done


done
exit ${STATUS}
