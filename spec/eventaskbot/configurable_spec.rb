# -*- coding: utf-8 -*-

require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/configurable'

describe Eventaskbot::Configurable, "Eventaskbot Configurable Class" do
  before(:each) do
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Configurable.class).to eq(Module)
  end

  it "インスタンス変数が代入されている事を確認する" do
    assert = [:@plugin_dir]
    Eventaskbot.configure do |v|
      v.plugin_dir = "hoge"
    end

    expect(Eventaskbot.instance_variables).to eq(assert)
  end

  it "インスタンス変数が存在しない場合はエラーになる" do
    expect{
      Eventaskbot.configure do |v|
        v.hoge = "hoge"
      end
    }.to raise_error
  end

  it "設定したインスタンス変数が取得できる" do
    assert = [{:plugin_dir => "hoge"}]
    Eventaskbot.configure do |v|
      v.plugin_dir = "hoge"
    end

    expect(Eventaskbot.options).to eq(assert)
  end

  it "keysメソッドで一覧が取得できる" do
    assert = [:plugin_dir]
    Eventaskbot.configure do |v|
      v.plugin_dir = "hoge"
    end

    expect(Eventaskbot.keys).to eq(assert)
  end

  it "keyメソッドで該当する値が取得できる(symでも文字列でも）" do
    assert = "hoge"
    Eventaskbot.configure do |v|
      v.plugin_dir = assert
    end

    expect(Eventaskbot.key(:plugin_dir)).to  eq("hoge")
    expect(Eventaskbot.key("plugin_dir")).to  eq("hoge")
  end

  it "resetメソッドで設定した変数を初期化できる" do
    assert = [{:plugin_dir => nil}]

    Eventaskbot.configure do |v|
      v.plugin_dir = "hoge"
    end

    Eventaskbot.reset
    expect(Eventaskbot.options).to eq(assert)

  end
end
