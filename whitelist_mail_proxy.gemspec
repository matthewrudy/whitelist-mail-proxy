# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{whitelist_mail_proxy}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Rudy Jacobs"]
  s.date = %q{2011-02-21}
  s.email = %q{MatthewRudyJacobs@gmail.com}
  s.extra_rdoc_files = ["README"]
  s.files = ["MIT-LICENSE", "Rakefile", "README", "test/test_helper.rb", "test/whitelist_mail_proxy_test.rb", "lib/whitelist_mail_proxy.rb"]
  s.homepage = %q{http://github.com/matthewrudy/whitelist-mail-proxy}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{A thin proxy for Mail and ActionMailer to enable whitelisting}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionmailer>, [">= 0"])
    else
      s.add_dependency(%q<actionmailer>, [">= 0"])
    end
  else
    s.add_dependency(%q<actionmailer>, [">= 0"])
  end
end
