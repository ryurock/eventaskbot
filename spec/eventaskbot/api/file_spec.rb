# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/file'

describe Eventaskbot::Api::File, "Eventaskbot File API Module" do
  before(:each) do
    Eventaskbot::Api::File.reset
    @assert = {:service => [:yammer, :redmine]}
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Api::File.class).to eq(Module)
  end

  it "initの設定を与えても例外にならないこと" do
    expect{
      Eventaskbot::Api::File.configure do |c|
        c.init = @assert
      end
    }.to_not raise_error
  end

  it "get_oauth_tokenの設定を与えた値が取得できること" do

    Eventaskbot::Api::File.configure do |c|
      c.init = @assert
    end

    expect(Eventaskbot::Api::File.options[:init]).to eq(@assert)
  end


end
