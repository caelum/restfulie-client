source :rubygems

gemspec

if RUBY_VERSION < "1.9"
  gem "ruby-debug"
else
  gem "ruby-debug19", :require => "ruby-debug"
end

gem 'rake', '~> 0.9.2'

group :test do  
  gem "rspec", ">= 2.3.0"
	gem "fakeweb"
end  
