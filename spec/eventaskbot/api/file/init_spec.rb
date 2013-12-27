# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/file/init'

describe Eventaskbot::Api::File::Init, "Eventaskbot File Init API Class" do
  before(:each) do
    Eventaskbot::Api::File.reset
    @dest =  File.expand_path('../../../../EventaskbotFile', __FILE__)
    @src  =  File.expand_path('../../../../../EventaskbotFile', __FILE__)
    FileUtils.rm @dest if File.exist?(@dest)
  end

  after(:each) do
    FileUtils.rm @dest if File.exist?(@dest)
  end

  it "クラスである事の確認" do
    expect(Eventaskbot::Api::File::Init.class).to eq(Class)
  end

  it "ファイルが存在している場合のレスポンスステータスは:fail" do
    init = Eventaskbot::Api::File::Init.new
    res  = init.execute({})
    expect(res[:status]).to eq(:fail)
  end

  it "ファイルを強制上書きオプションを設定で渡した場合はファイルを上書きする" do
    Eventaskbot::Api::File.configure do |c|
      c.init = { :force => true }
    end
    init = Eventaskbot::Api::File::Init.new
    FileUtils.cp @src, @dest
    res  = init.execute({ :dest => @dest })
    expect(res[:status]).to eq(:ok)
  end

  it "ファイルを強制上書きオプションをパラメータで渡した場合はファイルを上書きする" do
    init = Eventaskbot::Api::File::Init.new
    FileUtils.cp @src, @dest
    res  = init.execute({:force => true, :dest => @dest})
    expect(res[:status]).to eq(:ok)
  end

  it "ファイルが存在しない場合のステータスは:ok" do
    init = Eventaskbot::Api::File::Init.new
    res  = init.execute({ :dest => @dest })
    expect(res[:status]).to eq(:ok)
  end
end
