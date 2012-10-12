class Category < ActiveRecord::Base
  attr_accessible :name, :parent_id

  has_many :categories, :foreign_key => :parent_id
  belongs_to :parent, :foreign_key => :parent_id, :class_name => "Category"

  def self.token_json(items)
    items.map{|i| {:id => i.id, :name => i.name} }
  end
end
