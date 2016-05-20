class OnsOpenApi::Context

  include Morph

  class << self
    def all
      @contexts ||= OnsOpenApi::get('contexts').context_list.statistical_contexts.map {|x| new x}
    end
  end

  def initialize x
    self.id = x.context_id
    self.name = x.context_name
  end

  def concepts
    @concepts ||= OnsOpenApi::get('concepts', context: @name).concept_list.concepts
  end

  def collections
    @collections ||= OnsOpenApi::get('collections', context: @name).collection_list.collections
    unless @collections.first.respond_to?(:context_name) && @collections.first.context_name
      @collections.each {|c| c.context_name = @name}
    end
    @collections
  end

  def classifications
    @classifications ||= OnsOpenApi::get('classifications', context: @name).classification_list.classifications
  end

  def collection id_or_name
    collection = collections.detect{|c| (c.id == id_or_name || c.title == id_or_name) }

    unless collection
      list = collections.select{|c| c.name == id_or_name}
      if list.size > 1
        cmds = list.map{|c| [c.id,c.title]}.flatten.map{|n| "collection('#{n}')"}
        raise "more than one match, try one of:\n\n  #{cmds.join("  \n\n  ") }\n\n"
      else
        collection = list.first
      end
    end

    collection
  end

  def concept_names
    names_for concepts
  end

  def collection_names
    names_for collections
  end

  def classification_names
    names_for classifications
  end

  # Returns geography objects for given geography code.
  #
  # Parameter +code+ defaults to +'2014WARDH'+ for the 2014 Administrative
  # Hierarchy, if no +code+ supplied.
  #
  # Option +levels+ defaults to +'0,1,2,3,4,5,6,7'+. You can specify levels,
  # e.g. geographies('2011WARDH', levels: '0,1,2,3,4,5')
  #
  # Codes include:
  # +2011WARDH+ - 2011 Administrative Hierarchy
  # +2012WARDH+ - 2012 Administrative Hierarchy
  # +2013WARDH+ - 2013 Administrative Hierarchy
  # +2014WARDH+ - 2014 Administrative Hierarchy
  # +2011STATH+ - 2011 Statistical Geography Hierarchy
  # +2011PCONH+ - 2011 Westminster Parliamentary Constituency Hierarchy
  # +2011HTWARDH+ - 2011 Census Merged Ward Hierarchy
  # +2011CMLADH+ - 2011 Census merged local authority district hierarchy
  # +2011PARISH+ - 2011 Parish Hierarchy
  def geographies code='2011WARDH', option={ levels: '0,1,2,3,4,5,6,7' }
    @geographies ||= {}
    levels = if code == '2011STATH' && option[:levels][/6|7|8|9/] # restrict levels to reduce delay
               '0,1,2,3,4,5'
             else # hierarchies require levels param be set
               option[:levels]
             end

    key = [code, levels].join('-')
    unless @geographies[key]
      params = { context: @name, levels: levels }
      result = OnsOpenApi::get "hierarchies/hierarchy/#{code}", params
      @geographies[key] = result.geography_list.items.items
    end
    @geographies[key].each {|g| g.geography_code = code }
    @geographies[key]
  end

  # Returns geography objects from the given Administrative Hierarchy
  # with area type 'Electoral Division'.
  #
  # Parameter +code+ defaults to +'2014WARDH'+ for the 2014 Administrative
  # Hierarchy, if no +code+ supplied.
  def electoral_divisions code='2014WARDH'
    geographies(code).select {|z| z.area_type.codename['Electoral Division']}
  end

  # Returns geography objects from the given Administrative Hierarchy
  # with area type 'Electoral Ward/Division'
  #
  # Parameter +code+ defaults to +'2014WARDH'+ for the 2014 Administrative
  # Hierarchy, if no +code+ supplied.
  def electoral_wards code='2014WARDH'
    geographies(code).select {|z| z.area_type.codename['Electoral Ward/Division']}
  end

  private

  def names_for list
    list.map(&:title)
  end

end