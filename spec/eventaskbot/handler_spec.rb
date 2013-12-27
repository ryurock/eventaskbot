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

  it "commandオプションを指定しない場合は設定が変更されない" do
    Eventaskbot.configure do |c|
      c.api = {:name => :init}
      c.response = {:format => "json"}
    end

    Eventaskbot.run
    expect(Eventaskbot.options[:api][:name]).to eq("init")
  end

  it "commandオプションを指定した場合は値が変更される" do
    assert = 'get-oauth-token'
    Eventaskbot.configure do |c|
      c.api = {:name => :init}
      c.response = {:format => "json"}
    end

    argv = [assert]
    command = Eventaskbot::Command.new(argv)
    command.parse
    Eventaskbot.run({ :command => command})
    expect(Eventaskbot.options[:api][:name]).to eq(assert)
  end
end
