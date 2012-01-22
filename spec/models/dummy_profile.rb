class DummyProfile
  include CopiesOmniauth
  attr_accessor :name
  attr_accessor :token
  attr_accessor :uid
  copies_omniauth :name => %w(info name)
end
