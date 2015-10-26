# coding: UTF-8
require 'spec_helper'

describe "ManyToManyTreeStructure - Products" do
  let!(:shoes) { create(:category, :name => "shoes") }
  let!(:skirt) { create(:category, :name => "skirt") }
  let!(:pents) { create(:category, :name => "pents") }

  context "without javascript" do
    it "is be possible to add new element" do
      visit new_product_path

      fill_in "product_name", :with => "hello"
      fill_in "product_category_ids", :with => "#{pents.id}, #{shoes.id}"
      click_button "Create Product"

      expect(page).to have_content("hello - [#{pents.id}, #{shoes.id}]")

      expect(Product.last.categories.map(&:id)).to eq ([pents.id, shoes.id])
    end

    it "is possible to edit element" do
      product = create(:product, :name => "product", :category_ids => [shoes.id, pents.id])
      expect(product.categories.map(&:id)).to eq([shoes.id, pents.id])

      visit edit_product_path(product)

      fill_in "product_category_ids_#{product.id}", :with => "#{skirt.id}, #{shoes.id}"
      click_button "Update Product"

      expect(page).to have_content("Products")

      expect(product.reload.categories.map(&:id)).to eq([skirt.id, shoes.id].sort)
    end
  end

  context "with javascript", :js => true do
    it "is possible to add new element" do
      visit new_product_path

      fill_in "product_name", :with => "hello"
      fill_in_token "product_category_ids", :with => "shoes"
      fill_in_token "product_category_ids", :with => "pents"
      click_button "Create Product"

      expect(page).to have_content("hello")
      expect(page).to have_content("hello - [#{shoes.id}, #{pents.id}]")

      expect(Product.last.categories.map(&:id)).to eq([shoes.id, pents.id])
    end

    it "is possible to edit element" do
      product = create(:product, :name => "product", :category_ids => [shoes.id, pents.id])
      expect(product.categories.map(&:id)).to eq([shoes.id, pents.id])

      visit edit_product_path(product)

      clear_token "product_category_ids_#{product.id}"
      fill_in_token "product_category_ids_#{product.id}", :with => "skirt"
      fill_in_token "product_category_ids_#{product.id}", :with => "shoes"
      click_button "Update Product"

      expect(page).to have_content("Products")

      expect(product.reload.categories.map(&:id).sort).to eq([skirt.id, shoes.id].sort)
    end
  end
end