require 'copies_omniauth/version'

module CopiesOmniauth

  TOKEN_KEY = ["credentials","token"]
  UID_KEY = "uid"

  class ProviderNameMismatch < RuntimeError; end
  class UidMismatch < RuntimeError; end


  if defined?(Rails) && Rails::VERSION::MAJOR >= 3
    require 'copies_omniauth/railtie'
  end


  def self.included(parent)
    parent.extend ClassMethods
  end


  module ClassMethods

    def copies_omniauth(args={})
      options = self.class_variable_set( :@@copies_omniauth_options,
                                           { :overwrite       => true,
                                             :token_attribute => :token,
                                             :uid_attribute   => :uid
                                           })
      unless args[:options].nil?
        options.merge!(args[:options])
      end

      if options[:provider_name].nil?
        options[:provider_name] = self.name.sub("Profile","").downcase
      end

      attributes = self.class_variable_set( :@@copies_omniauth_attributes,
                                       { options[:token_attribute] => TOKEN_KEY,
                                         options[:uid_attribute]   => UID_KEY
                                       })
      unless args[:attributes].nil?
        attributes.merge!(args[:attributes])
      end

      [ options[:token_attribute], options[:uid_attribute] ].each do |attr|
        attributes.delete(attr) unless instance_has_setter_for?(attr)
      end

      attributes.each do |attr,omniauth_key|
        raise ArgumentError, "Do not know how to set #{attr}" unless instance_has_setter_for?(attr)

        case omniauth_key
        when Array, String, Symbol
        else
          raise ArgumentError, "Don't know how to traverse OmniAuth with #{omniauth_key}"
        end
      end

      include CopiesOmniauth::InstanceMethods
    end


    def create_from_omniauth(omniauth)
      new_from_omniauth(omniauth).save
    end


    def new_from_omniauth(omniauth)
      new().copy_from_omniauth(omniauth)
    end


  private

    def attribute_setter_for?(attr)
      respond_to?(:attribute_method?) && attribute_method?(attr)
    end


    def instance_has_setter_for?(attr)
      attribute_setter_for?(attr) || method_setter_for?(attr)
    end


    def method_setter_for?(attr)
      instance_methods.include?("#{attr}=".to_sym)
    end

  end


  module InstanceMethods

    def copy_from_omniauth(omniauth)

      validate_provider omniauth["provider"]
      validate_uid      omniauth["uid"]

      copies_omniauth_attributes.each do |attr,omniauth_key|

        case omniauth_key
        when Array
        value = omniauth_key.inject(omniauth) do |hash,key|
                                                hash[key] unless hash.nil?
                                              end
        when String
          value = omniauth[omniauth_key]

        when Symbol
          value = omniauth[omniauth_key.to_s]

        end

        if copies_omniauth_options[:overwrite] || send(attr).nil?
          self.send("#{attr}=",value)
        end
      end
      self
    end

  private

    def copies_omniauth_attributes
     self.class.class_variable_get(:@@copies_omniauth_attributes)
    end


    def copies_omniauth_options
     self.class.class_variable_get(:@@copies_omniauth_options)
    end


    def omniauth_uid
      if respond_to?(copies_omniauth_options[:uid_attribute])
        send(copies_omniauth_options[:uid_attribute])
      end
    end


    def validate_provider(provider)
      unless provider == copies_omniauth_options[:provider_name].to_s
        raise ProviderNameMismatch, "OmniAuth (#{provider}) does not represent a #{copies_omniauth_options[:provider_name]} profile."
      end
    end


    def validate_uid(uid)
      if  ! omniauth_uid.nil? && uid != omniauth_uid
        raise UidMismatch, "OmniAuth (#{uid}) does not apply to this #{copies_omniauth_options[:provider_name]} profile (#{omniauth_uid})."
      end
    end

  end

end
