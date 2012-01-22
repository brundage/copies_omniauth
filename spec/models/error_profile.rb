class ErrorProfile
  include CopiesOmniauth
  attr_accessor :token
  attr_accessor :uid
  copies_omniauth :invalid_attribute => { }
end
