require 'spec_helper'

describe CopiesOmniauth, 'exceptions' do

  it "raises an error when the omniauth information does not represent the class" do
    profile = DummyProfile.new
    expect {
      profile.copy_from_omniauth(OMNIAUTHS[:irregular])
    }.to raise_error(CopiesOmniauth::ProviderNameMismatch)
  end


  it "raises an error if the omniauth uid does not match the model's uid" do
    profile = DummyProfile.new
    profile.uid = 2
    profile.uid.should_not eq OMNIAUTHS[:dummy]["uid"]
    expect {
      profile.copy_from_omniauth(OMNIAUTHS[:dummy])
    }.to raise_error(CopiesOmniauth::UidMismatch)
  end


  it "raises an error when the class doesn't have a setter for an attribute" do
    expect {
      class ErrorProfile
        include CopiesOmniauth
        copies_omniauth :attributes => { :no_setter_for_this => :p }
      end
    }.to raise_error(ArgumentError)
  end


  it "raises an error when given bad attribute traversal" do
    expect {
      class ErrorProfile
        include CopiesOmniauth
        copies_omniauth :attributes => { :bad_girl => {} }
      end
    }.to raise_error(ArgumentError)
  end

end
