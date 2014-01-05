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

  it "全てのfilterを通過した場合は例外が発生しない" do
    Eventaskbot.configure do |c|
      c.api = {:name => "init"}
      c.response = {:format => "json"}
    end

    expect{ Eventaskbot::Configurable::Filter.filter(Eventaskbot.options) }.to_not raise_error
  end

end
