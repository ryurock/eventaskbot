# -*- coding: utf-8 -*-

require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

require 'rspec/mocks/standalone'

require 'eventaskbot'
require 'eventaskbot/storage'

describe Eventaskbot::Storage, "Eventaskbot Storage Class" do
  before(:each) do
    Eventaskbot::Configurable::Merge.config_file({})
    driver = Eventaskbot.options[:storage][:driver]
    driver.del("test_oauth_token")
    Eventaskbot.reset
    Eventaskbot::Api::Auth.reset
    Eventaskbot::Storage::Driver.set(nil)
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Storage.class).to eq(Module)
  end

  it "デフォルトのドライバーはnil" do
    opts = { :storage => { :driver => Redis.new(:host => "127.0.0.1", :port => "6379", driver: :hiredis) } }
    storage = Eventaskbot::Storage.driver
    expect(storage.nil?).to eq(true)
  end

  it "ストレージドライバーの設定なしの場合でもnilにならない" do
    Eventaskbot::Configurable::Merge.config_file({})
    storage = Eventaskbot::Storage.register_driver
    expect(storage.driver.nil?).not_to eq(true)
  end

  it "ストレージドライバーの設定ありの場合は値が入る" do
    Eventaskbot::Configurable::Merge.config_file({})
    storage = Eventaskbot::Storage.register_driver( { :driver => :test })
    expect(storage.driver).to eq(:test)
  end

  it "データのないキーをアクセスした場合はnil" do
    Eventaskbot::Configurable::Merge.config_file({})
    storage = Eventaskbot::Storage.register_driver
    expect(storage.get("hogehoge")).to eq(nil)
  end

  it "データのあるキーをアクセスした場合" do
    Eventaskbot::Configurable::Merge.config_file({})
    driver = Eventaskbot.options[:storage][:driver]
    driver.set("test_oauth_token", "hoge")
    storage = Eventaskbot::Storage.register_driver
    expect(storage.get("test_oauth_token")).to eq("hoge")
  end

  it "データを削除できるか？" do
    Eventaskbot::Configurable::Merge.config_file({})
    driver = Eventaskbot.options[:storage][:driver]
    driver.set("test_oauth_token", "hoge")
    storage = Eventaskbot::Storage.register_driver
    expect(storage.del("test_oauth_token")).to eq(1)
  end
end
