# 日本の薬効分類

2022-07-26

## はじめに

日本の医薬品は薬効分類ごとに分類されている

[KEGG: Kyoto Encyclopedia of Genes and Genomes](https://www.kegg.jp/kegg/)

医療用医薬品の薬効分類
https://www.kegg.jp/brite/jp08301


## このリポジトリが提供するもの


## 使い方

Docker コンテナ作成

```
docker build . -t temporary_container:latest
```

コンテナ上でスクリプトを実行

```
docker run --rm -v $(pwd)/src:/home/node/src --user node --workdir /home/node/src temporary_container:latest ./create_master.sh    
```

コンテナ削除

```
docker rmi temporary_container:latest
```
