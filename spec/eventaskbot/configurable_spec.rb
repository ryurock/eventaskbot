# -*- coding: utf-8 -*-

require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/configurable'

describe Eventaskbot::Configurable, "Eventaskbot Configurable Class" do
  before(:each) do
    Eventaskbot.reset
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Configurable.class).to eq(Module)
  end

  it "インスタンス変数が代入されている事を確認する" do
    assert = :@plugin_dir
    Eventaskbot.configure do |v|
      v.plugin_dir = "hoge"
    end

    expect(Eventaskbot.instance_variables.index(assert)).not_to eq(nil)
  end

  it "インスタンス変数が存在しない場合はエラーになる" do
    expect{
      Eventaskbot.configure do |v|
        v.hoge = "hoge"
      end
    }.to raise_error
  end

  it "設定したインスタンス変数が取得できる" do
    assert = "hoge"
    Eventaskbot.configure do |v|
      v.plugin_dir = assert
    end

    expect(Eventaskbot.options[:plugin_dir]).to eq(assert)
  end

  it "keysメソッドで一覧が取得できる" do
    Eventaskbot.configure do |v|
      v.plugin_dir = "hoge"
    end

    expect(Eventaskbot.keys.size).to be >= 1
  end

  it "resetメソッドで設定した変数を初期化できる" do
    assert = nil

    Eventaskbot.configure do |v|
      v.plugin_dir = "hoge"
    end

    Eventaskbot.reset
    expect(Eventaskbot.options[:plugin_dir]).to eq(assert)
  end
end
