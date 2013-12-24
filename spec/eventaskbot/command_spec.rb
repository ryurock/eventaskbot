# -*- coding: utf-8 -*-

require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/command'

describe Eventaskbot::Command, "Eventaskbot Command Module" do
  before(:each) do
    @command = "
      Eventaskbot::Command.new
    "
  end

  it "モジュールである事の確認" do
    expect(Eventaskbot::Command.class).to eq(Class)
  end

  it "ヘルプが表示される事の確認" do
    path = File.expand_path('../test_command.rb', File.dirname(__FILE__))
    command = `ruby #{path} -h`
    expect(command).to match /^eventaskbot argument/
    command = `ruby #{path} --help`
    expect(command).to match /^eventaskbot argument/
  end

  it "フォーマットオプションで許容しないフォーマットの場合は例外が発生" do
    ARGV << '--format=fuga'
    command = Eventaskbot::Command.new
    expect{ command.merge }.to raise_error
  end

  it "フォーマットオプションがjsonの場合は例外が発生しない" do
    ARGV << 'hoge'
    ARGV << '--format=json'
    command = Eventaskbot::Command.new
    expect{ command.merge }.not_to raise_error
  end

  it "フォーマットオプションがtextの場合は例外が発生しない" do
    ARGV << 'hoge'
    ARGV << '--format=text'
    command = Eventaskbot::Command.new
    expect{ command.merge }.not_to raise_error
  end

  it "フォーマットオプションがhashの場合は例外が発生しない" do
    ARGV << 'hoge'
    ARGV << '--format=hash'
    command = Eventaskbot::Command.new
    expect{ command.merge }.not_to raise_error
  end

  it "第一引数がない場合は例外が発生する" do
    ARGV << '--format=hash'
    command = Eventaskbot::Command.new
    expect{ command.merge }.to raise_error
  end

  it "hashフォーマットを指定した場合はoptsメンバー変数にhashが入る" do
    ARGV << 'hoge'
    ARGV << '--format=hash'
    command = Eventaskbot::Command.new
    command.merge
    expect(command.opts[:format]).to eq("hash")
  end

  it "jsonフォーマットを指定した場合はoptsメンバー変数にjsonが入る" do
    ARGV << 'hoge'
    ARGV << '--format=json'
    command = Eventaskbot::Command.new
    command.merge
    expect(command.opts[:format]).to eq("json")
  end

  it "textフォーマットを指定した場合はoptsメンバー変数にtextが入る" do
    ARGV << 'hoge'
    ARGV << '--format=text'
    command = Eventaskbot::Command.new
    command.merge
    expect(command.opts[:format]).to eq("text")
  end

  it "フォーマットを指定しない場合のデフォルトフォーマットはjson" do
    ARGV << 'hoge'
    command = Eventaskbot::Command.new
    command.merge
    expect(command.opts[:format]).to eq("json")
  end

  it "設定値:formatだけを取得する事ができる" do
    ARGV << 'hoge'
    command = Eventaskbot::Command.new
    command.merge
    expect(command.get(:format)).to eq("json")
  end

  it "存在しない設定値を設定した場合は例外が発生する" do
    ARGV << 'hoge'
    command = Eventaskbot::Command.new
    command.merge
    expect{ command.get(:hoge) }.to raise_error
  end

end
