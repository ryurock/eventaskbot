# -*- coding: utf-8 -*-

require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

require 'rspec/mocks/standalone'

require 'eventaskbot'
require 'eventaskbot/response'

describe Eventaskbot::Response, "Eventaskbot Response Class" do
  before(:each) do
    Eventaskbot.reset
    @mock_api = double("Eventaskbot::Api::File::Init")

    allow(@mock_api).to receive(:res).and_return({
      :status   => :ok,
      :message  => "hoge"
    })
  end

  it "クラスである事の確認" do
    expect(Eventaskbot::Response.class).to eq(Class)
  end

  it "APIのstatusがokの場合は:okが返ってくる" do
    allow(@mock_api).to receive(:execute).and_return({
      :status   => :ok,
      :message  => "hoge"
    })
    res = Eventaskbot::Response.new @mock_api
    expect(res.status).to eq(:ok)
  end

  it "APIのstatusがfailの場合は:failが返ってくる" do
    allow(@mock_api).to receive(:res).and_return({
      :status   => :fail,
      :message  => "hoge"
    })
    res = Eventaskbot::Response.new @mock_api
    expect(res.status).to eq(:fail)
  end

  it "APIのmessageを取得できる" do
    allow(@mock_api).to receive(:res).and_return({
      :status   => :fail,
      :message  => "hoge"
    })
    res = Eventaskbot::Response.new @mock_api
    expect(res.message).to eq("hoge")
  end

  it "APIのstatusが:okの場合はtrue" do
    allow(@mock_api).to receive(:res).and_return({
      :status   => :ok,
      :message  => "hoge"
    })
    res = Eventaskbot::Response.new @mock_api
    expect(res.status_ok?).to eq(true)
  end

  it "APIのstatusが:failの場合はfalse" do
    allow(@mock_api).to receive(:res).and_return({
      :status   => :fail,
      :message  => "hoge"
    })
    res = Eventaskbot::Response.new @mock_api
    expect(res.status_ok?).to eq(false)
  end
end
