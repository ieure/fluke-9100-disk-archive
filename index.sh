#! /bin/bash

set -e

# yeah i know
SAMDISK=~/Downloads/samdisk-388-osx/samdisk
OS9=~/Downloads/toolshed/build/unix/os9/os9
DIST=${PWD}/dist

STREAMS=`find . -type d -name \*-STREAM -and -not -path '*dist*' -exec dirname {} \;`

mkdir -p ${DIST}

for STREAM in $STREAMS; do
    pushd "$STREAM" > /dev/null
    ID=`basename $STREAM`
    DIN=`echo $ID | sed s/,/_/`
    echo $STREAM
    ${SAMDISK} copy *-STREAM/*.img00.0.raw ${DIN}.raw
    ${OS9} dir -aer ${DIN}.raw > INDEX

    # ZIP=${ID}-STREAM.zip
    # zip -qr $ZIP *-STREAM/
    # mkdir -p ${DIST}/${STREAM}
    # cp $ZIP ${DIST}/${STREAM}

    rm ${DIN}.raw
    popd > /dev/null
done

# META=`find . -name INDEX -or -name CATALOG -or -name README \
#              -or -name CHANGELOG -or -name VERSION -or -name \*.jpg \
#              -and -not -path '*dist*'`
# for FILE in ${META}; do
#     mkdir -p ${DIST}/`dirname $FILE`
#     cp ${FILE} ${DIST}/`dirname $FILE`
# done
