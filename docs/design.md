# Eventaskbot 設計

## 概要

1. ~~Eventaskbot::Commandでコマンドラインオプションを取得~~ ※完了
1. Eventaskbot::Handlerでハンドリング

### 3. Eventaskbot::Handlerでハンドリング

1. ~~Eventaskbot::Configurable::Merge.config_fileで設定ファイルEventaskbotFileの設定内容を設定にマージ~~ ※完了
1. ~~Eventaskbot::Configurable::Merge.command_mergeからコマンドラインオプションの設定内容を設定にマージ(コマンドラインオプションのほうが設定としては優先)~~ ※完了

### 3.3. Eventaskbot::Configurableの設定内容をフィルター

3.3.1. Eventaskbot::Handler::ConfigurableFilter.filterでAPI名からAPI種別を検索

* 1 API種別は下記がある
 * collector (値を収集)
 * etc (その他)

3.3.2. Eventaskbot::Handler::ConfigurableFilter.filterでAPI名から該当するAPIインスタンスを生成して設定に追加

3.3.3. Eventaskbot::Handler::ConfigurableFilter.filterでレスポンスフォーマット等を精査

3.3.4. Eventaskbot::Handler::ConfigurableFilter.filterでcollectorサービスの精査 (収集対象のサービスを検索する)

3.3.5. Eventaskbot::Handler::ConfigurableFilter.filterで通知サービスの精査 (通知対象のサービスを検索する)

### 4. API種別によって見つかったインターフェースメソッドを実行

* API種別がcollectorならEventmachineで並列リクエストで取得

### 5. Eventaskbot::Notify.sendで実行結果を通知する




## 設定を扱うモジュール

### Eventaskbot::Configurable

* 設定をマージする
 * self.configure

* 設定をすべて取得する
 * def options

* 設定キー一覧を取得する
 * keys

* 設定した値を初期化する
 * reset

## 異なる設定方法の設定を設定にマージする

### Eventaskbot::Configurable::Merge

* コマンドラインオプションをマージする
 * command_merge
* 設定ファイルをマージする
 * eventaskbotfile_merge


## コマンドラインを扱うクラス

### Eventaskbot::Command

* コマンドラインオプションをnameで取得する
 * get(name)
 
* コマンドラインオプションをparseする
 * parse(argv = [])
 

## イベント実行Handlerモジュール


### Eventaskbot::Handler

* 要求を実行するメソッド
 * run 

## イベント実行の設定のフィルタリングをするモジュール

### Eventaskbot::Handler::ConfigurableFilter

* 設定をフィルター
 * filter(options) 


## API モジュール

### Eventaskbot::Api

## API Etc モジュール

### Eventaskbot::Api::Etc

### API Etc init クラス

-----

#### Eventaskbot::Api::Etc::Init

## API collector モジュール

### Eventaskbot::Api::Collector

* Collectorを登録するメソッド
 * add_collector(klass)
 
* Collectorを実行するメソッド
 * run

### API Collector Group (グループ情報を収集) クラス

---

### Eventaskbot::Api::Collector::Group

* 情報を収集するメソッド(インターフェース)
 * collect(opts)

### API Collector InGroup (グループ内のユーザー情報を収集) クラス

---

#### Eventaskbot::Api::Collector::InGroup

* 情報を取得するメソッド(インターフェース)
 * collect(opts)
 
### API Collector Users (ユーザー情報を収集) クラス

---

#### Eventaskbot::Collector::Users

* 情報を取得するメソッド(インターフェース)
 * collect(opts)

### API Collector Tasks (タスクを収集) クラス

---

#### Eventaskbot::Collector::Task

* 情報を取得するメソッド(インターフェース)
 * collect(opts)


## 通知側を表すモジュール

### Eventaskbot::Notify

* 通知をするメソッド
 * notification(opts = {})

## 実行したレスポンスを受け取るクラス

### Eventaskbot::Respose

* statusを取得
 * def status
 
* 内容を取得
 * def body
 
## 実行したレスポンスをパースするクラス

### Eventaskbot::Parse

* コンストラクタでResponseクラスを取得
　* def initialize(response)
 
* jsonにパース
 * def json
 
* textにパース
 * def json

## 情報を扱うクラス

### Eventaskbot::Storage

* 情報を保存するメソッド
 * save
 
* 情報を取得するメソッド
 * get 

* データスキーマでプライマリーになるキーを設定するメソッド
 * set_primary(primary = :mail)



## プラグインを管理するモジュール

### Eventaskbot::Plugins

* プラグインを登録する
 * def self.register(type, klass)
 
* プラグインがgemに存在するか検索する
 * def self.find_gem 
 
* プラグインがディレクトリに存在するか検索する
 * def self.find_dir

