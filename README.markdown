A small gem for copying OmniAuth information into models

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

The `copies_omniauth' method takes a hash with two keys `:options` and `:attributes`

### Options ###

 * **`:overwrite`** Always overwrite information (default: `true`)
 * **`:token\_attribute`** The attribute on the class used to store OmniAuth's token (default: `:token`)
 * **`:uid\_attribute`** The attribute on an instance used to store OmniAuth's uid (default: `:uid`)
 * **`:provider\_name`** `CopiesOmniauth` will guess the expected OmniAuth provider from the class name by chopping "Provider" off the end of the name.  To override this behavior, set the `:provider\_name` option.

### Attributes ###

The `:attributes` parameter tells `CopiesOmniauth` which attributes to set on an instance and how to find their values in the OmniAuth hash.  Keys of the parameter represent instance attributes and their values represent a path in the OmniAuth hash.  Given the following OmniAuth hash:

    { "provider" => "twitter",
      "uid"      => "10223402",
      "info"     => { "name" => "Dean Brundage",
                      "email" => "dean@deanbrundage.com"
                      "urls" => [ "blog" => "http://blog.deanbrundage.com" ]
                      ....
                    }
     "credentials" => { "token" => "....",
                        ....
                      }
    }

And given a model:

    class TwitterProfile
      attr_accessor :real_name
    end

To copy the "name" attribute into your model's "real_name" attribute:

    copies_omniauth :attributes => { :real_name => ["info", "name"] }

This traverses the OmniAuth hash, sending _info_, then _name_ and stores the value in the model's `real\_name` attribute

# Methods #

## Class Methods ##

`copies\_omniauth` Configuration macro

`new\_from\_omniauth(omniauth\_hash)` Calls `new`, then `copy\_from\_omniauth(omniauth\_hash)`

`create\_from\_omniauth(omniauth\_hash)` Calls `new\_from\_omniauth(omniauth\_hash)` then `save` -- useful for `ActiveRecord` models

## Instance Methods ##

`copy\_from\_omniauth(omniauth\_hash)` Copies values from `omniauth\_hash` into the instance