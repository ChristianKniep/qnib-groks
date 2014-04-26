PKG_NAME="qnib-groks"
echo "PKG_NAME=${PKG_NAME}"
PKG_VERSION=$(git describe --match "[0-9]*" --abbrev=0 --tags)
TODAY="$(date +'%Y%m%d')"
ITER="1"
REPO_PATH=${REPO_PATH-./}
OLD_ITER=$(find ${REPO_PATH} -name "${PKG_NAME}-${PKG_VERSION}*"|grep ${TODAY}|awk -F"${TODAY}." '{print $2}'|awk -F\. '{print $1}'|tail -n1)
echo "OLD_ITER=${OLD_ITER}"
if [ "X${OLD_ITER}" != "X" ];then
   ITER=$(echo "${OLD_ITER}+1"|bc)
fi
ARCH="noarch"
FILE="${PKG_NAME}-${PKG_VERSION}-${TODAY}.${ITER}.${ARCH}.rpm"
echo "FILE=${FILE}"
FILE_PATH="${REPO_PATH}/${ARCH}/${FILE}"
mkdir -p "${REPO_PATH}/${ARCH}"
echo "FILE_PATH=${FILE_PATH}"
fpm -s dir -t rpm -a ${ARCH} -p ${FILE_PATH} -n ${PKG_NAME} -v ${PKG_VERSION} --iteration ${TODAY}.${ITER} \
    -m 'Christian Kniep <christian@qnib.org>' \
    --description 'grok patterns to be used within logstash' \
    -C packaged/ etc usr
createrepo ${REPO_PATH}
