# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/configurable'
require 'eventaskbot/services/yammer/in_group'

describe Eventaskbot::Services::Yammer::InGroup, "Eventaskbot service executable on Yammer InGroup Import Module" do
  before(:each) do
  end

  it "クラスである事の確認" do
    expect(Eventaskbot::Services::Yammer::InGroup.class).to eq(Class)
  end

  it "デフォルトステータスは:fail" do
    yam = Eventaskbot::Services::Yammer::InGroup.new
    expect(yam.res[:status]).to eq(:fail)
  end

  it "必須パラメーターが存在しない場合は:fail" do
    yam = Eventaskbot::Services::Yammer::InGroup.new
    opts = {:test => [:techadmin]}
    res = yam.execute(opts)
    expect(res[:status]).to eq(:fail)
  end

  it "codeが上手く取得できない場合はエラーになる" do
    Eventaskbot.configure do |c|
      c.api = { :name => "in-group", :type => :collector }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
    opts = Eventaskbot::Api::Collector.options[:in_group][:yammer]

#    #モック
#    mock = double(Mechanize)
#
#    allow(mock).to receive(:get).and_return(mock)
#    allow(mock).to receive(:form_with).and_return(mock)
#    allow(mock).to receive(:submit).and_return(mock)

    yam = Eventaskbot::Services::Yammer::InGroup.new
    #yam.client = mock
    res = yam.execute(opts)
    expect(res[:status]).to eq(:fail)
  end

#  it "codeが上手く取得できた場合" do
#    #モック
#    mock = double(Mechanize)
#
#    allow(mock).to receive(:get).and_return(mock)
#    allow(mock).to receive(:form_with).and_return(mock)
#    allow(mock).to receive(:submit).and_return(mock)
#    allow(mock).to receive(:body).and_return(MultiJson.dump({:access_token => { :token => "aaabbbbcccc" } }))
#
#    Eventaskbot.configure do |c|
#      c.api = { :name => "get-oauth-token", :type => :auth }
#      c.response = { :format => "json" }
#    end
#
#    Eventaskbot::Configurable::Merge.config_file({})
#    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
#    opts = Eventaskbot::Api::Auth.options[:get_oauth_token][:service]
#
#    yam = Eventaskbot::Services::Yammer::GetOauthToken.new
#    yam.client = mock
#    yam.code = "hoge"
#
#    opts.each do |service,v|
#      res = yam.execute(v)
#      expect(res[:status]).to eq(:ok)
#    end
#  end
end
