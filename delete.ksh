
ROOT_DIR=/NAS_LOCATION/share_it
cd ${ROOT_DIR}/delete
COUNT=$(ls|wc -l)
P=$(pwd)
echo "${P}-------${COUNT}"
pwd|grep "delete"
if [ $? -eq 0 ]; then
if [ ${COUNT} -gt 0 ]; then
ls|xargs rm -rf 
echo "${P}"
fi
fi
COUNT=$(ls|wc -l)
if [ ${COUNT} -eq 0 ]; then
exit 0
else
exit 1
fi
