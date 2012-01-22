require 'copies_omniauth'
require 'rails'
module CopiesOmniauth
  class Railtie < Rails::Railtie

    initializer "active_record.copies_omniauth" do |app|
      ActiveSupport.on_load :active_record do
        include CopiesOmniauth
      end
    end

  end
end
