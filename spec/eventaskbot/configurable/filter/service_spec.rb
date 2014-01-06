# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/auth'
require 'eventaskbot/configurable/filter/service'

describe Eventaskbot::Configurable::Filter::Service, "Eventaskbot configurable filter to service Module" do
  before(:each) do
    Eventaskbot.reset
    Eventaskbot::Api::Auth.reset
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Configurable::Filter::Service.class).to eq(Module)
  end

  it "filterメソッド実行時にサービスの設定を何も指定していない場合は空のHash" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
    end
    obj = Eventaskbot::Configurable::Filter::Service
    expect(obj.filter).to eq({})
  end

  it "filterメソッド実行時にAPIパラメータにサービスの設定をした場合は反映される" do
    Eventaskbot.configure do |c|
      c.api = {
        :name   => 'get-oauth-token',
        :type   => :auth,
        :params => {
          :service => { 
            :yammer => {
              :client_id => 'hoge'
            }
          }
        }
      }
    end

    obj = Eventaskbot::Configurable::Filter::Service
    expect(obj.filter).to eq({ :yammer => { :client_id => 'hoge' }  })
  end

  it "filterメソッド実行時に親設定にサービスの設定をした場合は反映される" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
      c.service = { :yammer => { :client_id => 'hoge' } }
    end
    obj = Eventaskbot::Configurable::Filter::Service
    expect(obj.filter).to eq({ :yammer => { :client_id => 'hoge' }  })
  end

  it "filterメソッド実行時にsub設定にサービスの設定をした場合は反映される" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = { :service => { :yammer => { :client_id => 'hoge' } } }
    end
    obj = Eventaskbot::Configurable::Filter::Service
    expect(obj.filter).to eq({ :yammer => { :client_id => 'hoge' }  })
  end

  it "filterメソッド実行時に親設定+sub設定にサービスの設定をした場合は値がマージされる" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
      c.service = { :yammer => { :client_id => 'hoge' } }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = { :service => { :yammer => { :client_secret => 'fuga' } } }
    end

    obj = Eventaskbot::Configurable::Filter::Service
    expect(obj.filter).to eq({ :yammer => { :client_id => 'hoge', :client_secret => 'fuga' }  })
  end

  it "filterメソッド実行時にAPIパラメーターのマージが一番最後なのでAPIパラメーターの値で上書きできる" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => { :service => { :yammer => { :client_id => 'api_params' } }  } }
      c.service = { :yammer => { :client_id => 'hoge' } }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = { :service => { :yammer => { :client_secret => 'fuga' } } }
    end

    obj = Eventaskbot::Configurable::Filter::Service
    expect(obj.filter).to eq({ :yammer => { :client_id => 'api_params', :client_secret => 'fuga' }  })
  end

  it "filterメソッド実行時に複数のサービスのパラメーターがマージされる" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
      c.service = { :yammer => { :client_id => 'hoge' } }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = { 
        :service => { 
          :yammer  => { :client_secret => 'fuga' },
          :redmine => { :client_secret => 'fuga' }
        }
      }
    end

    obj = Eventaskbot::Configurable::Filter::Service
    expect(obj.filter).to eq({ 
      :yammer  => { :client_id => 'hoge', :client_secret => 'fuga' },
      :redmine => { :client_secret => 'fuga' },
    })
  end
end
