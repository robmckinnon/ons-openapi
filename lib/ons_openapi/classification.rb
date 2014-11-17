class OnsOpenApi::Classification

  include Morph
  include OnsOpenApi::DataHelper

  def classification_detail
    OnsOpenApi::get(url.first, url.last).classification_detail
  end

end