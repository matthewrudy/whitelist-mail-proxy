require 'test_helper'
require File.dirname(__FILE__)+"/../lib/whitelist_mail_proxy"

class WhitelistMailProxyTest < ActiveSupport::TestCase
  
  test "extract_email_address - just an email" do
    assert_extracted "murple@murple.com", "murple@murple.com"
  end
  
  test "extract_email_address - with a trailing space" do
    assert_extracted "murple@murple.com", "murple@murple.com  "
  end
  
  test "extract_email_address - with some magic" do
    assert_extracted "murple+somemagic@murple.com", "murple+somemagic@murple.com"
  end
  
  test "extract_email_address - with a quoted name" do
    full = %("Purple Murple" <murple@murple.com>)
    assert_extracted "murple@murple.com", full
  end
  
  test "extract_email_address - with a non-quoted name" do
    full = %(Purple Murple <murple@murple.com>)
    assert_extracted "murple@murple.com", full
  end
  
  test "extract_email_address - without a space between the name and email" do
    full = %("Purple Murple"<murple@murple.com>)
    assert_extracted "murple@murple.com", full
  end
  
  test "extract_email_domain" do
    assert_domain "murple.com", "murple@murple.com"
  end
  
  test "extract_email_domain - with quoted name" do
    full = %("Purple Murple" <murple@murple.com>)
    assert_domain "murple.com", full
  end
  
  test "block_recipient - by regexp" do
    @proxy = WhitelistMailProxy.new(:delivery_method => :test, :regexp => /purple/)
    
    # matching the email address
    assert !@proxy.block_recipient?("purple@murple.com")
    assert  @proxy.block_recipient?("murple@murple.com")
    
    # but also the name
    assert  @proxy.block_recipient?(%("Purple Murple" <murple@murple.com>))
    assert !@proxy.block_recipient?(%("purple Murple" <murple@murple.com>)) # case sensitive
    assert  @proxy.block_recipient?(%("Murple Murple" <murple@murple.com>))
  end
  
  test "block_recipient - by single domain" do
    @proxy = WhitelistMailProxy.new(:delivery_method => :test, :domain => "murple.com")
    
    # matching the domain
    assert !@proxy.block_recipient?("murple@murple.com")
    assert  @proxy.block_recipient?("murple@murpoo.com")
    
    # regardless of name
    assert !@proxy.block_recipient?(%("Purple Murple" <murple@murple.com>))
    assert  @proxy.block_recipient?(%("Purple Murple" <murple@murpoo.com>))
  end
  
  test "block_recipient - multiple domains" do
    @proxy = WhitelistMailProxy.new(:delivery_method => :test, :domain => ["murple.com", "murpoo.com"])
    
    # matching the domain
    assert !@proxy.block_recipient?("murple@murple.com")
    assert !@proxy.block_recipient?("murple@murpoo.com")
    assert  @proxy.block_recipient?("murple@somethingelse.com")
    
    # regardless of name
    assert !@proxy.block_recipient?(%("Purple Murple" <murple@murple.com>))
    assert !@proxy.block_recipient?(%("Purple Murple" <murple@murpoo.com>))
    assert  @proxy.block_recipient?(%("Purple Murple" <murple@somethingelse.com>))
  end
  
  test "raises an exception if not given a delivery method" do
    assert_raise(WhitelistMailProxy::SettingsError) do
      WhitelistMailProxy.new(:domain => ["murple.com", "murpoo.com"])
    end
  end
  
  test "raises an exception if not given a regexp or a domain" do
    assert_raise(WhitelistMailProxy::SettingsError) do
      WhitelistMailProxy.new(:delivery_method => :test)
    end
    assert WhitelistMailProxy.new(:delivery_method => :test, :regexp => /something/)
    assert WhitelistMailProxy.new(:delivery_method => :test, :domain => ["something"])
    assert WhitelistMailProxy.new(:delivery_method => :test, :domain => []) # it doesnt care if its empty
  end
  
  def assert_extracted(extracted, full)
    assert_equal extracted, WhitelistMailProxy.extract_email_address(full)
  end
  
  def assert_domain(domain, full)
    assert_equal domain, WhitelistMailProxy.extract_email_domain(full)
  end
  
end
