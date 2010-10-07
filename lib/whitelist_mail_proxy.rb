class WhitelistMailProxy

  def initialize(options)
    @delivery_method = options[:delivery_method]
    @regexp = options[:regexp]
    
    raise "must have :delivery_method" unless @delivery_method
    raise "must have :regexp" unless @regexp
  end
  attr_reader :delivery_method, :regexp

  def block?(string)
    string !~ regexp
  end
  
  def deliver!(mail)
    blocked = mail.destinations.select do |destination|
      block?(destination)
    end
  
    if blocked.any?
      raise "cannot send to #{blocked.inspect}, whitelist is #{regexp.inspect}"
    else
      delivery_method.deliver!(mail)
    end
  end
  
end

if defined?(Rails)
  require 'whitelist_mail_proxy/railtie'
end
