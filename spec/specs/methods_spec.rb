require 'spec_helper'

describe CopiesOmniauth, 'methods' do

  it "adds methods to a plain class" do
    DummyProfile.should respond_to(:copies_omniauth)
  end


  it "adds instance methods to a plain class" do
    DummyProfile.new.should respond_to(:copy_from_omniauth)
  end


  it "adds methods to ActiveRecord" do
    ActiveRecord::Base.should respond_to(:copies_omniauth)
  end


  it "adds instance methods to ActiveRecord" do
    ActiveRecordProfile.new.should respond_to(:copy_from_omniauth)
  end

end
