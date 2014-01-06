# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/auth'
require 'eventaskbot/configurable/filter/service'

describe Eventaskbot::Configurable::Filter::Service, "Eventaskbot configurable filter to service Module" do
  before(:each) do
    Eventaskbot.reset
    Eventaskbot::Api::Auth.reset
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Configurable::Filter::Service.class).to eq(Module)
  end
end
