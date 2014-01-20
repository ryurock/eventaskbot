# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/storage/driver'

describe Eventaskbot::Storage::Driver, "Eventaskbot Storage Driver Module" do
  before(:each) do
    Eventaskbot.reset
    @mock = double(Redis)
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Storage::Driver.class).to eq(Module)
  end

  it "ドライバーを設定して取得できる事の確認" do
    Eventaskbot::Storage::Driver.set(@mock)
    expect(Eventaskbot::Storage::Driver.get).to eq(@mock)
  end
end
