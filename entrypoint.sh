#!/bin/bash
set -e

INFILE=$(tempfile).png
OUTFILE=$(tempfile).png

tee ${INFILE} > /dev/null

if [ ! -z ${INFILE} ]; then

	/opt/w2x/waifu2x-converter $@ -i ${INFILE} -o ${OUTFILE} > /dev/null

	cat ${OUTFILE}

	rm ${INFILE} ${OUTFILE}

fi

exit 0
