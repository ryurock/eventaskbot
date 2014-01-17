# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/auth'
require 'eventaskbot/configurable/filter/notify'

describe Eventaskbot::Configurable::Filter::Notify, "Eventaskbot configurable filter to notify Module" do
  before(:each) do
    Eventaskbot.reset
    Eventaskbot::Api::Auth.reset
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Configurable::Filter::Notify.class).to eq(Module)
  end

  it "filterメソッド実行時に通知の設定を何も指定していない場合は空のHash" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
    end

    obj = Eventaskbot::Configurable::Filter::Notify
    notify = obj.filter
    expect(notify).to eq({})
  end

  it "filterメソッド実行時にAPIパラメータに通知の設定をした場合は反映される" do
    Eventaskbot.configure do |c|
      c.api = {
        :name   => 'get-oauth-token',
        :type   => :auth,
        :params => {
          :notify => { 
            :service => [:yammer]
          }
        }
      }
    end

    obj = Eventaskbot::Configurable::Filter::Notify
    notify = obj.filter
    notify.delete(:klass)
    expect(notify).to eq({ :service => [:yammer], :prehook => true, :afterhook => true  })
  end

  it "filterメソッド実行時に親設定に通知の設定をした場合は反映される" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
      c.notify = { :prehook => true }
    end
    obj = Eventaskbot::Configurable::Filter::Notify
    notify = obj.filter
    expect(notify).to eq({ :prehook => true  })
  end

  it "filterメソッド実行時にsub設定に通知の設定をした場合は反映される" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = { :notify => { :prehook => true } }
    end
    obj = Eventaskbot::Configurable::Filter::Notify
    notify = obj.filter
    expect(notify).to eq({ :prehook => true })
  end

  it "filterメソッド実行時に親設定+sub設定にサービスの設定をした場合は値がマージされる" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
      c.notify = { :prehook => true }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = { :notify => { :prehook => false, :afterhook => false } }
    end

    obj = Eventaskbot::Configurable::Filter::Notify
    notify = obj.filter
    expect(notify).to eq({ :prehook => false, :afterhook => false })
  end

  it "filterメソッド実行時にAPIパラメーターのマージが一番最後なのでAPIパラメーターの値で上書きできる" do
    Eventaskbot.configure do |c|
      c.api    = { :name => 'get-oauth-token', :type => :auth, :params => { :notify => { :service => [:yammer], :prehook => true }  } }
      c.notify = { :prehook => true }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = { :notify => { :prehook => false, :afterhook => false } }
    end

    obj = Eventaskbot::Configurable::Filter::Notify
    notify = obj.filter
    notify.delete(:klass)
    expect(notify).to eq({ :prehook => true, :service => [:yammer], :afterhook => false  })
  end

  it "filterメソッド実行時に複数の通知のパラメーターがマージされる" do
    Eventaskbot.configure do |c|
      c.api    = { :name => 'get-oauth-token', :type => :auth, :params => { :notify => { :service => [:yammer], :prehook => true }  } }
      c.notify = { :prehook => true }
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = { :notify => { :prehook => false, :afterhook => true } }
    end

    obj = Eventaskbot::Configurable::Filter::Notify
    notify = obj.filter
    notify.delete(:klass)
    expect(notify).to eq({ :prehook => true, :service => [:yammer], :afterhook => true  })
  end
end
