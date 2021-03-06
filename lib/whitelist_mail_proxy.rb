require 'action_mailer'

class WhitelistMailProxy
  
  class BlockedDelivery < StandardError; end
  class SettingsError < ArgumentError ; end

  def initialize(options)
    @delivery_method = options[:delivery_method]
    @regexp = options[:regexp]
    @domains = options[:domain] && Array(options[:domain])
    
    raise SettingsError, "you must specify config.action_mailer.whitelist_proxy_settings to contain a :delivery_method"   unless @delivery_method
    raise SettingsError, "you must specify config.action_mailer.whitelist_proxy_settings to contain a :regexp or :domain" unless @regexp || @domains
  end
  attr_reader :delivery_method, :regexp, :domains
  
  def deliver!(mail)
    blocked = mail.destinations.select do |destination|
      block_recipient?(destination)
    end
  
    if blocked.any?
      raise BlockedDelivery.new("cannot send to #{blocked.inspect}, whitelist is #{whitelist_description}")
    else
      real_delivery_method.deliver!(mail)
    end
  end
  
  # eg.
  #  "Matthew Rudy Jacobs"<matthewrudyjacobs@gmail.com>
  #  matthewrudyjacobs@gmail.com
  def self.extract_email_address(recipient)
    recipient.split("<").last.gsub(/>$/, "").strip
  end
  
  def self.extract_email_domain(recipient)
    extract_email_address(recipient).split("@").last
  end
  
  def block_recipient?(string)
    block_by_regexp?(string) || block_by_domain?(string)
  end
  
  def whitelist_description
    bits = []
    bits << "addresses LIKE #{regexp.inspect}" if self.regexp
    bits << "domains IN #{domains.inspect}"    if self.domains
  
    bits.join(" OR ")
  end
  
  protected
  
  def block_by_regexp?(string)
    string !~ regexp if self.regexp
  end
  
  def block_by_domain?(string)
    !self.domains.include?(self.class.extract_email_domain(string)) if self.domains
  end
  
  def real_delivery_method
    settings = ActionMailer::Base.send(:"#{self.delivery_method}_settings")
    ActionMailer::Base.delivery_methods[self.delivery_method].new(settings)
  end
  
end
# this is the whole reason we're doing this
ActionMailer::Base.add_delivery_method(:whitelist_proxy, WhitelistMailProxy)
