# -*- coding: utf-8 -*-

require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/command'

describe Eventaskbot::Command, "Eventaskbot Command Module" do
  before(:each) do
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Command.class).to eq(Class)
  end

end
