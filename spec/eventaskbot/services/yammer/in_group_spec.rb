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

  it "APiレスポンスコードが200ではない場合は:fail" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)

    yam = Eventaskbot::Services::Yammer::InGroup.new


    #モック
    mock = double(Yammer::Client)
    mock_res = double(::Yammer::ApiResponse)

    allow(mock).to receive(:get).and_return(mock_res)
    allow(mock_res).to receive(:code).and_return(400)

    yam.client = mock

    opts = {:group => { :yammer => [:techadmin] } }
    res = yam.execute(opts)
    expect(res[:status]).to eq(:fail)
  end

  it "必須パラメーターが存在する場合はok" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)

    yam = Eventaskbot::Services::Yammer::InGroup.new

    #モック
    mock = double(Yammer::Client)
    mock_res = double(::Yammer::ApiResponse)

    allow(mock).to receive(:get).and_return(mock_res)
    allow(mock_res).to receive(:code).and_return(200)
    allow(mock_res).to receive(:body).and_return({
      :more_available => false,
      :users          => [
        {
          :type => "user",
          :id   => 10000000,
          :name => "fuga",
          :full_name => "hoge_fuga"

        }
      ]
    })

    opts = {:group => { :yammer => [:techadmin] } }
    res = yam.execute(opts)
    expect(res[:status]).to eq(:ok)
  end
end
