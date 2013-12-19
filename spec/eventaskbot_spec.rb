require File.expand_path(File.join('./', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'

describe Eventaskbot, "Eventaskbot Base" do
  before(:each) do
  end

  it "モジュールである事の確認" do
    Eventaskbot.class.should == Module
  end
end

