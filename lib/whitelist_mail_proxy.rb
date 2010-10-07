class WhitelistMailProxy

  def initialize(options)
    @delivery_method = options[:delivery_method]
    @regexp = options[:regexp]
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
      raise "cannot send to #{blocked.inspect}"
    else
      delivery_method.deliver!(mail)
    end
  end
  
end
