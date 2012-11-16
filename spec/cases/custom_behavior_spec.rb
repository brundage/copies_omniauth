require 'spec_helper'

describe CopiesOmniauth, 'custom behavior' do

  it "copies the uid by default" do
    profile = NonstandardInfo.new
    profile.provider_uid.should be_nil
    profile.copy_from_omniauth OMNIAUTHS[:irregular]
    profile.provider_uid.should_not be_nil
    profile.provider_uid.should eq OMNIAUTHS[:irregular]["uid"]
  end


  it "copies the token by default" do
    profile = NonstandardInfo.new
    profile.ident.should be_nil
    profile.copy_from_omniauth OMNIAUTHS[:irregular]
    profile.ident.should_not be_nil
    profile.ident.should eq OMNIAUTHS[:irregular]["credentials"]["token"]
  end


  it "copies omniauth values requested" do
    profile = NonstandardInfo.new
    profile.name.should be_nil
    profile.copy_from_omniauth OMNIAUTHS[:irregular]
    profile.name.should_not be_nil
    profile.name.should eq OMNIAUTHS[:irregular]["info"]["name"]
  end

end
