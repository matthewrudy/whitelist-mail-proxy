class WhitelistMailProxy
  
  class BlockedDelivery < StandardError; end

  def initialize(options)
    @delivery_method = options[:delivery_method]
    @regexp = options[:regexp]
    
    raise "must have :delivery_method" unless @delivery_method
    raise "must have :regexp" unless @regexp
  end
  attr_reader :delivery_method, :regexp
  
  def deliver!(mail)
    blocked = mail.destinations.select do |destination|
      block?(destination)
    end
  
    if blocked.any?
      raise BlockedDelivery.new("cannot send to #{blocked.inspect}, whitelist is #{regexp.inspect}")
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
  
  protected
  
  def block?(string)
    string !~ regexp
  end
  
  def real_delivery_method
    settings = ActionMailer::Base.send(:"#{self.delivery_method}_settings")
    ActionMailer::Base.delivery_methods[self.delivery_method].new(settings)
  end
  
end
