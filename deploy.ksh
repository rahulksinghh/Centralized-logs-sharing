
ROOT_DIR=/NAS_LOCATION/share_it
DEPLOYMENT_DIR=$(cat ${ROOT_DIR}/scrinput.txt|grep "DEPLOYMENT_DIR"|cut -d '=' -f2)
STATUS=0
mkdir -pm 777 ${ROOT_DIR}/delete
cd ${ROOT_DIR}
cp -rf logs ${DEPLOYMENT_DIR}
if [ -d ${DEPLOYMENT_DIR}/sharing_logs ]; then
cd ${DEPLOYMENT_DIR}
DATE=$(date|tr -s ' ' '_')
echo "moving old..."
mv sharing_logs logs_temp_${DATE}
echo "moving new..."
mv logs sharing_logs
mv logs_temp_${DATE} ${ROOT_DIR}/delete
mkdir -pm 777 sharing_logs
else
cd ${DEPLOYMENT_DIR}
mkdir -pm 777 sharing_logs
mv logs sharing_logs
fi
echo "deployment has been completed at following location ${DEPLOYMENT_DIR}"
cd ${ROOT_DIR}
./cen_html.ksh
exit ${STATUS}
