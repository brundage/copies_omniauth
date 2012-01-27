require 'spec_helper'

describe CopiesOmniauth, 'default behavior' do

  it "copies the uid by default" do
    profile = DummyProfile.new
    profile.uid.should be_nil
    profile.copy_from_omniauth OMNIAUTHS[:dummy]
    profile.uid.should_not be_nil
    profile.uid.should eq OMNIAUTHS[:dummy]["uid"]
  end


  it "does not try to copy the uid if the class doesn't have one" do
    profile = NodefaultsProfile.new
    profile.should_not respond_to(:uid)
    expect {
      profile.copy_from_omniauth OMNIAUTHS[:nodefaults]
    }.not_to raise_error
  end


  it "copies the token by default" do
    profile = DummyProfile.new
    profile.token.should be_nil
    profile.copy_from_omniauth OMNIAUTHS[:dummy]
    profile.token.should_not be_nil
    profile.token.should eq OMNIAUTHS[:dummy]["credentials"]["token"]
  end


  it "does not try to copy the token if the class doesn't have one" do
    profile = NodefaultsProfile.new
    profile.should_not respond_to(:token)
    expect {
      profile.copy_from_omniauth OMNIAUTHS[:nodefaults]
    }.not_to raise_error
  end


  it "copies omniauth values requested" do
    profile = DummyProfile.new
    profile.name.should be_nil
    profile.copy_from_omniauth OMNIAUTHS[:dummy]
    profile.name.should_not be_nil
    profile.name.should eq OMNIAUTHS[:dummy]["info"]["name"]
  end


  it "doesn't overwrite values when configured not to" do
    name = "Blark"
    name.should_not eq OMNIAUTHS[:dummy]["info"]["name"]
    class DummyProfile
      copies_omniauth(:attributes => {:name => %w(info name)},
                      :options => {:overwrite => false})
    end
    profile = DummyProfile.new
    profile.name = name
    profile.copy_from_omniauth OMNIAUTHS[:dummy]
    profile.name.should eq name
  end

end
