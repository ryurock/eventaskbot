# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/user'

describe Eventaskbot::Api::User, "Eventaskbot Auth API Module" do
  before(:each) do
    Eventaskbot::Api::User.reset
    Eventaskbot.reset
    @assert = { :service => { :yammer => {}, :redmine => {} } }
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Api::User.class).to eq(Module)
  end

  it "user_importの設定を与えても例外にならないこと" do
    expect{
      Eventaskbot::Api::User.configure do |c|
        c.user_import = @assert
      end
    }.to_not raise_error
  end

  it "user_importの設定を与えた値が取得できること" do
    Eventaskbot::Api::User.configure do |c|
      c.user_import = @assert
    end
    expect(Eventaskbot::Api::User.options[:user_import]).to eq(@assert)
  end

  it "設定が存在する場合は値が取得できる" do
    Eventaskbot::Api::User.configure do |c|
      c.user_import = @assert
    end
    expect(Eventaskbot::Api::User.option(:user_import)).to eq(@assert)
  end


end
