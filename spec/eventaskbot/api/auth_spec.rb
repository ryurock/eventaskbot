# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/auth'

describe Eventaskbot::Api::Auth, "Eventaskbot Auth API Module" do
  before(:each) do
    Eventaskbot::Api::Auth.reset
    @assert = {:service => [:yammer, :redmine]}
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Api::Auth.class).to eq(Module)
  end

  it "get_oauth_tokenの設定を与えても例外にならないこと" do
    expect{
      Eventaskbot::Api::Auth.configure do |c|
        c.get_oauth_token = @assert
      end
    }.to_not raise_error
  end

  it "get_oauth_tokenの設定を与えた値が取得できること" do

    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = @assert
    end

    expect(Eventaskbot::Api::Auth.options[:get_oauth_token]).to eq(@assert)
  end


end
