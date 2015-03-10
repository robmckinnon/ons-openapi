class OnsOpenApi::Item

  include Morph

  def label
    labels.labels.first.text
  end

  def title
    [item_code, label].join(' ')
  end

  # Returns parent of this item instance from given array of areas.
  def parent areas
    areas.detect {|a| a.item_code == parent_code}
  end

end