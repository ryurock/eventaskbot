# -*- coding: utf-8 -*-

require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

require 'rspec/mocks/standalone'

require 'eventaskbot'
require 'eventaskbot/storage'

describe Eventaskbot::Storage, "Eventaskbot Storage Class" do
  before(:each) do
    Eventaskbot.reset
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Storage.class).to eq(Module)
  end

  it "ストレージドライバーをオプションで設定できるか？" do
    opts = { :storage => { :driver => Redis.new(:host => "127.0.0.1", :port => "6379", driver: :hiredis) } }
    storage = Eventaskbot::Storage.driver opts
    expect(storage).to eq(Eventaskbot::Storage::Driver)
  end

  it "ストレージドライバーをオプションなしで取得できるか？" do
    Eventaskbot::Configurable::Merge.config_file({})
    storage = Eventaskbot::Storage.driver
    expect(storage).to eq(Eventaskbot::Storage::Driver)
  end
end
