#!/bin/bash

DIR_SRC=$(cd $(dirname $0); pwd)
DIR_TMP=${DIR_SRC}/tmp
DIR_OUT=${DIR_SRC}/out

if [ ! -e ${DIR_TMP} ]; then
  mkdir ${DIR_TMP}
fi

if [ ! -e ${DIR_OUT} ]; then
  mkdir ${DIR_OUT}
fi

PATH_TMP_HTML=${DIR_TMP}/kegg_$(date +%Y%m%d).html
PATH_OUT_CSV=${DIR_OUT}/therapeutic_category_of_drug_$(date +%Y%m%d).csv

curl https://www.kegg.jp/brite/jp08301 > ${PATH_TMP_HTML}

echo '分類番号1,分類名1,分類番号2,分類名2,薬効分類コード,薬効分類名,分類番号4,分類名4' > ${DIR_OUT}/output.csv
cat ${PATH_TMP_HTML} |
  grep -A 11 'env' |
  cat - <(cat ${DIR_SRC}/additional.js) |
  node |
  sed -E 's/^<b>([0-9]{1})(.*)<\/b>(,[0-9]{2})(.*)(,[0-9]{3})(.*)(,[0-9]{4})(.*)$/\1,\2\3,\4\5,\6\7,\8/' |
  tr -d ' ' >> ${DIR_OUT}/output.csv

cat ${DIR_OUT}/output.csv |
  nkf -s > ${PATH_OUT_CSV}
