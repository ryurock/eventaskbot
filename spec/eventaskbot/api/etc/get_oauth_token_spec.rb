# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/etc/get_oauth_token'

describe Eventaskbot::Api::Etc::GetOauthToken, "Eventaskbot Etc get-oauth-token API Class" do
  before(:each) do
  end

  it "クラスである事の確認" do
    expect(Eventaskbot::Api::Etc::GetOauthToken.class).to eq(Class)
  end

end
