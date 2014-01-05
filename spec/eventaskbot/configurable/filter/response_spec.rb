# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/configurable/filter/response'

describe Eventaskbot::Configurable::Filter::Service, "Eventaskbot configurable filter to response Module" do
  before(:each) do
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Configurable::Filter::Response.class).to eq(Module)
  end

  it "filterメソッド実行時にoptionsの値optsがnilの場合は例外が発生" do
    opts = nil
    expect{ Eventaskbot::Configurable::Filter::Response.filter(opts) }.to raise_error
  end

  it "filterメソッド実行時にoptsに:formatのキーが存在しない場合は例外が発生" do
    opts = {:hoge => {}}
    expect{ Eventaskbot::Configurable::Filter::Response.filter(opts) }.to raise_error
  end

  it "filterメソッド実行時に存在しないフォーマットがあった場合は例外が発生" do
    opts = {:format => :hoge}
    expect{ Eventaskbot::Configurable::Filter::Response.filter(opts) }.to raise_error
  end

  it "filterメソッド実行時に存在するフォーマットがあった場合は例外が発生しない" do
    opts = {:format => :json}
    expect{ Eventaskbot::Configurable::Filter::Response.filter(opts) }.not_to raise_error
  end
end
