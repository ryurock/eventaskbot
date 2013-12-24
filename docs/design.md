# Eventaskbot 設計

## 実行の流れ

1. Eventaskbot::Configurableから設定ファイルEventaskbotFileの設定内容を取得
1. Eventaskbot::Commandで設定内容をマージする
1. Eventaskbot::Handlerでハンドリング
 1. service.サービス名のCollectorクラスを検索
 1. Eventmachineで並列リクエストで取得
 1. notify.サービス名のNotifyクラスを検索
 1. Eventmachineで並列リクエストで通知
 1. 結果を




## 設定ファイルを扱うモジュール

### Eventaskbot::Configurable

* 設定をマージするメソッド
 * self.configure(value)

* 設定をすべて取得する
 * def self.options

* 設定キー一覧を取得するメソッド
 * self.keys

* 設定キーの値を取得するメソッド
 * self.get

* 設定した値を初期化するメソッド
 * self.reset

 
## コマンドラインを扱うクラス

### Eventaskbot::Command

* コマンドラインオプションを取得するメソッド
 * get
 
* コマンドラインオプションを設定にマージするメソッド
 * merge

## 通知側とタスク側に設定を渡すモジュール

### Eventaskbot::Handler

* 設定を渡すメソッド
 * add_options

* 要求を実行するメソッド
 * run 

## プラグインを管理するモジュール

### Eventaskbot::Plugins

* プラグインを登録する
 * def self.register(type, klass)
 
* プラグインがgemに存在するか検索する
 * def self.find_gem 
 
* プラグインがディレクトリに存在するか検索する
 * def self.find_dir


## 情報を収集するモジュール

### Eventaskbot::Collector

* Collectorを登録するメソッド
 * add_collector(klass)
 
* Collectorを実行するメソッド
 * run

## グループ情報を収集するクラス

### Eventaskbot::Collector::Group

* 情報を収集するメソッド(インターフェース)
 * collect(opts)

## グループ内のユーザー情報を収集するクラス

### Eventaskbot::Collector::InGroup

* 情報を取得するメソッド(インターフェース)
 * collect(opts)
 
## ユーザー情報を収集するクラス

### Eventaskbot::Collector::Users

* 情報を取得するメソッド(インターフェース)
 * collect(opts)

## タスクを収集するクラス

### Eventaskbot::Collector::Task

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
