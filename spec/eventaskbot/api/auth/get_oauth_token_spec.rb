# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/auth/get_oauth_token'

describe Eventaskbot::Api::Auth::GetOauthToken, "Eventaskbot Auth get-oauth-token API Class" do
  before(:each) do
  end

  it "クラスである事の確認" do
    expect(Eventaskbot::Api::Auth::GetOauthToken.class).to eq(Class)
  end

end
