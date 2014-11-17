class OnsOpenApi::Item

  include Morph

  def label
    labels.labels.first.text
  end

  def title
    [item_code, label].join(' ')
  end

end