require 'test_helper'
require File.dirname(__FILE__)+"/../lib/whitelist_mail_proxy"

class WhitelistMailProxyTest < ActiveSupport::TestCase
  
  test "extract_email_address - just an email" do
    assert_extracted "matthew@thought-sauce.com", "matthew@thought-sauce.com"
  end
  
  test "extract_email_address - with a trailing space" do
    assert_extracted "matthew@thought-sauce.com", "matthew@thought-sauce.com  "
  end
  
  test "extract_email_address - with some magic" do
    assert_extracted "matthewRudyJacobs+somemagic@gmail.com", "matthewRudyJacobs+somemagic@gmail.com"
  end
  
  test "extract_email_address - with a quoted name" do
    full = %("Hyatt, Matthew" <MatthewHyatt@computerpeople.co.uk>)
    assert_extracted "MatthewHyatt@computerpeople.co.uk", full
  end
  
  test "extract_email_address - with a non-quoted name" do
    full = %(Hyatt, Matthew <MatthewHyatt@computerpeople.co.uk>)
    assert_extracted "MatthewHyatt@computerpeople.co.uk", full
  end
  
  test "extract_email_address - without a space between the name and email" do
    full = %("Hyatt, Matthew"<MatthewHyatt@computerpeople.co.uk>)
    assert_extracted "MatthewHyatt@computerpeople.co.uk", full
  end
  
  def assert_extracted(extracted, full)
    assert_equal extracted, WhitelistMailProxy.extract_email_address(full)
  end
  
end
