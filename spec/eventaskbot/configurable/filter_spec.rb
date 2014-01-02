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

  it "filterメソッド実行時にoptionsの値:responseがnilの場合は例外が発生する" do
    Eventaskbot.configure do |c|
      c.api = {:name => "init"}
    end

    expect{ Eventaskbot::Configurable::Filter.filter(Eventaskbot.options) }.to raise_error
  end

  it "filterメソッド実行時にoptionsの値:response[:format]がnilの場合は例外が発生する" do
    Eventaskbot.configure do |c|
      c.api = {:name => "init"}
      c.response = {:format => nil}
    end

    expect{ Eventaskbot::Configurable::Filter.filter(Eventaskbot.options) }.to raise_error
  end

  it "filterメソッド実行時に存在しないフォーマットの場合は例外が発生する" do
    Eventaskbot.configure do |c|
      c.api = {:name => "init"}
      c.response = {:format => "hoge"}
    end

    expect{ Eventaskbot::Configurable::Filter.filter(Eventaskbot.options) }.to raise_error
  end

  it "全てのfilterを通過した場合は例外が発生しない" do
    Eventaskbot.configure do |c|
      c.api = {:name => "init"}
      c.response = {:format => "json"}
    end

    expect{ Eventaskbot::Configurable::Filter.filter(Eventaskbot.options) }.to_not raise_error
  end

end
