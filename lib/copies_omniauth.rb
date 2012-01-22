require 'copies_omniauth/version'

module CopiesOmniauth

  COPIES_OMNIAUTH_TOKEN_KEY = ["credentials","token"]
  COPIES_OMNIAUTH_UID_KEY = "uid"

  class ClassNameMismatch < RuntimeError; end
  class UidMismatch < RuntimeError; end


  def self.included(parent)
    parent.extend ClassMethods
  end


  if defined?(Rails) && Rails::VERSION::MAJOR >= 3
    require 'copies_omniauth/railtie'
  end


  module ClassMethods

    def copies_omniauth(attributes={},options={})
      opts = self.class_variable_set( :@@copies_omniauth_options,
                                      { :overwrite => true,
                                        :token_column => :token,
                                        :uid_column => :uid
                                      })
      opts.merge!(options)

      unless options[:provider_name].present?
        opts[:provider_name] = self.name.sub("Profile","").downcase
      end

      attrs = self.class_variable_set( :@@copies_omniauth_attributes,
                             { opts[:token_column] => COPIES_OMNIAUTH_TOKEN_KEY,
                               opts[:uid_column]   => COPIES_OMNIAUTH_UID_KEY
                             })
      attrs.merge!(attributes)


      include CopiesOmniauth::InstanceMethods
    end

  end

  module InstanceMethods

    def copy_from_omniauth(omniauth)
      opts = self.class.class_variable_get(:@@copies_omniauth_options)

      if omniauth["provider"] != opts[:provider_name].to_s
        raise ClassNameMismatch, "OmniAuth does not represent a #{opts[:provider_name]} profile."
      end

      if send(opts[:uid_column]).present? &&
           omniauth["uid"] != send(opts[:uid_column])
        raise UidMismatch, "OmniAuth does not apply to this #{opts[:provider_name]} profile."
      end

      self.class.class_variable_get(:@@copies_omniauth_attributes).each do |attr,omniauth_key|
        case omniauth_key
        when Array
        value = omniauth_key.inject(omniauth) { |hash,key| hash.try(:[], key) }
        when String
          value = omniauth[omniauth_key]
        else
          raise ArgumentError, "Don't know what to do with a #{omniauth_key.class}"
        end
        self.send("#{attr}=",value)
      end

    end
    alias_method :update_from_omniauth, :copy_from_omniauth

  end

end
