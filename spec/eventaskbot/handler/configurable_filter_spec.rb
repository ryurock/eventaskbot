# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/handler/configurable_filter'

describe Eventaskbot::Handler, "Eventaskbot Handler Config Filter Module" do
  before(:each) do
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Handler::ConfigurableFilter.class).to eq(Module)
  end

  it "filterメソッド実行時にoptionsの値:apiがnilの場合は例外が発生する" do
    expect{ Eventaskbot::Handler::ConfigurableFilter.filter(Eventaskbot.options) }.to raise_error
  end

  it "filterメソッド実行時にoptionsの値:api[:name]がnilの場合は例外が発生する" do
    Eventaskbot.configure do |c|
      c.api = {:name => nil}
    end
    expect{ Eventaskbot::Handler::ConfigurableFilter.filter(Eventaskbot.options) }.to raise_error
  end

  it "filterメソッド実行時に存在しないAPi名の場合は例外が発生する" do
    Eventaskbot.configure do |c|
      c.api = {:name => "hoge"}
    end

    expect{ Eventaskbot::Handler::ConfigurableFilter.filter(Eventaskbot.options) }.to raise_error
  end

  it "filterメソッド実行時にoptionsの値:responseがnilの場合は例外が発生する" do
    Eventaskbot.configure do |c|
      c.api = {:name => "init"}
    end

    expect{ Eventaskbot::Handler::ConfigurableFilter.filter(Eventaskbot.options) }.to raise_error
  end

  it "filterメソッド実行時にoptionsの値:response[:format]がnilの場合は例外が発生する" do
    Eventaskbot.configure do |c|
      c.api = {:name => "init"}
      c.response = {:format => nil}
    end

    expect{ Eventaskbot::Handler::ConfigurableFilter.filter(Eventaskbot.options) }.to raise_error
  end

  it "filterメソッド実行時に存在しないフォーマットの場合は例外が発生する" do
    Eventaskbot.configure do |c|
      c.api = {:name => "init"}
      c.response = {:format => "hoge"}
    end

    expect{ Eventaskbot::Handler::ConfigurableFilter.filter(Eventaskbot.options) }.to raise_error
  end

  it "全てのfilterを通過した場合は例外が発生しない" do
    Eventaskbot.configure do |c|
      c.api = {:name => "init"}
      c.response = {:format => "json"}
    end

    expect{ Eventaskbot::Handler::ConfigurableFilter.filter(Eventaskbot.options) }.to_not raise_error
  end
end
