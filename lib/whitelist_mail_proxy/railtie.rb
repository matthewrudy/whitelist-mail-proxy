require 'rails'
class WhitelistMailProxy
  class Railtie < Rails::Railtie
    initializer "actionmailer.whitelist" do
      ActionMailer::Base.add_delivery_method(:whitelist_proxy, WhitelistMailProxy)
    end
  end
end