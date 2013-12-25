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

  it "フォーマットオプションをマージできるか？" do
    ARGV << 'init'
    ARGV << '--format=json'
    command = Eventaskbot::Command.new
    command.parse
    Eventaskbot::Configurable::Merge.command_merge(command.opts)

  end

end
