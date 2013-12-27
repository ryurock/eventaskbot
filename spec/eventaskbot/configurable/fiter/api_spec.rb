# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/configurable/filter/api'

describe Eventaskbot::Configurable::Filter::Api, "Eventaskbot configurable filter to api Module" do
  before(:each) do
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Configurable::Filter::Api.class).to eq(Module)
  end

  it "filterメソッド実行時にoptionsの値optsがnilの場合は例外が発生する" do
    opts = nil
    expect{ Eventaskbot::Configurable::Filter::Api.filter(opts) }.to raise_error
  end

  it "filterメソッド実行時にoptionsの値opts[:name]がnilの場合は例外が発生する" do
    opts = {:name => nil}
    expect{ Eventaskbot::Configurable::Filter::Api.filter(opts) }.to raise_error
  end

  it "filterメソッド実行時に存在しないAPi名の場合は例外が発生する" do
    opts = {:name => "hoge"}

    expect{ Eventaskbot::Configurable::Filter::Api.filter(opts) }.to raise_error
  end

  it "init,get-oauth-tokenのAPI種別は:etcである" do

    ["init", "get-oauth-token"].each do |v|
      opts = {:name => v}
      res  = Eventaskbot::Configurable::Filter::Api.filter(opts)
      expect(res[:type]).to eq(:etc)
    end
  end

  it "init,get-oauth-tokenのAPI名がレスポンスに入ってる事" do

    ["init", "get-oauth-token"].each do |v|
      opts = {:name => v}
      res  = Eventaskbot::Configurable::Filter::Api.filter(opts)
      expect(res[:name]).to eq(v)
    end
  end

  it "init,get-oauth-tokenのAPIインスタンスがレスポンスに入ってる事" do
    opts = {:name => 'init'}
    res  = Eventaskbot::Configurable::Filter::Api.filter(opts)
    expect(res[:klass].class).to eq(Eventaskbot::Api::Etc::Init)

    opts = {:name => 'get-oauth-token'}
    res  = Eventaskbot::Configurable::Filter::Api.filter(opts)
    expect(res[:klass].class).to eq(Eventaskbot::Api::Etc::GetOauthToken)
  end

  it "terget-set,has-ticketのAPI種別は:collectorである" do
    ["terget-set", "has-ticket"].each do |v|
      opts = {:name => v}

      res  = Eventaskbot::Configurable::Filter::Api.filter(opts)
      expect(res[:type]).to eq(:collector)
    end
  end

  it "terget-set,has-ticketのAPI名がレスポンスに入ってる事" do
    ["terget-set", "has-ticket"].each do |v|
      opts = {:name => v}

      res  = Eventaskbot::Configurable::Filter::Api.filter(opts)
      expect(res[:name]).to eq(v)
    end
  end

  it "terget-set,has-ticketのAPIインスタンスがレスポンスに入ってる事" do
    opts = {:name => 'terget-set'}
    res  = Eventaskbot::Configurable::Filter::Api.filter(opts)
    expect(res[:klass].class).to eq(Eventaskbot::Api::Collector::TergetSet)

    opts = {:name => 'has-ticket'}
    res  = Eventaskbot::Configurable::Filter::Api.filter(opts)
    expect(res[:klass].class).to eq(Eventaskbot::Api::Collector::HasTicket)
  end

  it "filterの戻り値はHash" do
    opts = {:name => "init"}

    expect(Eventaskbot::Configurable::Filter::Api.filter(opts).class).to eq(Hash)
  end

end
