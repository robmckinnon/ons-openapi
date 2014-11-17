class OnsOpenApi::Value

  include Morph

  def values
    keys = methods.select{|x| x[/^_\d+$/]}
    keys.each_with_object([]) {|k,a| index = Integer(k.to_s.sub('_','')) ; a[index] = send(k) }
  end

  def labelled_values dimension
    labels = dimension.labels
    list = []
    values.each_with_index {|v,i| list << [labels[i], v]}
    list
  end

end