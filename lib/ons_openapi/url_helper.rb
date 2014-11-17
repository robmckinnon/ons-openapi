module OnsOpenApi::UrlHelper

  def url
    require 'cgi'
    if respond_to?(:urls) && urls
      uri = URI.parse urls.urls.detect{|x| x.representation['json'] }.href
      params = Rack::Utils.parse_query(uri.query)
      params.delete('apikey')
      return [uri.path, params]
    end
  end
end
