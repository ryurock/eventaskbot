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
    driver.del("notify_thread_id_yammer_tech_admin")
    Eventaskbot.reset
    Eventaskbot::Api::Auth.reset
    Eventaskbot::Storage::Driver.set(nil)
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Storage.class).to eq(Module)
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

  it "データのセットに失敗した場合はfalseを返す" do
    Eventaskbot::Configurable::Merge.config_file({})

    mock = double(Eventaskbot::Storage::Driver)
    allow(mock).to receive(:set).and_return("FAIL")

    storage = Eventaskbot::Storage.register_driver({ :driver => mock})
    expect(storage.set("test_oauth_token", "hoge")).to eq(false)
  end

  it "データのセットに成功した場合はtrueを返す" do
    Eventaskbot::Configurable::Merge.config_file({})

    storage = Eventaskbot::Storage.register_driver
    expect(storage.set("test_oauth_token", "hoge")).to eq(true)
  end

  it "グループが存在しない場合はnilが返る" do
    Eventaskbot::Configurable::Merge.config_file({})

    storage = Eventaskbot::Storage.register_driver
    expect(storage.find_notify_thread_group_id(:yammer,:tech_admin)).to eq(nil)
  end

  it "グループが存在する場合はnilが返らない" do
    Eventaskbot::Configurable::Merge.config_file({})

    driver = Eventaskbot.options[:storage][:driver]
    driver.set('notify_thread_id_yammer_tech_admin', 10)
    storage = Eventaskbot::Storage.register_driver
    expect(storage.find_notify_thread_group_id(:yammer,:tech_admin)).not_to eq(nil)
  end

  it "データを削除できるか？" do
    Eventaskbot::Configurable::Merge.config_file({})
    driver = Eventaskbot.options[:storage][:driver]
    driver.set("test_oauth_token", "hoge")
    storage = Eventaskbot::Storage.register_driver
    expect(storage.del("test_oauth_token")).to eq(1)
  end
end
