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

  it "フォーマットオプションを設定した場合に値が反映されている事" do
    argv = ['init', '--format=hash']
    command = Eventaskbot::Command.new
    command.parse(argv)
    expect(command.opts[:format]).to eq('hash')

  end

  it "第一引数がない場合は例外が発生する" do
    argv = ['--format=hash']
    command = Eventaskbot::Command.new
    expect{ command.parse(argv) }.to raise_error
  end

  it "hashフォーマットを指定した場合はoptsメンバー変数にhashが入る" do
    argv = ['hoge', '--format=hash']
    command = Eventaskbot::Command.new
    command.parse(argv)
    expect(command.opts[:format]).to eq("hash")
  end

  it "フォーマットを指定しない場合のデフォルトフォーマットはjson" do
    argv = ['hoge']
    command = Eventaskbot::Command.new
    command.parse(argv)
    expect(command.opts[:format]).to eq("json")
  end

  it "設定値:formatだけを取得する事ができる" do
    argv = ['hoge']
    command = Eventaskbot::Command.new
    command.parse(argv)
    expect(command.get(:format)).to eq("json")
  end

  it "第２引数がない場合のデフォルトの[:api][:params]は空のHash" do
    argv = ['hoge']
    command = Eventaskbot::Command.new
    command.parse(argv)
    expect(command.opts[:api][:params]).to eq({})
  end

  it "第２引数の指定がHashではない場合は例外が発生" do
    argv = ['hoge', "fuga"]
    command = Eventaskbot::Command.new
    expect{ command.parse(argv) }.to raise_error
  end

  it "第２引数の指定がHashの場合はオプションを取得できる" do
    assert = {:hoge => :fuga}
    argv = ['hoge', "#{assert}"]
    command = Eventaskbot::Command.new
    command.parse(argv)
    expect(command.opts[:api][:params]).to eq(assert)
  end

  it "存在しない設定値を設定した場合は例外が発生する" do
    argv = ['hoge']
    command = Eventaskbot::Command.new
    command.parse(argv)
    expect{ command.get(:hoge) }.to raise_error
  end

end
