lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "direct_admin/version"

Gem::Specification.new do |spec|
  spec.name           = "direct_admin"
  spec.version        = DirectAdmin::VERSION
  spec.authors        = ["Adam Daniels"]
  spec.email          = "adam@mediadrive.ca"

  spec.summary        = %q(Unofficial API for DirectAdmin)
  spec.description    = <<~EOM
  An unofficial (and very incomplete) API client for the DirectAdmin webhosting
  control panel.
  EOM

  spec.homepage       = "https://github.com/adam12/direct_admin"
  spec.license        = "MIT"

  spec.files          = ["README.md"] + Dir["lib/**/*.rb"]
  spec.require_paths  = ["lib"]

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rubygems-tasks", "~> 0.2"
end
