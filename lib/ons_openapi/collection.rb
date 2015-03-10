class OnsOpenApi::Collection

  include Morph
  include OnsOpenApi::DataHelper

  # Returns title, i.e. "id name"
  def title
    [id, name].join(' ')
  end

  # Returns data as array of arrays, for a geography that matches label_or_code.
  # e.g. data_for('England'), data_for('Islington S'), data_for('E05002040')
  # Raises exception if no match or more than one match.
  def data_for label_or_code
    if geographies = geography(label_or_code)
      if geographies.size > 1
        cmds = geographies.map do |g|
          "data_for('#{g.title}') or data_for('#{g.item_code}') see #{g.geography_code} http://statistics.data.gov.uk/doc/statistical-geography/#{g.item_code}"}
        end
        raise "more than one match, try one of:\n\n  #{cmds.join("  \n\n  ") }\n\n"
      else
        geo = geographies.first
        data geo.item_code, geo.geography_code
      end
    end
  end

  # Returns data for given geog_code, geog, and optional JSON-stat command.
  def data geog_code, geog, stat='.toTable()'
    @json_stats ||={}
    @json_stats[geog_code + geog] ||= OnsOpenApi::request("dataset/#{id}",
        context: context_name,
        geog: geog,
        "dm/#{geog}" => geog_code,
        totals: 'false',
        jsontype: 'json-stat')

    raw_json_stat = @json_stats[geog_code + geog].gsub("\n", ' ').gsub("'", "").squeeze(' ')

    if raw_json_stat.include?('ns1faultstring')
      raise "ONS Exception: #{raw_json_stat.gsub(/(<.?ns1XMLFault>)|(<.?ns1faultstring>)/,'')}"
    elsif raw_json_stat.include?('errorMessage')
      raise "ONS Error: #{raw_json_stat}"
    end

    begin
      table = js_context.eval( %Q| JSONstat( JSON.parse(' #{raw_json_stat} ') ).Dataset(0)#{stat} | )
    rescue Encoding::UndefinedConversionError => e
      if e.to_s[/ASCII-8BIT to UTF-8/]
        raw_json_stat = raw_json_stat.force_encoding('ASCII-8BIT').encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '?')
        table = js_context.eval( %Q| JSONstat( JSON.parse(' #{raw_json_stat} ') ).Dataset(0)#{stat} | )
      else
        raise "#{e.to_s}: #{raw_json_stat}"
      end
    rescue ExecJS::RuntimeError, ExecJS::ProgramError => e
      raise "#{e.to_s}: #{raw_json_stat}"
    end

    if table.is_a?(Array) && (index = table[1].index('Segment_1'))
      table.each {|row| row.delete_at(index)}
    end
    table
  end

  #
  # Returns array of [geography_code, description] that are supported by this
  # collection.
  #
  # e.g.
  # 2011WARDH - 2011 Administrative Hierarchy
  # 2011STATH - 2011 Statistical Geography Hierarchy
  # 2011PCONH - 2011 Westminster Parliamentary Constituency Hierarchy
  # 2011HTWARDH - 2011 Census Merged Ward Hierarchy
  # 2011CMLADH - 2011 Census merged local authority district hierarchy
  # 2011PARISH - 2011 Parish Hierarchy
  #
  def geography_codes
    gh ||= geographical_hierarchies
    @geographies_data ||= if gh.respond_to?(:geographical_hierarchy) && gh.geographical_hierarchy
      url, args = gh.geographical_hierarchy.url
      OnsOpenApi::get(url, args)
    elsif gh.respond_to?(:geographical_hierarchies) && gh.geographical_hierarchies
      url, args = gh.geographical_hierarchies.first.url
      OnsOpenApi::get(url, args)
    end

    if @geographies_data
      list = @geographies_data.geographical_hierarchy_list
      if list.respond_to?(:geographical_hierarchy) && list.geographical_hierarchy
        [ [list.geographical_hierarchy.id, list.geographical_hierarchy.name] ]
      elsif list.respond_to?(:geographical_hierarchies) && list.geographical_hierarchies
        list.geographical_hierarchies.map{|x| [x.id, x.name]}
      else
        []
      end
    else
      []
    end
  end

  # Returns geography item that matches given label_or_code.
  # Raises exception if there is no match.
  def geography label_or_code
    if matches = geography_exact_match(label_or_code) || geography_partial_match(label_or_code)
      matches
    else
      raise "no geography match found for: #{label_or_code}"
    end
  end

  # Returns collection_detail object.
  def collection_detail
    OnsOpenApi::get(url.first, url.last).collection_detail
  end

  # Returns hash of geography code to list of geography items.
  def geographies
    codes = geography_codes.map(&:first)
    codes.each_with_object({}) do |code, hash|
      hash[code] = OnsOpenApi.context(context_name).geographies(code)
    end
  end

  private

  def geography_exact_match label_or_code
    matches = []
    geographies.values.each do |list|
      found = list.select{|c| (c.label == label_or_code) || (c.item_code == label_or_code) || (c.title == label_or_code) }
      matches += found unless found.empty?
    end
    matches.empty? ? nil : matches.uniq {|m| m.item_code}
  end

  def geography_partial_match label_or_code
    matches = []
    geographies.values.each do |list|
      found = list.select{|c| c.label[label_or_code] }
      matches += found unless found.empty?
    end
    matches.empty? ? nil : matches.uniq {|m| m.item_code}
  end

  def js_context
    unless @js_context
      jsonstatjs = File.expand_path('../../../vendor/json-stat.max.js', __FILE__)
      source = open(jsonstatjs).read
      @js_context = ExecJS.compile(source)
    end
    @js_context
  end

end