# -*- encoding: utf-8 -*-
# stub: ons_openapi 0.1.2 ruby lib vendor

Gem::Specification.new do |s|
  s.name = "ons_openapi".freeze
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze, "vendor".freeze]
  s.authors = ["Rob McKinnon".freeze]
  s.date = "2016-05-20"
  s.description = "Ruby wrapper around the ONS OpenAPI making easy to quickly retrieve data. It may not expose the full functionality of the ONS OpenAPI.".freeze
  s.email = "rob ~@nospam@~ rubyforge.org".freeze
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["LICENSE".freeze, "README.md".freeze, "lib/ons_openapi".freeze, "lib/ons_openapi.rb".freeze, "lib/ons_openapi/classification.rb".freeze, "lib/ons_openapi/collection.rb".freeze, "lib/ons_openapi/concept.rb".freeze, "lib/ons_openapi/connection.rb".freeze, "lib/ons_openapi/context.rb".freeze, "lib/ons_openapi/data_helper.rb".freeze, "lib/ons_openapi/dimension.rb".freeze, "lib/ons_openapi/geographical_hierarchy.rb".freeze, "lib/ons_openapi/item.rb".freeze, "lib/ons_openapi/name_helper.rb".freeze, "lib/ons_openapi/url_helper.rb".freeze, "lib/ons_openapi/value.rb".freeze, "vendor/json-stat.max.js".freeze]
  s.homepage = "https://github.com/robmckinnon/ons-openapi".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--main".freeze, "README.md".freeze]
  s.rubygems_version = "2.6.4".freeze
  s.summary = "Ruby wrapper around the ONS OpenAPI - the UK Office of National Statistics's data API.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<morph>.freeze, [">= 0.4"])
      s.add_runtime_dependency(%q<json>.freeze, [">= 1.8"])
      s.add_runtime_dependency(%q<execjs>.freeze, [">= 2.2"])
      s.add_runtime_dependency(%q<rack>.freeze, [">= 1.5"])
    else
      s.add_dependency(%q<morph>.freeze, [">= 0.4"])
      s.add_dependency(%q<json>.freeze, [">= 1.8"])
      s.add_dependency(%q<execjs>.freeze, [">= 2.2"])
      s.add_dependency(%q<rack>.freeze, [">= 1.5"])
    end
  else
    s.add_dependency(%q<morph>.freeze, [">= 0.4"])
    s.add_dependency(%q<json>.freeze, [">= 1.8"])
    s.add_dependency(%q<execjs>.freeze, [">= 2.2"])
    s.add_dependency(%q<rack>.freeze, [">= 1.5"])
  end
end
