# coding:utf-8
require 'net/http'
require 'net/https'
require 'uri'

# begin
  # # require 'active_support' # new gem name
  # require 'active_support/core_ext/time'
  # require 'active_support/core_ext/date'
  # require 'active_support/core_ext/enumerable'
  # require 'active_support/core_ext/hash'
  # require 'active_support/core_ext/kernel'
  # require 'active_support/deprecation'
# rescue Exception => e
  # puts "exception requiring active_support: " + e.to_s
  # require 'activesupport' # fallback to old gem name
# end

require 'morph'
require 'yaml'

require 'json'
require 'csv'
require 'rack/utils'
# require 'v8'
require 'execjs'
require 'open-uri'

# See README for usage documentation.
module OnsOpenApi

  VERSION = "0.1.0" unless defined? OnsOpenApi::VERSION

  class << self

    # Returns ONS dataset contexts
    def contexts
      Context.all
    end

    # Returns ONS dataset context with given name
    def context name
      contexts.detect{|c| c.name == name}
    end

    # Returns names of ONS dataset contexts
    def context_names
      contexts.map(&:name)
    end

  end
end

require File.dirname(__FILE__) + '/ons_openapi/connection'
require File.dirname(__FILE__) + '/ons_openapi/url_helper'
require File.dirname(__FILE__) + '/ons_openapi/name_helper'
require File.dirname(__FILE__) + '/ons_openapi/data_helper'
require File.dirname(__FILE__) + '/ons_openapi/context'
require File.dirname(__FILE__) + '/ons_openapi/collection'
require File.dirname(__FILE__) + '/ons_openapi/concept'
require File.dirname(__FILE__) + '/ons_openapi/dimension'
require File.dirname(__FILE__) + '/ons_openapi/value'
require File.dirname(__FILE__) + '/ons_openapi/geographical_hierarchy'
require File.dirname(__FILE__) + '/ons_openapi/item'

