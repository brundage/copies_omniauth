![OmniAuth Image](http://blog.deanbrundage.com/wp-content/uploads/2012/01/copies_omniauth.png)

A small gem for copying [OmniAuth](https://github.com/intridea/omniauth "OmniAuth") information into models

[![Build Status](https://secure.travis-ci.org/brundage/copies_omniauth.png)](http://travis-ci.org/brundage/copies_omniauth)
[![Dependency Status](https://gemnasium.com/brundage/copies_omniauth.png)](https://gemnasium.com/brundage/copies_omniauth)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/brundage/copies_omniauth)
[![Buggerall](https://buggerall.herokuapp.com/bug/copies_omniauth.png)](https://github.com/brundage/buggerall)



# Usage #

    class FacebookProfile
      include CopiesOmniauth

      attr_accessor :email
      attr_accessor :first_name
      attr_accessor :last_name
      attr_accessor :token
      attr_accessor :uid
    
      copies_omniauth :attributes => { :email => %w(info email),
                                       :first_name => %w(info first_name),
                                       :last_name => %w(info last_name)
                                     }
    end
    
    f = FacebookProfile.new_from_omniauth(omniauth)

## Arguments ##

The `copies_omniauth` method takes a hash with two keys `:options` and `:attributes`

### Options ###

 * `:overwrite` Always overwrite information (default: *true*)
 * `:secret_attribute` The attribute on the class used to store OmniAuth's secret (default: *:secret*)
 * `:skip_provider_check` Do not verify the OmniAuth provider matches the model (default: *false*)
 * `:token_attribute` The attribute on the class used to store OmniAuth's token (default: *:token*)
 * `:uid_attribute` The attribute on an instance used to store OmniAuth's uid (default: *:uid*)
 * `:provider_name` CopiesOmniauth will guess the expected OmniAuth provider from the class name by chopping "Provider" off the end of the name.  To override this behavior, set the `:provider_name` option.

### Attributes ###

**Copies OmniAuth always copies `secret`, `token`, and `uid` if setters are present on the model.**

The `:attributes` parameter tells CopiesOmniauth which attributes to set on an instance and how to find their values in the OmniAuth hash.  Keys of the parameter represent instance attributes and their values represent a path in the OmniAuth hash.  Given the following OmniAuth hash:

    { "provider" => "twitter",
      "uid"      => "10223402",
      "info"     => { "name" => "Dean Brundage",
                      "email" => "dean@deanbrundage.com",
                      "nickname" => "brundage",
                      "urls" => [ "blog" => "http://blog.deanbrundage.com" ]
                      ....
                    }
     "credentials" => { "token" => "....",
                        "secret" => "....",
                        ....
                      }
    }

And given a model:

    class TwitterProfile
      attr_accessor :real_name
    end

To copy the "name" attribute into your model's "real_name" attribute:

    copies_omniauth :attributes => { :real_name => ["info", "name"] }

This traverses the OmniAuth hash, sending _info_, then _name_ and stores the value in the model's `real_name` attribute

# Methods #

## Class Methods ##

`copies_omniauth` Configuration macro

`new_from_omniauth(omniauth_hash)` Calls `new`, then `copy_from_omniauth(omniauth_hash)`

`create_from_omniauth(omniauth_hash)` Calls `new_from_omniauth(omniauth_hash)` then `save` -- useful for `ActiveRecord` models

## Instance Methods ##

`copy_from_omniauth(omniauth_hash)` Copies values from `omniauth_hash` into the instance
