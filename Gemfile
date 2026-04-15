# encoding: utf-8

source "https://rubygems.org"


group :development do
  gem "ruby-prof", platforms: :mri

  gem "rake"
end

group :benchmark do
  gem "benchmark-ips", "~> 2.12"
  gem "benchmark-memory", "~> 0.2"
end

group :test do
  gem "rspec", ">= 3.8.0"
  gem "rspec-its"
  gem "simplecov"
  gem 'bigdecimal'
end

group :development, :test do
  gem "byebug"
end
