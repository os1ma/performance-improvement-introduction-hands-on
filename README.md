# 性能改善入門ハンズオン

性能改善の入門のための、ハンズオン問題です。

## 概要

性能改善対象のスクリプトが、Ruby・Python・JavaScript (Node.js) で記述されています。

これらは DB (MySQL) と外部 API (Express) に依存しています。

性能改善対象のスクリプト実行環境や、依存先の DB、外部 API を Docker で起動した上で、性能改善対象のスクリプトを修正していきます。

## 依存関係

- Docker (Docker Compose)

注意: M1 Mac などの ARM プロセッサでの動作は保証していません。

## ディレクトリ構成

- answers ... 回答例が置いてあります
- bin ... 性能改善の作業で役立つスクリプトが置いてあります
- dependencies ... 性能改善対象のスクリプトが依存する、DB の設定などが置いてあります
- exercises ... 性能改善の問題が置いてあります

## ハンズオン手順

### 1. DB や通信先 API の起動

以下のコマンドで、DB や通信先 API を起動します。

```console
docker-compose up -d
```

### 2. DB へのデータのロード

以下のコマンドにより、MySQL を初期化可能です。
(もしも性能改善中にデータを初期化し直したい場合も、以下のコマンドで初期化されます)

```console
./bin/init_mysql.sh
```

※ 上記のスクリプトの実行には数分程度かかります。

なお、MySQL には以下のコマンドで接続して SQL を実行可能です。

```console
./bin/connect_mysql.sh
```

### 3. 性能改善問題に挑戦

exercises ディレクトリ以下の問題に挑戦してください。

なお、各言語の実行環境となるコンテナには、以下のコマンドでログインできます。

```console
docker-compose exec ruby bash
```

※ 最後の引数には、Ruby を使う場合は `ruby`、Python を使う場合は `python`、Node.js を使う場合は `node` を指定してください。
