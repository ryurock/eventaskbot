 Eventaskbot

[eventmachine](https://github.com/eventmachine/eventmachine) using to task notify Service

## Requirements

* Ruby 2.x

### Ruby Install

#### STEP1 [rbenv](https://github.com/sstephenson/rbenv) & [ruby-build](https://github.com/sstephenson/ruby-build)  & [ruby-binstubs](it://github.com/ianheggie/rbenv-binstubs.git) is Install

```
cd /usr/local/
git clone https://github.com/sstephenson/rbenv.git
chmod -R g+rwxXs /usr/local/rbenv/
mkdir /usr/local/rbenv/plugins
cd /usr/local/plugin
git clone https://github.com/sstephenson/ruby-build.git
git clone https://github.com/ianheggie/rbenv-binstubs.git
```

#### STEP2 rbenv.sh Create

```
vim /etc/profile.d/rbenv.sh

export RBENV_ROOT="/usr/local/rbenv"
export PATH="/usr/local/rbenv/bin:$PATH"
eval "$(rbenv init -)"
```

#### STEP3 use source command

```
source /etc/profile.d/rbenv.sh
```

#### STEP4 ruby Install

```
which rbenv
/usr/local/rbenv/bin/rbenv

rbenv install 2.0.0p247
rbenv global 2.0.0p247 
rbenv rehash
```

## Installation

Add this line to your application's Gemfile:

    gem 'eventaskbot'

And then execute:

    $ bundle

Or install it yourself as: 

    $ gem install eventaskbot

## Dependency Gem

* [eventmachine](https://github.com/eventmachine/eventmachine)
* [multi_json](https://github.com/intridea/multi_json)
* [term-ansicolor](https://github.com/flori/term-ansicolor)
* [yammer](https://github.com/yammer/yam?source=c)

## Usage

### Step1. Eventaskbot init

Create current directory Setting File.(EventaskbotFile)

```
$ eventaskbot init
[Created] Setting File dest 'current_path'
```

### Step2. EventaskbotFile Edit

```
ココに編集内容書く
```

## command Usage

コマンドラインの基本操作方法です

```
eventaskbot API名 'APIのオプション'
```

### 例) 設定ファイルを作成する

```
eventaskbot init
```

### API Options

RubyのHashを用いてAPIオプションを追加できます。

APIのオプションを追加する場合は'(シングルコーテション)で託ってください。

```
eventaskbot init '{ :force_update => true }'
```

## API Reference

### File APIs

主にファイルを操作したAPI郡

### File/Init

----

設定ファイルを作成します。

#### API Parametor

引数    | 必須 |  値  | デフォルト | 説明
--------|------|------|------|------
:force_update | x | Boolean | false | 強制的に設定ファイルを作成します 
:dest | x | text | none | 設定ファイルの書き出し先を設定します

#### Example

* 設定ファイルを作成する

```
eventaskbot init
[Created] Setting File dest : "your current Path"
```

* 設定ファイルを強制的に上書きします

```
eventaskbot init '{ :force_update => true }'
[Created] Setting File dest : "your current Path"
```

* 設定ファイルを指定した場所に作成します

```
eventaskbot init '{ :dest => "path/to/hoge" }'
[Created] Setting File dest : "your current Path"
```


### Auth APIs

認証が必要なサービスの認証を行います。

* 認証ができるサービスの一覧

 * [Yammer](https://www.yammer.com)

### Auth/get-oauth-token

----

oauthのaccess_tokenを取得してストレージに保存します

#### 注意

[mechanize](https://github.com/sparklemotion/mechanize)というRubyのスクレイピングライブラリを使用してaccess_tokenを取得しにいきます。
mechanizeの仕様上アクセスしたURLを取得できないので、Redirect URLの設定値を404エラーのURLに投げないとtokenが取得できません

#### API Parametor

引数    | 必須 |  値  | デフォルト | 説明
--------|------|------|------|------
:client_id | o | text | none | access_tokenの取得に必要なclient_id 
:client_secret | o | text | none | access_tokenの取得に必要なclient_secret
:user | o | text | none | サービスのuser_id(Email)
:pass | o | text | none | サービスのpassword
:watch_token | x | boolean | false | 現在のtoken情報を確認します（内部ストレージにtokenは保存されません)またnotifyもされません
:diff_token | x | boolean | false | 現在内部ストレージに保存されているデータと実際の外部サービスのトークンデータを差分表示します


上記必須パラメーター[:client_id,:client_secret,:user,:pass]はEventaskbotFileに記載しておけば自動で設定を読みにいきます。 

#### Example

* tokenを取得する

EventaskbotFile

```
Eventaskbot::Api::Auth.configure do |c|
# Auth API add setting
# example
  c.get_oauth_token = {
    :service => {
       :yammer => {
         :user => "your User Email",
         :pass => "your User password"
       }
     }
  }
end 

Eventaskbot.configure do |c|
  c.service = {
    :yammer => { #Using Yammer Service
      :client_id     => 'your client_id',
      :client_secret => 'your client_secret',
    }
  }
end

```

* tokenを取得してStorageに保存します
 
```
get-oauth-token
[Success] oauth token get
+------------------------+
| access_token           |
+------------------------+
| xxxxxxxxxxx            |
+------------------------+
[Success] notification is API get-oauth-token
```

* 現在の使用しているtokenを閲覧します
 
```
eventaskbot get-oauth-token '{:watch_token => true}'
[Success] oauth token get
+------------------------+
| access_token           |
+------------------------+
| xxxxxxxxxxx            |
+------------------------+
```

* ストレージに保存してあるtokenと最新のtokenに差分があるか確認します
 
```
eventaskbot get-oauth-token '{:diff_token => true}'
[Success] access_token diff is
+------------------+------------------------+
| old_access_token | xxxxxxxxxxxxx |
| new_access_token | xxxxxxxxxxxxx |
+------------------+------------------------+
[Success] notification is API get-oauth-token
```






### User APIs

ユーザー情報系API

* 認証ができるサービスの一覧

 * [Yammer](https://www.yammer.com)

### User/user-import

----

サービスのユーザーデータをストレージに保存します

#### API Parametor

引数    | 必須 |  値  | デフォルト | 説明
--------|------|------|------|------
:client_id | o | text | none | access_tokenの取得に必要なclient_id 
:client_secret | o | text | none | access_tokenの取得に必要なclient_secret
:user | o | text | none | サービスのuser_id(Email)
:pass | o | text | none | サービスのpassword
:import_type | o | symbol | none | import種別を指定します :in_group => 対象グループを取り込む :user => 特定のユーザーを取り込む


上記必須パラメーター[:client_id,:client_secret,:user,:pass]はEventaskbotFileに記載しておけば自動で設定を読みにいきます。 

#### Example

* グループ単位でユーザー情報をインポートする

EventaskbotFile

```
Eventaskbot::Api::User.configure do |c| 
# User API add setting
  c.user_import = {:service => { :yammer => { :group => [:グループ名] } } 
  }
end

Eventaskbot.configure do |c|
  c.service = {
    :yammer => { #Using Yammer Service
      :client_id     => 'your client_id',
      :client_secret => 'your client_secret',
    }
  }
end

```

* グループ単位でユーザー情報をインポートする

```
eventaskbot user-import '{:import_type => :in_group}'
[Success] Yammer API in_group get
+-------------------------------+--------------------------------------+---------------------------------------+---------------------------------------------+
| id                            | name                                 | mension                               | full_name                                   |
+-------------------------------+--------------------------------------+---------------------------------------+---------------------------------------------+
| 10000000                    | hoge                            | @hoge                            | hoge                      
```








## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

