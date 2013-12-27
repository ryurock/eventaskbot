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

  it "optionメソッド実行時に設定を記載していない状態でoptionをとろうとした場合の結果はnil" do
    expect(Eventaskbot::Api::File.option(:init)).to eq(nil)
  end

  it "optionメソッド実行時に存在しない設定を検索した場合の結果はnil" do
    expect(Eventaskbot::Api::File.option(:hoge)).to eq(nil)
  end

  it "設定が存在する場合は値が取得できる" do
    Eventaskbot::Api::File.configure do |c|
      c.init = @assert
    end
    expect(Eventaskbot::Api::File.option(:init)).to eq(@assert)
  end

  it "resetメソッドで設定した値を消去できる事" do
    Eventaskbot::Api::File.configure do |c|
      c.init = @assert
    end

    Eventaskbot::Api::File.reset
    expect(Eventaskbot::Api::File.options[:init]).to eq(nil)
  end
end
