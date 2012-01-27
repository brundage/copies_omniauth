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

    def copies_omniauth(args={})
      opts = self.class_variable_set( :@@copies_omniauth_options,
                                      { :overwrite    => true,
                                        :token_attribute => :token,
                                        :uid_attribute   => :uid
                                      })
      unless args[:options].nil?
        opts.merge!(args[:options])
      end

      if opts[:provider_name].nil?
        opts[:provider_name] = self.name.sub("Profile","").downcase
      end

      attrs = self.class_variable_set( :@@copies_omniauth_attributes,
                             { opts[:token_attribute] => COPIES_OMNIAUTH_TOKEN_KEY,
                               opts[:uid_attribute]   => COPIES_OMNIAUTH_UID_KEY
                             })
      unless args[:attributes].nil?
        attrs.merge!(args[:attributes])
      end

      [ opts[:token_attribute], opts[:uid_attribute] ].each do |attr|
        attrs.delete(attr) unless self.instance_methods.include?("#{attr}=".to_sym)
      end

      include CopiesOmniauth::InstanceMethods
    end

  end


  module InstanceMethods

    def copy_from_omniauth(omniauth)
      opts = self.class.class_variable_get(:@@copies_omniauth_options)

      if omniauth["provider"] != opts[:provider_name].to_s
        raise ClassNameMismatch, "OmniAuth does not represent a #{opts[:provider_name]} profile."
      end

      if respond_to?(opts[:uid_attribute]) &&
           send(opts[:uid_attribute]).present? &&
           omniauth["uid"] != send(opts[:uid_attribute])
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
        unless methods.include?("#{attr}=".to_sym)
          raise ArgumentError, "Can't copy #{attr}"
        end
        if opts[:overwrite] || send(attr).nil?
          self.send("#{attr}=",value)
        end
      end
      self
    end
    alias_method :update_from_omniauth, :copy_from_omniauth

  end

end
