class CreateProductHasCategories < ActiveRecord::Migration
  def change
    create_table :product_has_categories do |t|
      t.integer :product_id
      t.integer :category_id

      t.timestamps
    end
  end
end
