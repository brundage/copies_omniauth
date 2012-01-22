class NonstandardInfo
  include CopiesOmniauth
  attr_accessor :ident
  attr_accessor :provider_uid
  attr_accessor :name

  copies_omniauth( { :name => %w(info name) },
                   { :provider_name => :irregular,
                     :token_column => :ident,
                     :uid_column => :provider_uid
                   })
end
