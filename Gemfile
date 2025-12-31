# encoding: utf-8

source "https://rubygems.org"


group :development do
  # excludes Windows, Rubinius and JRuby
  gem "ruby-prof", :platforms => [:mri_19, :mri_20, :mri_21]

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
