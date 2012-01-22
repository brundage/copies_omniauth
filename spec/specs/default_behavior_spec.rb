require 'spec_helper'

describe CopiesOmniauth, 'default behavior' do

  it "copies the uid by default" do
    profile = DummyProfile.new
    profile.uid.should be_nil
    profile.copy_from_omniauth OMNIAUTHS[:dummy]
    profile.uid.should_not be_nil
    profile.uid.should eq OMNIAUTHS[:dummy]["uid"]
  end


  it "copies the token by default" do
    profile = DummyProfile.new
    profile.token.should be_nil
    profile.copy_from_omniauth OMNIAUTHS[:dummy]
    profile.token.should_not be_nil
    profile.token.should eq OMNIAUTHS[:dummy]["credentials"]["token"]
  end


  it "copies omniauth values requested" do
    profile = DummyProfile.new
    profile.name.should be_nil
    profile.copy_from_omniauth OMNIAUTHS[:dummy]
    profile.name.should_not be_nil
    profile.name.should eq OMNIAUTHS[:dummy]["info"]["name"]
  end

end
