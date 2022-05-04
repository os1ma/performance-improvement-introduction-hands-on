# 性能改善入門ハンズオン

[![main](https://github.com/os1ma/performance-improvement-introduction-hands-on/actions/workflows/main.yaml/badge.svg)](https://github.com/os1ma/performance-improvement-introduction-hands-on/actions/workflows/main.yaml)

性能改善の入門のための、ハンズオン問題です。

## 概要

性能改善対象のスクリプトが、Ruby・Python・JavaScript (Node.js) で記述されています。

これらは DB (MySQL) と外部 API (Express) に依存しています。

性能改善対象のスクリプト実行環境や、依存先の DB、外部 API を Docker で起動した上で、性能改善対象のスクリプトを修正していきます。

## サポート環境

Docker および Docker Compose がインストールされた環境を前提としています。

以下の環境で動作確認済みです。

- Ubuntu 20.04 LTS (x86_64)
- macOS Monterey (Apple M1)

### 環境チェック

このハンズオンが実施可能か、以下のコマンドでチェックすることができます。

```console
./bin/test.sh
```

環境によって異なりますが、このコマンドの実行は実行完了まで 10 分程度かかります。

最後に以下のように表示されれば成功です。

```console
==================
All Test Passed!!!
==================
```

## ディレクトリ構成

このリポジトリのディレクトリ構成は以下のようになっています。

```
.
├── answers ... 回答例と解説が置いてあります。
├── bin ... 性能改善の作業で使えるスクリプトが置いてあります。
├── dependencies ... 性能改善対象のスクリプトが依存する、DB の設定などが置いてあります
├── dockerfiles ... 性能改善対象のスクリプト実行環境の Dockerfile が置いてあります。
└── exercises ... 性能改善対象の問題が置いてあります。
    ├── ex01 ... 問題にはこのように連番が付けられています。
    │   ├── README.md ... 問題の概要は README に記載しています。
    │   └── ruby ... 問題によっては複数の言語に対応しています。各ディレクトリ以下に具体的なスクリプトが置いてあります。
    │       ├── Gemfile
    │       ├── Gemfile.lock
    │       ├── README.md ... スクリプトの実行手順などはここの README を参照してください。
    │       ├── main.rb
    │       └── main_test.rb
    ├── ex02
    :    :
```

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

※ 環境によって異なりますが、上記のスクリプトの実行には数分〜10 分程度かかります。

なお、MySQL には以下のコマンドで接続して SQL を実行可能です。

```console
./bin/connect_mysql.sh
```

### 3. 性能改善問題に挑戦

#### 3.1. 問題の概要を把握する

性能改善問題は、exercises ディレクトリ以下にあります。

問題の概要は、例えば [exercises/ex01/README.md](exercises/ex01/README.md) に記載してあります。

#### 3.2. 改善前コードのまま、スクリプトを実行してみる

問題によってはいくつかの言語をサポートしているので、使いたい言語を選択してください。

言語を選択したら、以下のコマンドを実行し、コンテナにログインします。

```console
docker-compose exec ruby bash
```

※ 第 2 引数には、Ruby を使う場合は `ruby`、Python を使う場合は `python`、Node.js を使う場合は `node` を指定してください。

スクリプトの実行手順が例えば [exercises/ex01/ruby/README.md](exercises/ex01/ruby/README.md) に記載してあるので、その通り実行してください。

コンテナからログアウトしたい場合は、以下のコマンドを実行してください。

```console
exit
```

#### 3.3. 性能改善する

スクリプトを改善してみてください。

コンテナ内とホストでスクリプトのファイルは共有されているので、ホスト上で VSCode などを使って編集すれば、コンテナ内にも反映されます。
