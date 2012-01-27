class NonstandardInfo
  include CopiesOmniauth
  attr_accessor :ident
  attr_accessor :provider_uid
  attr_accessor :name

  copies_omniauth( :attributes => { :name => %w(info name) },
                   :options => { :provider_name => :irregular,
                                 :token_attribute => :ident,
                                 :uid_attribute => :provider_uid
                               })
end
