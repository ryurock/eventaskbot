# -*- coding: utf-8 -*-

require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

require 'rspec/mocks/standalone'

require 'eventaskbot'
require 'eventaskbot/service'

describe Eventaskbot::Service, "Eventaskbot Service Class" do
  before(:each) do
    Eventaskbot.reset
    Eventaskbot.configure do |c|
      c.service = { :yammer => { :client_id => "hoge", :client_secret => "fuga" } }
      c.config_file = {:path => "EvetnaskbotFile"}
      c.response = nil
      c.plugin_dir = nil
    end
    Eventaskbot::Api::Auth.reset
  end

  it "クラスである事の確認" do
    expect(Eventaskbot::Service.class).to eq(Class)
  end

  it "importメソッド実行時でベースの設定しか設定をしていない場合の戻り値はベースの設定とイコール" do
    assert = { :yammer => { :client_id => "hoge", :client_secret => "fuga" } }

    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
    end

    service = Eventaskbot::Service.new
    service.import
    service.params.delete(:klass)
    expect(service.params).to eq(assert)
  end

  it "importメソッド実行時でベースの設定+sub設定をしている場合の戻り値はベースの設定とマージされる" do
    assert = { :yammer => { :client_id => "hoge", :client_secret => "fuga", :user => "user1" } }

    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = {:service => { :yammer => { :user => "user1"} } }
    end

    service = Eventaskbot::Service.new
    service.import
    service.params.delete(:klass)
    expect(service.params).to eq(assert)
  end

  it "importメソッド実行時でベースの設定+sub設定+params設定をしている場合の戻り値はベースの設定とマージされる" do
    assert = { :yammer => { :client_id => "hoge", :client_secret => "fuga", :user => "user1", :pass => "pass" } }

    Eventaskbot.configure do |c|
      c.api = { 
        :name => 'get-oauth-token',
        :type => :auth,
        :params => { 
          :service => {
            :yammer => { :pass => "pass" }
          }
        }
      }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = {:service => { :yammer => { :user => "user1"} } }
    end

    service = Eventaskbot::Service.new
    service.import
    service.params.delete(:klass)
    expect(service.params).to eq(assert)
  end

  it "importメソッド実行時でベースの設定+sub設定をしているがsub設定でserviceの指定で:yammerを除外しているので中身は空のHash" do
    assert = { }

    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = {
        :service => { :yammer => { :user => "user1"} },
        :services => [:redmine]
      }
    end

    service = Eventaskbot::Service.new
    service.import
    expect(service.params).to eq(assert)
  end

  it "importメソッド実行時でベースの設定+sub設定をしているがapiパラメーターの設定でserviceの指定で:yammerを除外しているので中身は空のHash" do
    assert = { }

    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {:services => [:redmine]} }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = {
        :service => { :yammer => { :user => "user1"} }
      }
    end

    service = Eventaskbot::Service.new
    service.import
    expect(service.params).to eq(assert)
  end

  it "importメソッド実行時でserviceがない場合の@servicesは空の配列" do
    assert = []

    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {:services => [:redmine]} }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = {
        :service => { :yammer => { :user => "user1"} }
      }
    end

    service = Eventaskbot::Service.new
    service.import
    expect(service.services).to eq(assert)
  end

  it "importメソッド実行時でserviceがある場合の@servicesは配列に値が入っている" do
    assert = [:yammer]

    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = {
        :service => { :yammer => { :user => "user1"} }
      }
    end

    service = Eventaskbot::Service.new
    service.import
    expect(service.services).to eq(assert)
  end

  it "has_service?メソッド実行時でserviceがある場合はtrue" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = {
        :service => { :yammer => { :user => "user1"} }
      }
    end

    service = Eventaskbot::Service.new
    service.import
    expect(service.has_service?).to eq(true)
  end

  it "has_service?メソッド実行時でserviceがない場合はfalse" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = {
        :service => { :yammer => { :user => "user1"} },
        :services => [:redmine]
      }
    end

    service = Eventaskbot::Service.new
    service.import
    expect(service.has_service?).to eq(false)
  end
end
