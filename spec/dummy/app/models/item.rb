class Item < ActiveRecord::Base
  attr_accessible :category_id, :name

  belongs_to :category
end
