# -*- encoding: utf-8 -*-
# stub: ons_openapi 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ons_openapi"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Rob McKinnon"]
  s.date = "2014-11-17"
  s.description = "Ruby wrapper around the ONS OpenAPI making easy to quickly retrieve data. It may not expose the full functionality of the ONS OpenAPI."
  s.email = "rob ~@nospam@~ rubyforge.org"
  s.extra_rdoc_files = ["README.md"]
  s.files = ["LICENSE", "README.md", "lib/ons_openapi", "lib/ons_openapi.rb", "lib/ons_openapi/classification.rb", "lib/ons_openapi/collection.rb", "lib/ons_openapi/concept.rb", "lib/ons_openapi/connection.rb", "lib/ons_openapi/context.rb", "lib/ons_openapi/data_helper.rb", "lib/ons_openapi/dimension.rb", "lib/ons_openapi/geographical_hierarchy.rb", "lib/ons_openapi/item.rb", "lib/ons_openapi/name_helper.rb", "lib/ons_openapi/url_helper.rb", "lib/ons_openapi/value.rb", "vendor/json-stat.max.js"]
  s.homepage = "https://github.com/robmckinnon/ons-openapi"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.md"]
  s.rubygems_version = "2.2.2"
  s.summary = "Ruby wrapper around the ONS OpenAPI - the UK Office of National Statistics's data API."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<morph>, ["~> 0.3"])
      s.add_runtime_dependency(%q<json>, ["~> 1.8"])
      s.add_runtime_dependency(%q<execjs>, ["~> 2.2"])
      s.add_runtime_dependency(%q<rack>, ["~> 1.5"])
    else
      s.add_dependency(%q<morph>, ["~> 0.3"])
      s.add_dependency(%q<json>, ["~> 1.8"])
      s.add_dependency(%q<execjs>, ["~> 2.2"])
      s.add_dependency(%q<rack>, ["~> 1.5"])
    end
  else
    s.add_dependency(%q<morph>, ["~> 0.3"])
    s.add_dependency(%q<json>, ["~> 1.8"])
    s.add_dependency(%q<execjs>, ["~> 2.2"])
    s.add_dependency(%q<rack>, ["~> 1.5"])
  end
end
