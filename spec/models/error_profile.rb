class ErrorProfile
  include CopiesOmniauth
  attr_accessor :token
  attr_accessor :uid
  copies_omniauth :attributes => { :invalid_attribute => [] }
end
