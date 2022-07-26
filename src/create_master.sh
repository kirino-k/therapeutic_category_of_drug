#!/bin/bash

DIR_SRC=$(cd $(dirname $0); pwd)
DIR_OUT=${DIR_SRC}/out

curl https://www.kegg.jp/brite/jp08301 |
  grep -A 11 'env' |
  cat - <(cat ${DIR_SRC}/additional.js) |
  node |
  sed -E 's/^<b>([0-9]{1})(.*)<\/b>(,[0-9]{2})(.*)(,[0-9]{3})(.*)(,[0-9]{4})(.*)$/\1,\2\3,\4\5,\6\7,\8/' |
  sed -E 's/；.*$//' |
  tr -d ' ' > ${DIR_OUT}/output.csv

cat ${DIR_OUT}/output.csv |
  nkf -s > ${DIR_OUT}/薬効分類.csv