class Category < ActiveRecord::Base

  has_many :categories, :foreign_key => :parent_id
  belongs_to :parent, :foreign_key => :parent_id, :class_name => "Category"

  def to_token
    {:id => id, :name => name}
  end
end
