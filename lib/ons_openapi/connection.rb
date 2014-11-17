require 'net/https'

module OnsOpenApi::Connection

  BASE_URI = 'http://data.ons.gov.uk/ons/api/data/'
  API_KEY = ENV['ONS_APIKEY']

  def get(resource, args={})
    to_object request(resource, "get", args)
  end

  def post(resource, args={})
    to_object request(resource, "post", args)
  end

  def to_object json
    json.gsub!('"@', '"')
    json.gsub!('xml.lang','xml_lang')
    json.gsub!('"$":','"text":')
    json.gsub!('"2011WARDH" : {', '"X2011WARDH" : {')
    json.gsub!('"2011HTWARDH" : {', '"X2011HTWARDH" : {')
    hash = JSON.parse json
    Morph.from_hash hash, OnsOpenApi
  end

  def request_uri(resource, args)
    unless API_KEY
      raise 'No ONS OpenAPI key found. Set this environment variable: ONS_APIKEY=<your_ons_openapi_key>'
    end
    uri = URI.join(BASE_URI, (resource+'.json').sub('.json.json','.json') )

    args ||= {}
    args.delete('apikey')
    args.merge!( apikey: API_KEY )
    uri.query = args.map { |k,v| "%s=%s" % [URI.encode(k.to_s), URI.encode(v.to_s)] }.join("&") if args

    puts uri.to_s
    uri
  end

  def request(resource, method="get", args)
    uri = request_uri resource, args
    case method
    when "get"
      req = Net::HTTP::Get.new(uri.request_uri)
    when "post"
      req = Net::HTTP::Post.new(uri.request_uri)
    end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.port == 443)

    res = http.start() { |conn| conn.request(req) }
    res.body
  end

end

module OnsOpenApi

  class << self
    include OnsOpenApi::Connection
  end

end
