# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/services/yammer'

describe Eventaskbot::Services::Yammer, "Eventaskbot Services Yammer Module" do
  before(:each) do
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Services::Yammer.class).to eq(Module)
  end

  it "Yammerのホストが返ってくる事" do
    expect(Eventaskbot::Services::Yammer.host).to eq('https://www.yammer.com')
  end
end
