# 日本の医療用医薬品の薬効分類・分類名対応表

2022-07-26


## はじめに

日本の医療用医薬品は、薬効分類ごとに分類されている。<br>

ここでいう「薬効分類」とは、[日本標準商品分類番号](https://www.soumu.go.jp/toukei_toukatsu/index/seido/syouhin/2index.htm)の中分類 87 の分類である。

種々の医薬品標準マスターを取り扱う際に使用される YJ コードや薬価基準収載医薬品コードの上位 1 ~ 4 桁はこの分類番号と対応している。

医薬品標準マスターを扱う上でも、「薬効分類番号と分類名の対応表」が存在すると大変ありがたいのだが、扱いやすい形式 (エクセルファイルやプレーンテキストファイル等) として入手することは残念ながらできない[^注1]。

そこで、以下のデータベースサイトの情報を取得・加工することで、薬効分類番号と分類名称の対応が記載された CSV ファイルを作成して、本リポジトリに格納することとする。<br>
[KEGG: Kyoto Encyclopedia of Genes and Genomes](https://www.kegg.jp/kegg/)

[^注1]: 実際には e-stat にデータが存在しました。[e-stat データからの対応表作成についてもリポジトリをつくりました]()。

## このリポジトリが提供するもの

本リポジトリでは、以下のものが取得可能である。

1. 薬効分類番号 (薬効分類コード) と分類名の対応表 

2. 1 を作成するために必要な環境構築方法とソースコード

現在の薬効分類番号と分類名の対応表が必要な場合には、本リポジトリの[成果物ページ](https://github.com/kirino-k/therapeutic_category_of_drug/blob/main/src/out/output.csv)をコピー＆ペースト可能である。

また分類の改定などといった、情報の再取得・再加工が必要な状況も想定されるため、対応表作成の手順を以下に示すとともに、対応表作成に用いたソースコードとその実行環境の情報を併せて提供する。


## 対応表の作成方法等

### 情報源

[医療用医薬品の薬効分類](https://www.kegg.jp/brite/jp08301)

### 環境

ソースコードを実行するためには以下の環境が必須である。

- Linux shell (bash)
    - curl, sed, tr, nkf

- Node.js

Docker (特に[Play with Docker](https://labs.play-with-docker.com/)) を用いることで、ローカル環境における環境構築は不要である。

### 手順

1. 情報源となる WEB ページよりソースとなる HTML ファイルを取得し、保存する (src/tmp/kegg_yyyymmdd.html[^注2])。なお、分類番号と分類名の対応を紐づける記載は script タグ内の JavaScript コードに存在する。

1. 情報の格納された JavaScript コード内の `env` という変数 (Object 型) の記載のみを抽出する。

1. 上記出力に、`env` 変数から必要な情報を抽出して標準出力するためのスクリプト (src/additional.js) を連結し、標準出力する。

1. 上記出力をソーススクリプトとしてNode.jsを実行する。

1. 出力された情報を shell (bash) の sed と tr コマンドを用いて加工し (下記に定義したファイルレイアウトにするための加工と不要なスペースの削除)、出力 (src/out/output.csv) を得る。

1. Windows PC 上の MS Excel で文字化けせずに表示可能な CSV ファイル (src/out/therapeutic_category_of_drug_yyyymmdd.csv[^注3]) を出力する。

[^注2]: yyyymmdd には実行日が 8 桁数字として入る。
[^注3]: 同上。


## ファイルレイアウト

最終成果物である対応表においては、「薬効分類コード」および「薬効分類名」の名称は、[厚生労働省の資料](https://www.mhlw.go.jp/content/11120000/000953106.pdf)において用いられているものと一致している。

その他の分類番号や分類名に対応する既存の名称は存在しないため、番号に用いられる数字の桁数と対応する以下の列名 (変数名) を便宜的に用いた。

| 列名              | 説明                                                                                                             |
|-------------------|------------------------------------------------------------------------------------------------------------------|
|分類番号1          | 日本標準商品分類番号の「分類番号」から 87 を除いた番号の上位 **1 桁**の数字                                      |
|分類名1            | 「分類番号1」に対応する分類名                                                                                    |
|分類番号2          | 日本標準商品分類番号の「分類番号」から 87 を除いた番号の上位 **2 桁**の数字                                      |
|分類名2            | 「分類番号2」に対応する分類名                                                                                    |
|**薬効分類コード** | 日本標準商品分類番号の「分類番号」から 87 を除いた番号の上位 **3 桁**の数字 (「薬効分類コード」として定義される) |
|**薬効分類名**     | 「薬効分類コード」に対応する分類名                                                                               |
|分類番号4          | 日本標準商品分類番号の「分類番号」から 87 を除いた番号の上位 **4 桁**の数字                                      |
|分類名4            | 「分類番号4」に対応する分類名                                                                                    |

## ソースコードの実行方法


### リポジトリの clone

GitHub より リポジトリを clone する

```
git clone https://github.com/kirino-k/therapeutic_category_of_drug.git
```

### ローカルに実行環境がある場合

ローカルの shell でスクリプトを実行 (リポジトリの root ディレクトリ)

```
./src/create_table.sh
```

### Docker コンテナ上でスクリプトを実行する場合

Docker コンテナの作成

```
docker build . -t therapeutic_category_of_drug:latest
```

Docker コンテナ上でスクリプトを実行 (リポジトリの root ディレクトリ)

```
docker run \
  --rm \
  -v $(pwd)/src:/home/node/src \
  --user node \
  --workdir /home/node/src \
  therapeutic_category_of_drug:latest \
  ./create_table.sh    
```

コンテナ削除

```
docker rmi therapeutic_category_of_drug:latest
```
