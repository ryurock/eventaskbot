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
    command = Eventaskbot::Command.new
    command.parse(argv)
    Eventaskbot::Configurable::Merge.command_merge(command.opts)
    expect(Eventaskbot.options[:api][:name]).to eq("init")
    expect(Eventaskbot.options[:response][:format]).to eq("json")
  end

  it "設定ファイルが存在しない場合は例外が発生する" do
    #path = File.expand_path(__FILE__ + '/../../../../EventaskbotFile')
    path = File.expand_path(__FILE__ + '/../EventaskbotFile')
    expect{ Eventaskbot::Configurable::Merge.eventaskbotfile_merge(path) }.to raise_error
  end

  it "設定ファイルが存在する場合は例外が発生しない" do
    path = File.expand_path(__FILE__ + '/../../../../EventaskbotFile')
    expect{ Eventaskbot::Configurable::Merge.eventaskbotfile_merge(path) }.not_to raise_error
  end
end
