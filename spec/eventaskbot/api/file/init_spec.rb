# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/file/init'

describe Eventaskbot::Api::File::Init, "Eventaskbot File Init API Class" do
  before(:each) do
    Eventaskbot::Api::File.reset
  end

  it "クラスである事の確認" do
    expect(Eventaskbot::Api::File::Init.class).to eq(Class)
  end

end
