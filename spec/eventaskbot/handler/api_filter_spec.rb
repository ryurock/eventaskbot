# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/handler/api_filter'

describe Eventaskbot::Handler, "Eventaskbot Handler API Filter Module" do
  before(:each) do
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Handler::ApiFilter.class).to eq(Module)
  end

  it "filterメソッド実行時にoptionsの値optsがnilの場合は例外が発生する" do
    opts = nil
    expect{ Eventaskbot::Handler::ApiFilter.filter(opts) }.to raise_error
  end

  it "filterメソッド実行時にoptionsの値opts[:name]がnilの場合は例外が発生する" do
    opts = {:name => nil}
    expect{ Eventaskbot::Handler::ApiFilter.filter(opts) }.to raise_error
  end

  it "filterメソッド実行時に存在しないAPi名の場合は例外が発生する" do
    opts = {:name => "hoge"}

    expect{ Eventaskbot::Handler::ApiFilter.filter(opts) }.to raise_error
  end

  it "init,get-oauth-tokenのAPI種別は:etcである" do

    ["init", "get-oauth-token"].each do |v|
      opts = {:name => v}

      expect(Eventaskbot::Handler::ApiFilter.filter(opts)).to eq({:name => v, :type => :etc})
    end
  end

  it "terget-set,has-ticketのAPI種別は:collectorである" do
    ["terget-set", "has-ticket"].each do |v|
      opts = {:name => v}

      expect(Eventaskbot::Handler::ApiFilter.filter(opts)).to eq({:name => v, :type => :collector})
    end
  end

  it "filterの戻り値はHash" do
    opts = {:name => "init"}

    expect(Eventaskbot::Handler::ApiFilter.filter(opts).class).to eq(Hash)
  end

end
