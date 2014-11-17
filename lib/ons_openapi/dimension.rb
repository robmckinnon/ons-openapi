class OnsOpenApi::Dimension

  include Morph

  def values
    ids.each_with_object({}) do |x, h|
      h[alt_label(x)] = send(method(x))
    end
  end

  def labels
    data = values
    non_data_keys = role.morph_attributes.values.flatten.map{|x| alt_label x}
    non_data_keys.each do |k|
      data.delete(k)
    end
    data = data.values.first.category

    key_to_index = data.index.morph_attributes
    key_to_label = data.label.morph_attributes

    labels = key_to_index.to_a.each_with_object([]) do |k_i, a|
      if index = k_i[1]
        key = k_i[0]
        a[index] = key_to_label[key]
      end
    end

    # label = data.label
    # items = data.category.index
    # labels = data.category.label
  end

  private

  def alt_label x
    x['2011WARDH'] ? 'X2011_WARDH' : x
    x['2011HTWARDH'] ? 'X2011_HTWARDH' : x
  end

  def method x
    x = alt_label x
    method = Morph::InstanceMethods::Helper.convert_to_morph_method_name x
  end

end