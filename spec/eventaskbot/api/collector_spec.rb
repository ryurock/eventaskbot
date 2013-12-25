# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/collector'

describe Eventaskbot::Api::Collector, "Eventaskbot Collector API Module" do
  before(:each) do
    Eventaskbot::Api::Collector.reset
    @assert = {:service => [:yammer, :redmine]}
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Api::Collector.class).to eq(Module)
  end

  it "in_groupの設定を与えても例外にならないこと" do
    expect{
      Eventaskbot::Api::Collector.configure do |c|
        c.in_group = {:service => [:yammer, :redmine]}
      end
    }.to_not raise_error
  end

  it "in_groupの設定を与えた値が取得できること" do
    Eventaskbot::Api::Collector.configure do |c|
      c.in_group = @assert
    end

    expect(Eventaskbot::Api::Collector.options[:in_group]).to eq(@assert)
  end

  it "groupの設定を与えても例外にならないこと" do
    expect{
      Eventaskbot::Api::Collector.configure do |c|
        c.group = {:service => [:yammer, :redmine]}
      end
    }.to_not raise_error
  end

  it "groupの設定を与えた値が取得できること" do
    Eventaskbot::Api::Collector.configure do |c|
      c.group = @assert
    end

    expect(Eventaskbot::Api::Collector.options[:group]).to eq(@assert)
  end

  it "usersの設定を与えても例外にならないこと" do
    expect{
      Eventaskbot::Api::Collector.configure do |c|
        c.users = @assert
      end
    }.to_not raise_error
  end

  it "usersの設定を与えた値が取得できること" do
    Eventaskbot::Api::Collector.configure do |c|
      c.users = @assert
    end

    expect(Eventaskbot::Api::Collector.options[:users]).to eq(@assert)
  end

  it "taskの設定を与えても例外にならないこと" do
    expect{
      Eventaskbot::Api::Collector.configure do |c|
        c.task = @assert
      end
    }.to_not raise_error
  end

  it "usersの設定を与えた値が取得できること" do
    Eventaskbot::Api::Collector.configure do |c|
      c.task = @assert
    end

    expect(Eventaskbot::Api::Collector.options[:task]).to eq(@assert)
  end

end
