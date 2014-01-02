# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/configurable/filter/service'

describe Eventaskbot::Configurable::Filter::Service, "Eventaskbot configurable filter to service Module" do
  before(:each) do
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Configurable::Filter::Service.class).to eq(Module)
  end

  it "filterメソッド実行時にoptionsの値optsがnilの場合は例外が発生しない" do
    opts = nil
    expect{ Eventaskbot::Configurable::Filter::Service.filter(opts) }.not_to raise_error
  end

  it "filterメソッド実行時にoptionsの値optsがHashではない場合は例外が発生" do
    opts = []
    expect{ Eventaskbot::Configurable::Filter::Service.filter(opts) }.to raise_error
  end

  it "filterメソッド実行時にpluginにファイルがない場合は例外が発生する" do
    opts = {:hoge => {}}
    expect{ Eventaskbot::Configurable::Filter::Service.filter(opts) }.to raise_error
  end

  it "filterメソッド実行時にpluginsにファイルが存在する場合は例外が発生しない" do
    opts = {:yammer => {}}
    expect{ Eventaskbot::Configurable::Filter::Service.filter(opts) }.not_to raise_error
  end

  it "filterメソッド実行時にpluginsのオプションを追加してもエラーが発生しない" do
    opts = {:yammer => {:secret_token => "hoge", :token => "fuga"}}
    expect{ Eventaskbot::Configurable::Filter::Service.filter(opts) }.not_to raise_error
  end
end
