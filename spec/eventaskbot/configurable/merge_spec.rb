# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/configurable/merge'
require 'eventaskbot/command'

describe Eventaskbot::Configurable::Merge, "Eventaskbot Configurable::Merge Class" do
  before(:each) do
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Configurable::Merge.class).to eq(Module)
  end

  it "コマンドラインのオプションをマージできるか？" do
    argv = ['init', '--format=json']
    command = Eventaskbot::Command.new(argv)
    command.parse
    Eventaskbot::Configurable::Merge.command(command)

    expect(Eventaskbot.options[:api][:name]).to eq("init")
    expect(Eventaskbot.options[:response][:format]).to eq("json")
  end

  it "オプションにキー:config_fileがない場合でも例外が発生しない" do
    opts = { :api => { :name => "fuga" } }
    expect{ Eventaskbot::Configurable::Merge.config_file(opts) }.to_not raise_error
  end

  it "オプションにキー:config_file[:path]がない場合でも例外が発生しない" do
    opts = { :config_file => {}, :api => { :name => "fuga" } }
    expect{ Eventaskbot::Configurable::Merge.config_file(opts) }.to_not raise_error
  end

  it "設定ファイルが存在しない場合は例外が発生する" do
    path = File.expand_path(__FILE__ + '/../EventaskbotFile')
    opts = { :config_file => {:path => path}, :api => { :name => "fuga" } }
    expect{ Eventaskbot::Configurable::Merge.config_file(opts) }.to raise_error
  end

  it "設定ファイルが存在する場合は例外が発生しない" do
    path = File.expand_path(__FILE__ + '/../../../../EventaskbotFile')
    opts = { :config_file => { :path => path } }
    expect{ Eventaskbot::Configurable::Merge.config_file(opts) }.not_to raise_error
  end
end
