# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/configurable'
require 'eventaskbot/notifications/yammer/create_thread'

describe Eventaskbot::Notifications::Yammer::CreateThread, "Eventaskbot notifications executable on Yammer Module" do
  before(:each) do
    Eventaskbot.reset
  end

  it "クラスである事の確認" do
    expect(Eventaskbot::Notifications::Yammer::CreateThread.class).to eq(Class)
  end

  it "デフォルトステータスは:fail" do
    yam = Eventaskbot::Notifications::Yammer::CreateThread.new
    expect(yam.res[:status]).to eq(:fail)
  end

  it "必須パラメーターが存在しない場合は:fail" do
    yam = Eventaskbot::Notifications::Yammer::CreateThread.new
    opts = {:hoge => :fuga}
    res = yam.execute(opts)
    expect(res[:status]).to eq(:fail)
  end

  it "グループ情報が取れない場合は:fail" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
    opts = Eventaskbot::Api::Auth.options[:get_oauth_token][:service][:yammer]
    opts[:access_token] = "xxxxxxxxxxxxx"

    #モック
    mock     = double(::Yammer::Client)
    mock_res = double(::Yammer::ApiResponse)

    allow(mock).to receive(:create_message).and_return({})
    allow(mock).to receive(:all_groups).and_return(mock_res)
    allow(mock_res).to receive(:code).and_return(400)
    allow(mock_res).to receive(:body).and_return([{:name => "fuga"}])

    yam = Eventaskbot::Notifications::Yammer::CreateThread.new
    yam.client = mock
    res = yam.execute(opts)
    expect(res[:status]).to eq(:fail)
  end

  it "グループ情報が取れてもグループ名が存在しない場合は:fail" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
    opts = Eventaskbot::Api::Auth.options[:get_oauth_token][:service][:yammer]
    opts[:access_token] = "xxxxxxxxxxxxx"
    opts[:group] = { :yammer => [:hoge] }


    #モック
    mock     = double(::Yammer::Client)
    mock_res = double(::Yammer::ApiResponse)

    allow(mock).to receive(:create_message).and_return({})
    allow(mock).to receive(:all_groups).and_return(mock_res)
    allow(mock_res).to receive(:code).and_return(200)
    allow(mock_res).to receive(:body).and_return([{:name => "fuga"}])

    yam = Eventaskbot::Notifications::Yammer::CreateThread.new
    yam.client = mock
    res = yam.execute(opts)
    expect(res[:status]).to eq(:fail)
  end

  it "グループ情報が取れてもグループ名が存在する場合は:ok" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
    opts = Eventaskbot::Api::Auth.options[:get_oauth_token][:service][:yammer]
    opts[:access_token] = "xxxxxxxxxxxxx"
    opts[:group] = { :yammer => [:fuga] }


    #モック
    mock     = double(::Yammer::Client)
    mock_res = double(::Yammer::ApiResponse)

    allow(mock).to receive(:create_message).and_return({})
    allow(mock).to receive(:all_groups).and_return(mock_res)
    allow(mock_res).to receive(:code).and_return(200)
    allow(mock_res).to receive(:body).and_return([{:name => "fuga"}])

    yam = Eventaskbot::Notifications::Yammer::CreateThread.new
    yam.client = mock
    res = yam.execute(opts)
    expect(res[:status]).to eq(:ok)
  end

#  it "レスポンスコードが２００ではない場合は:fail" do
#    Eventaskbot.configure do |c|
#      c.api = { :name => "get-oauth-token", :type => :auth }
#      c.response = { :format => "json" }
#    end
#
#    Eventaskbot::Configurable::Merge.config_file({})
#    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
#    opts = Eventaskbot::Api::Auth.options[:get_oauth_token][:service][:yammer]
#    opts[:access_token] = "xxxxxxxxxxxxx"
#
#    #モック
#    mock     = double(::Yammer::Client)
#    mock_res = double(::Yammer::ApiResponse)
#
#    allow(mock).to receive(:create_message).and_return({})
#    allow(mock).to receive(:all_groups).and_return(mock_res)
#    allow(mock_res).to receive(:code).and_return(400)
#
#    yam = Eventaskbot::Notifications::Yammer::GetOauthToken.new
#    yam.client = mock
#    res = yam.execute(opts)
#    expect(res[:status]).to eq(:fail)
#  end
#
#  it "グループ情報が取得できない場合は:fail" do
#    Eventaskbot.configure do |c|
#      c.api = { :name => "get-oauth-token", :type => :auth }
#      c.response = { :format => "json" }
#    end
#
#    Eventaskbot::Configurable::Merge.config_file({})
#    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
#    opts = Eventaskbot::Api::Auth.options[:get_oauth_token][:service][:yammer]
#    opts[:access_token] = "xxxxxxxxxxxxx"
#    opts[:group] = { :yammer => [:hoge] }
#
#    #モック
#    mock     = double(::Yammer::Client)
#    mock_res = double(::Yammer::ApiResponse)
#
#    allow(mock).to receive(:create_message).and_return({})
#    allow(mock).to receive(:all_groups).and_return(mock_res)
#    allow(mock_res).to receive(:code).and_return(200)
#    allow(mock_res).to receive(:body).and_return([{:name => "fuga"}])
#
#    yam = Eventaskbot::Notifications::Yammer::GetOauthToken.new
#    yam.client = mock
#    res = yam.execute(opts)
#    expect(res[:status]).to eq(:fail)
#  end
#
#  it "グループ情報が取得できた場合は:ok" do
#    Eventaskbot.configure do |c|
#      c.api = { :name => "get-oauth-token", :type => :auth }
#      c.response = { :format => "json" }
#    end
#
#    Eventaskbot::Configurable::Merge.config_file({})
#    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
#    opts = Eventaskbot::Api::Auth.options[:get_oauth_token][:service][:yammer]
#    opts[:access_token] = "xxxxxxxxxxxxx"
#    opts[:group] = { :yammer => [:hoge] }
#
#    #モック
#    mock     = double(::Yammer::Client)
#    mock_res = double(::Yammer::ApiResponse)
#
#    allow(mock).to receive(:create_message).and_return({})
#    allow(mock).to receive(:all_groups).and_return(mock_res)
#    allow(mock_res).to receive(:code).and_return(200)
#    allow(mock_res).to receive(:body).and_return([{:name => "hoge"}])
#
#    yam = Eventaskbot::Notifications::Yammer::GetOauthToken.new
#    yam.client = mock
#    res = yam.execute(opts)
#    expect(res[:status]).to eq(:ok)
#  end
end
