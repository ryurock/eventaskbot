# -*- coding: utf-8 -*-

require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/handler'

describe Eventaskbot::Handler, "Eventaskbot Handler Module" do
  before(:each) do
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Handler.class).to eq(Module)
  end

  it "runを" do
    Eventaskbot.configure do |c|
      c.api = {:name => :init}
      c.response = {:format => "json"}
    end

    Eventaskbot.run
  end
end
