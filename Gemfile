# encoding: utf-8

# Use local clones if possible.
# If you want to use your local copy, just symlink it to vendor.
extend Module.new {
  def gem(name, options = Hash.new)
    local_path = File.expand_path("../vendor/#{name}", __FILE__)
    if File.exist?(local_path)
      super name, options.merge(:path => local_path).delete_if { |key, _| [:git, :branch].include?(key) }
    else
      super name, options
    end
  end
}

source :rubygems

group(:development) do
  gem "nake",         :platform => :mri_19
  gem "contributors", :platform => :mri_19
  gem "amq-client"

  # excludes Windows, Rubinius and JRuby
  gem "perftools.rb", :platform => :mri_18
end

group(:test) do
  gem "rspec", "~> 2.6.0"
  gem "rake",  "~> 0.9.2"

  gem "simplecov", :platform => :mri_19
end
