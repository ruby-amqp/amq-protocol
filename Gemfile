# encoding: utf-8

source "http://gemcutter.org"

group(:development) do
  gem "nake",         :platform => :ruby_19
  gem "contributors", :platform => :ruby_19

  # excludes Windows and JRuby
  gem "perftools.rb", :platform => :ruby
end

group(:test) do
  gem "rspec", ">=2.0.0"
  gem 'simplecov', :platform => :ruby_19
end
