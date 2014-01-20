# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/auth'
require 'eventaskbot/configurable/filter/storage'
require 'redis'
require 'hiredis'

describe Eventaskbot::Configurable::Filter::Storage, "Eventaskbot configurable filter to Storage Module" do
  before(:each) do
    Eventaskbot.reset
    Eventaskbot::Api::Auth.reset
    @client = Redis.new(:host => '1127.0.0.1', :port => '6379', driver: :hiredis)
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Configurable::Filter::Storage.class).to eq(Module)
  end

  it "filterメソッド実行時にストレージの設定を何も指定していない場合は空のHash" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
    end

    obj = Eventaskbot::Configurable::Filter::Storage
    storage = obj.filter
    expect(storage).to eq({})
  end

  it "filterメソッド実行時にAPIパラメータにストレージの設定をした場合は反映される" do
    Eventaskbot.configure do |c|
      c.api = {
        :name   => 'get-oauth-token',
        :type   => :auth,
        :params => {
          :storage => { 
            :driver => @client
          }
        }
      }
    end

    obj = Eventaskbot::Configurable::Filter::Storage
    storage = obj.filter
    expect(storage).to eq({ :driver =>  @client})
  end

  it "filterメソッド実行時に親設定にストレージの設定をした場合は反映される" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
      c.storage = { :driver => @client }
    end
    obj = Eventaskbot::Configurable::Filter::Storage
    notify = obj.filter
    expect(notify).to eq({ :driver => @client  })
  end

  it "filterメソッド実行時にsub設定にストレージの設定をした場合は反映される" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = { :storage => { :driver => @client } }
    end
    obj = Eventaskbot::Configurable::Filter::Storage
    storage = obj.filter
    expect(storage).to eq({ :driver => @client })
  end

  it "filterメソッド実行時に親設定+sub設定にストレージの設定をした場合は値がマージされる" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
      c.storage = { :driver => @client }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = { :storage => { :driver => :overide } }
    end

    obj = Eventaskbot::Configurable::Filter::Storage
    storage = obj.filter
    expect(storage).to eq({ :driver => :overide })
  end

  it "filterメソッド実行時にAPIパラメーターのマージが一番最後なのでAPIパラメーターの値で上書きできる" do
    Eventaskbot.configure do |c|
      c.api    = { :name => 'get-oauth-token', :type => :auth, :params => { :storage => { :driver => :param_over }  } }
      c.storage = { :driver => @client }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = { :storage => { :driver => :overide_auth } }
    end

    obj = Eventaskbot::Configurable::Filter::Storage
    storage = obj.filter
    expect(storage).to eq({ :driver => :param_over  })
  end
end
