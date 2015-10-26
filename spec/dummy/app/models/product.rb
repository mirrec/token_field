class Product < ActiveRecord::Base

  has_many :product_has_categories
  has_many :categories, :through => :product_has_categories

  alias_method :category_ids_old=, :category_ids=

  def category_ids=(ids)
    ids = ids.split(",").map(&:to_i) if ids.is_a?(String)
    self.category_ids_old=ids
  end
end
