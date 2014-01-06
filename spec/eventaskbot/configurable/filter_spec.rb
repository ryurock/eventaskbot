# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/configurable/filter'

describe Eventaskbot::Configurable::Filter, "Eventaskbot Configurable Filter Module" do
  before(:each) do
    Eventaskbot.reset
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Configurable::Filter.class).to eq(Module)
  end

  it "全てのfilterを通過した場合は例外が発生しない" do
    Eventaskbot.configure do |c|
      c.api = {:name => "init", :type => :file}
      c.response = {:format => "json"}
    end

    expect{ Eventaskbot::Configurable::Filter.filter(Eventaskbot.options) }.to_not raise_error
  end

  it "filterを実行するとserviceの設定は全てsub設定にマージされる" do
    Eventaskbot.configure do |c|
      c.api = { :name => 'get-oauth-token', :type => :auth, :params => {} }
      c.service = { :yammer => { :client_id => 'hoge' } }
      c.response = {:format => :json}
    end

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = { 
        :service => { 
          :yammer  => { :client_secret => 'fuga' },
          :redmine => { :client_secret => 'fuga' }
        }
      }
    end
    
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
    pp Eventaskbot::Api::Auth.options
  end

end
