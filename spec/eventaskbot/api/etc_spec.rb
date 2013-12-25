# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/etc'

describe Eventaskbot::Api::Etc, "Eventaskbot Etc API Module" do
  before(:each) do
    Eventaskbot::Api::Etc.reset
    @assert = {:service => [:yammer, :redmine]}
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Api::Etc.class).to eq(Module)
  end

  it "initの設定を与えても例外にならないこと" do
    expect{
      Eventaskbot::Api::Etc.configure do |c|
        c.init = @assert
      end
    }.to_not raise_error
  end

  it "initの設定を与えた値が取得できること" do

    Eventaskbot::Api::Etc.configure do |c|
      c.init = @assert
    end

    expect(Eventaskbot::Api::Etc.options[:init]).to eq(@assert)
  end


end
