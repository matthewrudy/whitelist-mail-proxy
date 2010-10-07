require 'rails'
class WhitelistMailProxy
  class Railtie < Rails::Railtie
    initializer "actionmailer.whitelist" do
      ActionMailer::Base.add_delivery_method(:whitelist_proxy, WhitelistMailProxy) unless ActionMailer::Base.respond_to?(:whitelist_proxy)
    end
  end
end