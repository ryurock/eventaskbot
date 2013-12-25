# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/etc/init'

describe Eventaskbot::Api::Etc::Init, "Eventaskbot Etc Init API Class" do
  before(:each) do
  end

  it "クラスである事の確認" do
    expect(Eventaskbot::Api::Etc::Init.class).to eq(Class)
  end

end
